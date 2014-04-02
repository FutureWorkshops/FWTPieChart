//
//  FWTPiePortionLayer.h
//  FWTEnhancedPieChartView
//
//  Created by Carlos Vidal on 27/03/2014.
//
//

#import <QuartzCore/QuartzCore.h>

@interface FWTPieChartLayer : CALayer

@property (nonatomic, strong) NSArray *values;
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) NSArray *innerTexts;
@property (nonatomic, strong) NSArray *outterTexts;

@property (nonatomic, assign) float startAngle;
@property (nonatomic, assign) float animationCompletionPercent;

@end
