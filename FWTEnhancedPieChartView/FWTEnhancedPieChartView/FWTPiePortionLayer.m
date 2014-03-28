//
//  FWTPiePortionLayer.m
//  FWTEnhancedPieChartView
//
//  Created by Carlos Vidal on 27/03/2014.
//
//

#import "FWTPiePortionLayer.h"

#import <QuartzCore/QuartzCore.h>

CGFloat FLOAT_M_PI = 3.141592653f;

@interface FWTPiePortionLayer ()

@property (nonatomic, strong) NSArray *values;
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, assign) CGFloat startAngle;

@end

@implementation FWTPiePortionLayer

- (id)init
{
    self = [super init];
    
    if (self != nil){
        self.needsDisplayOnBoundsChange = YES;
        
        self->_values = @[@(0.22f),@(0.44f),@(0.34f)];
        self->_colors = @[[UIColor colorWithRed:22/255.f green:86/255.f blue:219/255.f alpha:1],
                          [UIColor colorWithRed:235/255.f green:81/255.f blue:29/255.f alpha:1],
                          [UIColor colorWithRed:98/255.f green:200/255.f blue:24/255.f alpha:1]];
        
        self->_startAngle =  -FLOAT_M_PI / 2;
        self->_animationCompletionPercent = 0.f;
    }
    
    return self;
}

- (void)drawInContext:(CGContextRef)ctx
{
    [super drawInContext:ctx];
    
    CGRect rect = CGContextGetClipBoundingBox(ctx);
    CGContextClearRect(ctx, rect);
    
    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    
    CGFloat startAngle = self.startAngle;
    CGFloat maxAngle = (FLOAT_M_PI*2);
    
    CGFloat outerRadius = CGRectGetMidX(rect)-50.f;
    CGFloat innerRadius = (CGRectGetMidX(rect)-50.f) * 0.5f;
    CGFloat lettersCenterRadius = innerRadius + ((outerRadius-innerRadius)*0.5f);
    
    CGFloat diagonalLineLength = CGRectGetMidX(rect)-28.f;
    CGFloat horizontalLineLength = 17.f;
    
    for (int i = 0; i < self.values.count; i++){
        CGColorRef segmentColor = ((UIColor*)self.colors[i]).CGColor;
        
        CGFloat segmentAngle = (maxAngle*((NSNumber*)self.values[i]).floatValue)*(self.animationCompletionPercent/100.f);
        
        //Draw line
        CGContextSetLineWidth(ctx, 3.f);
        CGContextSetStrokeColorWithColor(ctx, segmentColor);
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx, center.x, center.y);
        CGPoint limit = CGPointMake(center.x + diagonalLineLength * cosf(startAngle+(segmentAngle*0.5f)),
                                    center.y + diagonalLineLength * sinf(startAngle+(segmentAngle*0.5f)));
        CGContextAddLineToPoint(ctx, limit.x, limit.y);
        
        if (limit.x > center.x){
            CGContextAddLineToPoint(ctx, limit.x+horizontalLineLength, limit.y);
        }
        else{
            CGContextAddLineToPoint(ctx, limit.x-horizontalLineLength, limit.y);
        }
        
        CGContextStrokePath(ctx);
        
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
        limit = CGPointMake(center.x + outerRadius * cosf(startAngle+0.015f),
                            center.y + outerRadius * sinf(startAngle+0.015f));
        CGContextAddLineToPoint(ctx, limit.x, limit.y);
        
        CGContextStrokePath(ctx);
        
        //Draw inner letter
        if (((NSNumber*)self.values[i]).floatValue >= 0.06f){
            CGPoint letterCenter = CGPointMake(center.x - 7.f + lettersCenterRadius * cosf(startAngle+(segmentAngle*0.5f)),
                                               center.y - 16.f + lettersCenterRadius * sinf(startAngle+(segmentAngle*0.5f)));
            [@"B" drawAtPoint:letterCenter withAttributes:[self _innerLetterAttributes]];
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
}

#pragma mark - CoreAnimation methods
+ (BOOL)needsDisplayForKey:(NSString *)key
{
    if ([key isEqualToString:@"animationCompletionPercent"]){
        return YES;
    }
    else{
        return [super needsDisplayForKey:key];
    }
}

- (id<CAAction>)actionForKey:(NSString *)event {
	if ([event isEqualToString:@"animationCompletionPercent"])
    {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:event];
        animation.duration = 2.f;
        animation.fromValue = @(self.animationCompletionPercent);
        return animation;
	}
	
	return [super actionForKey:event];
}

#pragma mark - Lazy loading

- (NSDictionary*)_innerLetterAttributes
{
    return @{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:30.f],
             NSForegroundColorAttributeName:[UIColor whiteColor]};
}

@end

