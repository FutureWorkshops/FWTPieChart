//
//  FWTPiePortionLayer.m
//  FWTEnhancedPieChartView
//
//  Created by Carlos Vidal on 27/03/2014.
//
//

#import "FWTPieChartLayer.h"

CGFloat FLOAT_M_PI = 3.141592653f;

@interface FWTPieChartLayer ()

@end

@implementation FWTPieChartLayer

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
    
    CGRect rect = CGContextGetClipBoundingBox(ctx);
    CGContextClearRect(ctx, rect);
    
    CGContextSaveGState(ctx);
    
    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    
    CGFloat startAngle = self.startAngle;
    CGFloat maxAngle = (FLOAT_M_PI*2);
    
    CGFloat outerRadius = CGRectGetMidY(rect)-50.f;
    CGFloat innerRadius = (CGRectGetMidY(rect)-50.f) * 0.5f;
    CGFloat lettersCenterRadius = innerRadius + ((outerRadius-innerRadius)*0.5f);
    
    CGFloat diagonalLineLength = CGRectGetMidY(rect)-28.f;
    CGFloat horizontalLineLength = 17.f;
    
    for (int i = 0; i < self.values.count; i++){
        CGFloat value = ((NSNumber*)self.values[i]).floatValue;
        CGColorRef segmentColor = ((UIColor*)self.colors[i]).CGColor;
        CGFloat segmentAngle = maxAngle*value*self.animationCompletionPercent;
        CGPoint limit = CGPointMake(center.x + diagonalLineLength * cosf(startAngle+(segmentAngle*0.5f)),
                                    center.y + diagonalLineLength * sinf(startAngle+(segmentAngle*0.5f)));
        
        //Draw line
        if (self.animationCompletionPercent > 0){
            CGContextSetLineWidth(ctx, 3.f);
            CGContextSetStrokeColorWithColor(ctx, segmentColor);
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
        CGFloat endAngle = startAngle + segmentAngle;
        
        CGContextSetFillColorWithColor(ctx, segmentColor);
        CGContextMoveToPoint(ctx, center.x, center.y);
        CGContextAddArc(ctx, center.x, center.y, outerRadius, startAngle, endAngle, 0);
        CGContextClosePath(ctx);
        CGContextFillPath(ctx);
        
        //Draw separator
        CGContextSetLineWidth(ctx, 3.f);
        CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx, center.x, center.y);
        CGPoint separatorLimit = CGPointMake(center.x + outerRadius * cosf(startAngle+0.011f),
                            center.y + outerRadius * sinf(startAngle+0.011f));
        CGContextAddLineToPoint(ctx, separatorLimit.x, separatorLimit.y);
        
        CGContextStrokePath(ctx);
        
        //Draw inner letter
        if (((NSNumber*)self.values[i]).floatValue >= 0.06f){
            CGSize textSize = [self.innerTexts[i] sizeWithFont:[self _innerLetterFont]];
            
            CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
            CGPoint letterCenter = CGPointMake(center.x - (textSize.width*0.5f) + lettersCenterRadius * cosf(startAngle+(segmentAngle*0.5f)),
                                               center.y - (textSize.height*0.5f) + lettersCenterRadius * sinf(startAngle+(segmentAngle*0.5f)));
            
            UIGraphicsPushContext(ctx);
            
            [self.innerTexts[i] drawAtPoint:letterCenter
                                   forWidth:textSize.width
                                   withFont:[self _innerLetterFont]
                              lineBreakMode:NSLineBreakByClipping];
            
            UIGraphicsPopContext();
        }
        
        //Draw outter text
        if (self.animationCompletionPercent > 0.f){
            CGSize textSize = [self.outterTexts[i] sizeWithFont:[self _outterLetterFont]];
            CGContextSetFillColorWithColor(ctx, segmentColor);
            
            CGPoint textPoint;
            
            if (limit.x > center.x){
                textPoint = CGPointMake(limit.x+horizontalLineLength+5.f, limit.y-textSize.height+8.f);
            }
            else{
                textPoint = CGPointMake(limit.x-horizontalLineLength-textSize.width-5.f, limit.y-textSize.height+8.f);
            }
            
            UIGraphicsPushContext(ctx);
            
            [self.outterTexts[i] drawAtPoint:textPoint
                                   forWidth:textSize.width
                                   withFont:[self _outterLetterFont]
                              lineBreakMode:NSLineBreakByClipping];
            
            UIGraphicsPopContext();
        }
        
        //Draw percentage text
        if (self.animationCompletionPercent > 0.f){
            NSString *percentText = [NSString stringWithFormat:@"%.0f%%",value*100*self.animationCompletionPercent];
            CGSize textSize = [percentText sizeWithFont:[self _percentageFont]];
            CGContextSetFillColorWithColor(ctx, [UIColor lightGrayColor].CGColor);
            
            CGPoint textPoint;
            
            if (limit.x > center.x){
                textPoint = CGPointMake(limit.x+horizontalLineLength+5.f, limit.y+3.f);
            }
            else{
                textPoint = CGPointMake(limit.x-horizontalLineLength-textSize.width-5.f, limit.y+3.f);
            }
            
            UIGraphicsPushContext(ctx);
            
            [percentText drawAtPoint:textPoint
                     forWidth:textSize.width
                     withFont:[self _percentageFont]
                lineBreakMode:NSLineBreakByClipping];
            
            UIGraphicsPopContext();
        }
        
        startAngle = endAngle;
    }
    
    CGColorRef innerPieColor = [[UIColor whiteColor] CGColor];
    
    // Draw inner circle
    CGContextSetFillColorWithColor(ctx, innerPieColor);
    CGContextMoveToPoint(ctx, center.x, center.y);
    CGContextAddArc(ctx, center.x, center.y, innerRadius, -FLOAT_M_PI / 2, 2*FLOAT_M_PI, 0);
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

#pragma mark - Lazy loading
- (UIFont*)_innerLetterFont
{
    return [UIFont fontWithName:@"HelveticaNeue" size:30.f];
}

- (UIFont*)_outterLetterFont
{
    return [UIFont fontWithName:@"HelveticaNeue" size:35.f];
}

- (UIFont*)_percentageFont
{
    return [UIFont fontWithName:@"HelveticaNeue" size:19.f];
}

@end

