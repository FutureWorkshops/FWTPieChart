//
//  FWTPieChartView.m
//  FWTPieChartView
//
//  Created by Carlos Vidal on 05/04/2014.
//  Copyright (c) 2014 Carlos Vidal. All rights reserved.
//


#import "FWTPieChartView.h"
#import "FWTPieChartLayer.h"

//FWTPieChartSegmentData
@interface FWTPieChartSegmentData()

@end

@implementation FWTPieChartSegmentData

+ (FWTPieChartSegmentData*)pieChartSegmentWithValue:(NSNumber*)value
                                              color:(UIColor*)color
                                          innerText:(NSString*)innerText
                                       andOuterText:(NSString*)outerText
{
    FWTPieChartSegmentData *segmentData = [[FWTPieChartSegmentData alloc] init];
    segmentData.value = value != nil ? value : @(0.f);
    segmentData.color = color != nil ? color : [UIColor whiteColor];
    segmentData.innerText = innerText != nil ? innerText : @"";
    segmentData.outerText = outerText != nil ? outerText : @"";
    
    return segmentData;
}

@end


//FWTPieChartView
float FLOAT_M_PI_ = 3.141592653f;

@interface FWTPieChartView ()

@property (nonatomic, strong) CALayer *containerLayer;

@end

@implementation FWTPieChartView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self != nil){
        self.backgroundColor = [UIColor clearColor];
        self->_animationDuration = 1.f;
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.animationDuration = 1.f;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    for (CALayer *sublayer in self.containerLayer.sublayers){
        [sublayer setFrame:self.bounds];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.containerLayer.frame = self.bounds;
    self.containerLayer.position = (CGPoint){ CGRectGetMidX(self.bounds) - CGRectGetMinX(self.frame), CGRectGetMidY(self.bounds) - CGRectGetMinY(self.frame) };
}

#pragma mark - Public methods
- (void)addSegment:(FWTPieChartSegmentData*)segmentData
{
    NSMutableArray *segmentsTemp = [NSMutableArray arrayWithArray:self.segments];
    [segmentsTemp addObject:segmentData];
    
    self.segments = segmentsTemp;
}

- (FWTPieChartSegmentData*)addSegmentWithValue:(NSNumber*)value color:(UIColor*)color innerText:(NSString*)innerText andouterText:(NSString*)outerText
{
    FWTPieChartSegmentData *segmentData = [FWTPieChartSegmentData pieChartSegmentWithValue:value color:color innerText:innerText andOuterText:outerText];
    [self addSegment:segmentData];
    
    return segmentData;
}

- (void)removeSegment:(FWTPieChartSegmentData*)segmentData
{
    NSMutableArray *segmentsTemp = [NSMutableArray arrayWithArray:self.segments];
    
    if ([segmentsTemp containsObject:segmentData]){
        [segmentsTemp removeObject:segmentData];
    }
    
    self.segments = segmentsTemp;
}

- (void)clearSegments
{
    NSMutableArray *segmentsTemp = [NSMutableArray arrayWithArray:self.segments];
    [segmentsTemp removeAllObjects];
    
    self.segments = segmentsTemp;
}

- (void)reloadAnimated:(BOOL)animated withCompletionBlock:(void(^)())completionBlock
{
    FWTPieChartLayer *pieLayer = self.containerLayer.sublayers.firstObject;
    
    if (animated) {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
    }
        
    pieLayer.values = [self _values];
    pieLayer.colors = [self _colors];
    pieLayer.innerTexts = [self _innerTexts];
    pieLayer.innerCircleColor = self.innerCircleColor;
    pieLayer.outerTexts = [self _outerTexts];
    pieLayer.font = self.font;
    pieLayer.shouldDrawSeparators = self.shouldDrawSeparators;
    pieLayer.shouldDrawPercentages = self.shouldDrawPercentages;
    pieLayer.innerCircleProportionalRadius = self.innerCircleProportionalRadius;
    [pieLayer setNeedsDisplay];
    
    if (animated) {
        [CATransaction commit];
        
        [CATransaction begin];
        [CATransaction setCompletionBlock:completionBlock];
        [CATransaction setDisableActions:YES];
        
        CABasicAnimation *animation = (CABasicAnimation *)[pieLayer actionForKey:@"animationCompletionPercent"];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.duration = self.animationDuration;
        animation.fromValue = animated ? @0.f : @1.f;
        animation.toValue = @1.f;
        animation.byValue = @0.1f;
        
        [pieLayer setAnimationCompletionPercent:((NSNumber*)animation.toValue).floatValue];
        [pieLayer addAnimation:animation forKey:@"animationCompletionPercent"];
        
        [CATransaction commit];
    } else {
        if (completionBlock)
            completionBlock();
    }
}

#pragma mark - Private methods
- (NSArray*)_values
{
    NSMutableArray *array = [NSMutableArray array];
    for (FWTPieChartSegmentData *data in self.segments){
        [array addObject:data.value];
    }
    return array;
}

- (NSArray*)_colors
{
    NSMutableArray *array = [NSMutableArray array];
    for (FWTPieChartSegmentData *data in self.segments){
        [array addObject:data.color];
    }
    return array;
}

- (NSArray*)_innerTexts
{
    NSMutableArray *array = [NSMutableArray array];
    for (FWTPieChartSegmentData *data in self.segments){
        [array addObject:data.innerText];
    }
    return array;
}

- (NSArray*)_outerTexts
{
    NSMutableArray *array = [NSMutableArray array];
    for (FWTPieChartSegmentData *data in self.segments){
        [array addObject:data.outerText];
    }
    return array;
}

#pragma mark - Lazy loading
- (CALayer *)containerLayer
{
    if (self->_containerLayer == nil){
        self->_containerLayer = [[CALayer alloc] init];
        self->_containerLayer.frame = self.bounds;
        
        FWTPieChartLayer *portionLayer = [[FWTPieChartLayer alloc] init];
        portionLayer.startAngle = -FLOAT_M_PI_ / 2.f;
        portionLayer.values = [self _values];
        portionLayer.colors = [self _colors];
        portionLayer.innerTexts = [self _innerTexts];
        portionLayer.outerTexts = [self _outerTexts];
        portionLayer.innerCircleColor = self.innerCircleColor;
        portionLayer.backgroundColor = [UIColor clearColor].CGColor;
        portionLayer.contentsScale = [UIScreen mainScreen].scale;
        portionLayer.frame = self->_containerLayer.frame;
        
        [self->_containerLayer addSublayer:portionLayer];
        
        self.font = portionLayer.font;
        self.shouldDrawSeparators = portionLayer.shouldDrawSeparators;
        self.shouldDrawPercentages = portionLayer.shouldDrawPercentages;
        self.innerCircleProportionalRadius = portionLayer.innerCircleProportionalRadius;
    }
    
    if (self->_containerLayer.superlayer == nil){
        [self.layer addSublayer:self->_containerLayer];
    }
    
    return self->_containerLayer;
}

@end