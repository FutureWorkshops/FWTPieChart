//
//  FWTPiePortionLayer.m
//  FWTEnhancedPieChartView
//
//  Created by Carlos Vidal on 27/03/2014.
//
//

#import "FWTPieChartLayer.h"

float FLOAT_M_PI = 3.141592653f;

@interface FWTPieChartLayer ()

@end

@implementation FWTPieChartLayer

- (void)dealloc
{
    self->_values = nil;
    self->_colors = nil;
    self->_innerTexts = nil;
    self->_outterTexts = nil;
}

- (id)init
{
    self = [super init];
    
    if (self != nil){
        
        self.needsDisplayOnBoundsChange = YES;
        self->_animationCompletionPercent = 0.f;
        
        [CATransaction commit];
    }
    
    return self;
}

- (id)initWithLayer:(id)layer
{
    if ((self = [super initWithLayer:layer]))
    {
        self.needsDisplayOnBoundsChange = YES;
        
        FWTPieChartLayer *source = (FWTPieChartLayer *)layer;
        self.backgroundColor = source.backgroundColor;
        self->_startAngle = source.startAngle;
        self->_colors = source.colors;
        self->_values = source.values;
        self->_innerTexts = source.innerTexts;
        self->_outterTexts = source.outterTexts;
        self->_animationCompletionPercent = source.animationCompletionPercent;
    }
    
    return self;
}


- (void)drawInContext:(CGContextRef)ctx
{
    [super drawInContext:ctx];
    
    if (self.values.count == 0){
        return;
    }
    
    NSMutableArray *angles = [NSMutableArray array];
    
    CGRect rect = CGContextGetClipBoundingBox(ctx);
    CGContextClearRect(ctx, rect);
    
    CGContextSaveGState(ctx);
    
    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    
    float startAngle = self.startAngle;
    float maxAngle = (FLOAT_M_PI*2);
    
    float outerRadius = ((float)CGRectGetMidY(rect))*0.65f;
    float innerRadius = outerRadius * 0.5f;
    float spaceAvailable = outerRadius - innerRadius;
    float lettersCenterRadius = innerRadius + ((outerRadius-innerRadius)*0.5f);
    
    float diagonalLineLength = outerRadius*1.25f;
    float horizontalLineLength = (spaceAvailable*0.26f);
    
    for (int i = 0; i < self.values.count; i++){
        float value = ((NSNumber*)self.values[i]).floatValue;
        
        if (value == 0.f){
            continue;
        }
        
        UIColor *segmentColor = self.colors[i];
        CGColorRef segmentColorRef = segmentColor.CGColor;
        float segmentAngle = maxAngle*value*self.animationCompletionPercent;
        CGPoint limit = CGPointMake(center.x + diagonalLineLength * cosf(startAngle+(segmentAngle*0.5f)),
                                    center.y + diagonalLineLength * sinf(startAngle+(segmentAngle*0.5f)));
        
        //Draw line
        if (self.animationCompletionPercent > 0 && value >= 0.07f){
            CGContextSetLineWidth(ctx, 2.f);
            CGContextSetStrokeColorWithColor(ctx, segmentColorRef);
            CGContextBeginPath(ctx);
            CGContextMoveToPoint(ctx, center.x, center.y);
            CGContextAddLineToPoint(ctx, limit.x, limit.y);
            
            if (limit.x > center.x){
                CGContextAddLineToPoint(ctx, limit.x+horizontalLineLength, limit.y);
            }
            else{
                CGContextAddLineToPoint(ctx, limit.x-horizontalLineLength, limit.y);
            }
            
            CGContextStrokePath(ctx);
        }
        
        // Draw segment
        float endAngle = startAngle + segmentAngle;
        
        CGContextSetFillColorWithColor(ctx, segmentColorRef);
        CGContextMoveToPoint(ctx, center.x, center.y);
        CGContextAddArc(ctx, center.x, center.y, outerRadius, startAngle, endAngle, 0);
        CGContextClosePath(ctx);
        CGContextFillPath(ctx);
        
        //Draw inner letter
        if (value >= 0.07f){
            UIColor *innerTextColor = [UIColor whiteColor];
            CGSize textSize = [self.innerTexts[i] sizeWithAttributes:[self _innerLetterAttributesWithSpaceAvailable:spaceAvailable andTextColor:innerTextColor]];
            
            CGContextSetFillColorWithColor(ctx, innerTextColor.CGColor);
            CGPoint letterCenter = CGPointMake(center.x - (textSize.width*0.5f) + lettersCenterRadius * cosf(startAngle+(segmentAngle*0.5f)),
                                               center.y - (textSize.height*0.5f) + lettersCenterRadius * sinf(startAngle+(segmentAngle*0.5f)));
            
            UIGraphicsPushContext(ctx);
            
            [self.innerTexts[i] drawAtPoint:letterCenter
                             withAttributes:[self _innerLetterAttributesWithSpaceAvailable:spaceAvailable andTextColor:innerTextColor]];
            
            UIGraphicsPopContext();
        
        
            //Draw outter text
            if (self.animationCompletionPercent > 0.f){
                UIColor *outterTextColor = segmentColor;
                CGSize outterTextSize = [self.outterTexts[i] sizeWithAttributes:[self _outterLetterAttributesWithSpaceAvailable:spaceAvailable andTextColor:outterTextColor]];
                CGContextSetFillColorWithColor(ctx, outterTextColor.CGColor);
                
                CGPoint textPoint;
                
                if (limit.x > center.x){
                    textPoint = CGPointMake(limit.x+horizontalLineLength+5.f, limit.y-outterTextSize.height+8.f);
                }
                else{
                    textPoint = CGPointMake(limit.x-horizontalLineLength-outterTextSize.width-5.f, limit.y-outterTextSize.height+8.f);
                }
                
                UIGraphicsPushContext(ctx);
                
                [self.outterTexts[i] drawAtPoint:textPoint
                                  withAttributes:[self _outterLetterAttributesWithSpaceAvailable:spaceAvailable andTextColor:outterTextColor]];
                
                UIGraphicsPopContext();
            
                //Draw percentage text
                UIColor *percentColor = [UIColor lightGrayColor];
                NSString *percentText = [NSString stringWithFormat:@"%.0f%%",value*100*self.animationCompletionPercent];
                CGSize percentSize = [percentText sizeWithAttributes:[self _percentageAttributesWithSpaceAvailable:spaceAvailable andTextColor:percentColor]];
                CGContextSetFillColorWithColor(ctx, percentColor.CGColor);
                
                float verticalOffset = 5.f;
                
                if ([self.outterTexts[i] isEqualToString:@""]){
                    verticalOffset = -(((float)percentSize.height)*0.5f);
                }
                
                if (limit.x > center.x){
                    textPoint = CGPointMake(limit.x+horizontalLineLength+5.f, limit.y+verticalOffset);
                }
                else{
                    textPoint = CGPointMake(limit.x-horizontalLineLength-percentSize.width-5.f, limit.y+verticalOffset);
                }
                
                UIGraphicsPushContext(ctx);

                [percentText drawAtPoint:textPoint
                          withAttributes:[self _percentageAttributesWithSpaceAvailable:spaceAvailable andTextColor:percentColor]];

                UIGraphicsPopContext();
            }
        }
        
        [angles addObject:@(startAngle)];
        startAngle = endAngle;
    }
    
    CGColorRef innerPieColor = self.backgroundColor;

    //Draw separators
    if (angles.count > 1){
        for (NSNumber *angle in angles){
            CGContextSetLineWidth(ctx, 2.f);
            CGContextSetStrokeColorWithColor(ctx, innerPieColor);
            CGContextBeginPath(ctx);
            CGContextMoveToPoint(ctx, center.x, center.y);
            CGPoint separatorLimit = CGPointMake(center.x + outerRadius * cosf(angle.floatValue),
                                                 center.y + outerRadius * sinf(angle.floatValue));
            CGContextAddLineToPoint(ctx, separatorLimit.x, separatorLimit.y);
            
            CGContextStrokePath(ctx);
        }
    }
    
    // Draw inner circle
    CGContextSetFillColorWithColor(ctx, innerPieColor);
    CGContextMoveToPoint(ctx, center.x, center.y);
    CGContextAddArc(ctx, center.x, center.y, innerRadius, -FLOAT_M_PI/2, 2*FLOAT_M_PI, 0);
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);
    
    CGContextRestoreGState(ctx);
}

