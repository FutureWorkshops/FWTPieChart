//
//  FWTPiePortionLayer.h
//  FWTEnhancedPieChartView
//
//  Created by Carlos Vidal on 27/03/2014.
//
//

@interface FWTPieChartLayer : CALayer

@property (nonatomic, strong) NSArray *values;
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) NSArray *innerTexts;
@property (nonatomic, strong) NSArray *outerTexts;

@property (nonatomic, strong) UIFont *font;

@property (nonatomic, assign) float startAngle;
@property (nonatomic, assign) float animationCompletionPercent;
@property (nonatomic, assign) float innerCircleProportionalRadius;

@property (nonatomic, strong) UIColor *innerCircleColor;

@property (nonatomic, assign) BOOL shouldDrawPercentages;
@property (nonatomic, assign) BOOL shouldDrawSeparators;

@end
