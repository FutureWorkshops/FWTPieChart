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
    self->_outerTexts = nil;
}

- (id)init
{
    self = [super init];
    
    if (self != nil){
        self.needsDisplayOnBoundsChange = YES;
        
        self->_shouldDrawSeparators = YES;
        self->_shouldDrawPercentages = YES;
        self->_startAngle = -FLOAT_M_PI / 2.f;
        self->_animationCompletionPercent = 0.f;
        self->_innerCircleProportionalRadius = 0.5f;
        self->_font = [UIFont fontWithName:@"HelveticaNeue" size:20.f];
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
        self->_font = source.font;
        self->_colors = source.colors;
        self->_values = source.values;
        self->_startAngle = source.startAngle;
        self->_innerTexts = source.innerTexts;
        self->_outerTexts = source.outerTexts;
        self->_shouldDrawSeparators = source.shouldDrawSeparators;
        self->_shouldDrawPercentages = source.shouldDrawPercentages;
        self->_animationCompletionPercent = source.animationCompletionPercent;
        self->_innerCircleProportionalRadius = source.innerCircleProportionalRadius;
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
    float innerRadius = outerRadius * self.innerCircleProportionalRadius;
    float lettersRadius = MAX(innerRadius, outerRadius*0.4f);
    float lettersCenterRadius = lettersRadius + ((outerRadius-lettersRadius)*0.5f);
    float diagonalLineLength = outerRadius*1.25f;
    float innerSpaceAvailable = outerRadius - lettersRadius;
    float outerSpaceAvailable = (((float)CGRectGetHeight(self.frame)) - diagonalLineLength)*0.3f;
    float horizontalLineLength = (outerSpaceAvailable*0.26f);
    
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
        if ((self.shouldDrawPercentages || [self.outerTexts[i] isEqualToString:@""] == NO) && self.animationCompletionPercent > 0 && value >= 0.07f){
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
            CGSize textSize = [self.innerTexts[i] sizeWithAttributes:[self _innerLetterAttributesWithSpaceAvailable:innerSpaceAvailable andTextColor:innerTextColor]];
            
            CGContextSetFillColorWithColor(ctx, innerTextColor.CGColor);
            CGPoint letterCenter = CGPointMake(center.x - (textSize.width*0.5f) + lettersCenterRadius * cosf(startAngle+(segmentAngle*0.5f)),
                                               center.y - (textSize.height*0.5f) + lettersCenterRadius * sinf(startAngle+(segmentAngle*0.5f)));
            
            UIGraphicsPushContext(ctx);
            
            [self.innerTexts[i] drawAtPoint:letterCenter
                             withAttributes:[self _innerLetterAttributesWithSpaceAvailable:innerSpaceAvailable andTextColor:innerTextColor]];
            
            UIGraphicsPopContext();
            
            //Draw outer text
            if (self.animationCompletionPercent > 0.f){
                UIColor *outerTextColor = segmentColor;
                CGSize outerTextSize = [self.outerTexts[i] sizeWithAttributes:[self _outerLetterAttributesWithSpaceAvailable:outerSpaceAvailable andTextColor:outerTextColor]];
                CGContextSetFillColorWithColor(ctx, outerTextColor.CGColor);
                
                CGFloat verticalOffset = outerTextSize.height*0.81f;
                
                if (self.shouldDrawPercentages == NO){
                    verticalOffset =  (outerTextSize.height*0.54f);
                }
                
                CGPoint textPoint;
                
                if (limit.x > center.x){
                    textPoint = CGPointMake(limit.x+horizontalLineLength+5.f, limit.y-verticalOffset);
                }
                else{
                    textPoint = CGPointMake(limit.x-horizontalLineLength-outerTextSize.width-5.f, limit.y-verticalOffset);
                }
                
                UIGraphicsPushContext(ctx);
                
                [self.outerTexts[i] drawAtPoint:textPoint
                                  withAttributes:[self _outerLetterAttributesWithSpaceAvailable:outerSpaceAvailable andTextColor:outerTextColor]];
                
                UIGraphicsPopContext();
            
                //Draw percentage text
                if (self.shouldDrawPercentages == YES){
                    UIColor *percentColor = [UIColor lightGrayColor];
                    NSString *percentText = [NSString stringWithFormat:@"%.0f%%",value*100*self.animationCompletionPercent];
                    CGSize percentSize = [percentText sizeWithAttributes:[self _percentageAttributesWithSpaceAvailable:outerSpaceAvailable andTextColor:percentColor]];
                    CGContextSetFillColorWithColor(ctx, percentColor.CGColor);
                    
                    verticalOffset = 5.f;
                    
                    if ([self.outerTexts[i] isEqualToString:@""]){
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
                              withAttributes:[self _percentageAttributesWithSpaceAvailable:outerSpaceAvailable andTextColor:percentColor]];

                    UIGraphicsPopContext();
                }
            }
        }
        
        [angles addObject:@(startAngle)];
        startAngle = endAngle;
    }
    
    CGColorRef innerPieColor = self.backgroundColor;

    //Draw separators
    if (self.shouldDrawSeparators && angles.count > 1){
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
    return [UIFont fontWithName:self.font.fontName size:spaceAvaliable*0.5f];
}

- (NSDictionary*)_outerLetterAttributesWithSpaceAvailable:(CGFloat)spaceAvaliable andTextColor:(UIColor*)color
{
    return @{NSFontAttributeName:[self _outerLetterFontWithSpaceAvailable:spaceAvaliable],
             NSForegroundColorAttributeName:color};
}

- (UIFont*)_outerLetterFontWithSpaceAvailable:(CGFloat)spaceAvaliable
{
    return [UIFont fontWithName:self.font.fontName size:spaceAvaliable*0.58f];
}

- (NSDictionary*)_percentageAttributesWithSpaceAvailable:(CGFloat)spaceAvaliable andTextColor:(UIColor*)color
{
    return @{NSFontAttributeName:[self _percentageFontWithSpaceAvailable:spaceAvaliable],
             NSForegroundColorAttributeName:color};
}

- (UIFont*)_percentageFontWithSpaceAvailable:(CGFloat)spaceAvaliable
{
    return [UIFont fontWithName:self.font.fontName size:spaceAvaliable*0.35f];
}

@end

