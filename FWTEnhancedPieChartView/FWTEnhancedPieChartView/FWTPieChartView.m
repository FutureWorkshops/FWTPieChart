//
//  FWTPieChartView.m
//  FWTEnhancedPieChartView
//
//  Created by Carlos Vidal on 27/03/2014.
//
//

#import "FWTPieChartView.h"
#import "FWTPieChartLayer.h"
#import <QuartzCore/QuartzCore.h>

CGFloat FLOAT_M_PI_ = 3.141592653f;

@interface FWTPieChartView ()

@property (nonatomic, strong) CALayer *containerLayer;

@end

@implementation FWTPieChartView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self != nil){
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)animate
{
    FWTPieChartLayer *theLayer = self.containerLayer.sublayers.firstObject;
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    theLayer.values = @[@(0.22f),@(0.44f),@(0.34f)];
    theLayer.colors = @[[UIColor colorWithRed:22/255.f green:86/255.f blue:219/255.f alpha:1],
                        [UIColor colorWithRed:235/255.f green:81/255.f blue:29/255.f alpha:1],
                        [UIColor colorWithRed:98/255.f green:200/255.f blue:24/255.f alpha:1]];
    
    [CATransaction commit];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    CABasicAnimation *animation = (CABasicAnimation *)[theLayer actionForKey:@"animationCompletionPercent"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fromValue = @0.f;
    animation.toValue = @1.f;
    animation.byValue = @0.1f;
    
    [theLayer setAnimationCompletionPercent:((NSNumber*)animation.toValue).floatValue];
    [theLayer addAnimation:animation forKey:@"animationCompletionPercent"];
    
    [CATransaction commit];
}

- (CALayer *)containerLayer
{
    if (self->_containerLayer == nil){
        self->_containerLayer = [[CALayer alloc] init];
        self->_containerLayer.frame = self.bounds;
        
        FWTPieChartLayer *portionLayer = [[FWTPieChartLayer alloc] init];
        portionLayer.startAngle = -FLOAT_M_PI_ / 2;
        portionLayer.values = @[@(0.22f),@(0.44f),@(0.34f)];
        portionLayer.colors = @[[UIColor colorWithRed:22/255.f green:86/255.f blue:219/255.f alpha:1],
                            [UIColor colorWithRed:235/255.f green:81/255.f blue:29/255.f alpha:1],
                            [UIColor colorWithRed:98/255.f green:200/255.f blue:24/255.f alpha:1]];
        portionLayer.contentsScale = [UIScreen mainScreen].scale;
        portionLayer.frame = self->_containerLayer.frame;
        
        [self->_containerLayer addSublayer:portionLayer];
    }
    
    if (self->_containerLayer.superlayer == nil){
        [self.layer addSublayer:self->_containerLayer];
    }
    
    return self->_containerLayer;
}

@end