#pragma mark - CoreAnimation methods
+ (BOOL)needsDisplayForKey:(NSString *)key
{
    if ([key isEqualToString:@"animationCompletionPercent"]){
        return YES;
    }
    
    return [super needsDisplayForKey:key];
}

- (id<CAAction>)actionForKey:(NSString *)event
{
	if ([event isEqualToString:@"animationCompletionPercent"]){
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:event];
        animation.duration = 1.f;
        return animation;
	}
	
	return [super actionForKey:event];
}

#pragma mark - Private methods
- (NSDictionary*)_innerLetterAttributesWithSpaceAvailable:(CGFloat)spaceAvaliable andTextColor:(UIColor*)color
{
    return @{NSFontAttributeName:[self _innerLetterFontWithSpaceAvailable:spaceAvaliable],
             NSForegroundColorAttributeName:color};
}

- (UIFont*)_innerLetterFontWithSpaceAvailable:(CGFloat)spaceAvaliable
{
    return [UIFont fontWithName:@"HelveticaNeue" size:spaceAvaliable*0.5f];
}

- (NSDictionary*)_outterLetterAttributesWithSpaceAvailable:(CGFloat)spaceAvaliable andTextColor:(UIColor*)color
{
    return @{NSFontAttributeName:[self _outterLetterFontWithSpaceAvailable:spaceAvaliable],
             NSForegroundColorAttributeName:color};
}

- (UIFont*)_outterLetterFontWithSpaceAvailable:(CGFloat)spaceAvaliable
{
    return [UIFont fontWithName:@"HelveticaNeue" size:spaceAvaliable*0.58f];
}

- (NSDictionary*)_percentageAttributesWithSpaceAvailable:(CGFloat)spaceAvaliable andTextColor:(UIColor*)color
{
    return @{NSFontAttributeName:[self _percentageFontWithSpaceAvailable:spaceAvaliable],
             NSForegroundColorAttributeName:color};
}

- (UIFont*)_percentageFontWithSpaceAvailable:(CGFloat)spaceAvaliable
{
    return [UIFont fontWithName:@"HelveticaNeue" size:spaceAvaliable*0.35f];
}

@end

