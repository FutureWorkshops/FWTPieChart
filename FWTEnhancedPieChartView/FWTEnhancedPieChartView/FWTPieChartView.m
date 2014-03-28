//
//  FWTPieChartView.m
//  FWTEnhancedPieChartView
//
//  Created by Carlos Vidal on 27/03/2014.
//
//

#import "FWTPieChartView.h"
#import "FWTPiePortionLayer.h"
#import <QuartzCore/QuartzCore.h>

@interface FWTPieChartView ()

@property (nonatomic, strong) CALayer *containerLayer;

@end

@implementation FWTPieChartView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self != nil){
        self.backgroundColor = [UIColor clearColor];
        self->_animationCompletionPercent = 0.1f;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.containerLayer.frame = self.bounds;
}

- (void)animate
{
    FWTPiePortionLayer *theLayer = self.containerLayer.sublayers.firstObject;
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
        CABasicAnimation *animation = (CABasicAnimation *)[theLayer actionForKey:@"animationCompletionPercent"];
        animation.toValue = @100.f;
        theLayer.animationCompletionPercent = ((NSNumber*)animation.toValue).floatValue;
        [theLayer addAnimation:animation forKey:@"animationCompletionPercent"];
    
    [CATransaction commit];
}

- (CALayer *)containerLayer
{
    if (self->_containerLayer == nil){
        self->_containerLayer = [[CALayer alloc] init];
        self->_containerLayer.frame = self.bounds;
        
        FWTPiePortionLayer *portionLayer = [[FWTPiePortionLayer alloc] init];
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

