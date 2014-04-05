//
//  FWTPieChartView.h
//  FWTPieChartView
//
//  Created by Carlos Vidal on 05/04/2014.
//  Copyright (c) 2014 Carlos Vidal. All rights reserved.
//

//FWTPieChartSegmentData
@interface FWTPieChartSegmentData : NSObject

/**
 Value which defines the percent of the pieChart completed by the segment.
 @warning use values between 0.f and 1.f.
 @warning the addition of all the segments of a pie chart cannot be upper than 1.f.
 */
@property (nonatomic, strong) NSNumber *value;

/**
 Color of the segment and the outer text.
 */
@property (nonatomic, strong) UIColor *color;

/**
 String that will be drawn inside the pie chart.
 @warning the string must be a single character length.
 */
@property (nonatomic, strong) NSString *innerText;

/**
 String that will be drawn outside the pie chart.
 */
@property (nonatomic, strong) NSString *outerText;

/**
 Factory method to create a FWTPieChartSegmentData with the given parameters as properties. Parameters can be nil.
 */
+ (FWTPieChartSegmentData*)pieChartSegmentWithValue:(NSNumber*)value
                                              color:(UIColor*)color
                                          innerText:(NSString*)innerText
                                       andOuterText:(NSString*)outerText;

@end


//FWTPieChartView
@interface FWTPieChartView : UIView

/**
 Array of FWTPieChartSegmentData objects in which are defined the properties of every segment of the pie chart.
 */
@property (nonatomic, strong) NSArray *segments;

/**
 Font used to draw inner and outer texts, also percentages. The font size doesn't matter as this is adjusted automatically to fit on the drawing.
 */
@property (nonatomic, strong) UIFont *font;

/**
 Flag which determines if the line between segments should be drawn or not.
 */
@property (nonatomic, assign) BOOL shouldDrawSeparators;

/**
 Flag which determines if the percentages should be drawn or not.
 */
@property (nonatomic, assign) BOOL shouldDrawPercentages;

/**
 This float value indicates the radius of the inner circle proportionally to the outer radius of the pie chart.
 @warning use values between 0.f and 1.f.
 */
@property (nonatomic, assign) float innerCircleProportionalRadius;

/**
 Float value which determines the duration of the animation.
 */
@property (nonatomic, assign) float animationDuration;

/**
 Adds to the pie chart a previously created segment data object.
 @warning reloadAnimated: must be called to show the segment added.
 */
- (void)addSegment:(FWTPieChartSegmentData*)segmentData;

/**
 Creates and adds to the pie chart a segment data object.
 @warning reloadAnimated: must be called to show the segment added.
 */
- (FWTPieChartSegmentData*)addSegmentWithValue:(NSNumber*)value color:(UIColor*)color innerText:(NSString*)innerText andouterText:(NSString*)outerText;

/**
 Removes a segment from the pie chart.
 @warning reloadAnimated: must be called to show the segment added.
 */
- (void)removeSegment:(FWTPieChartSegmentData*)segmentData;

/**
 Removes all the segments of a pie chart.
 */
- (void)clearSegments;

/**
 Re-draws a pie chart, performing an animation if needed. Completion block is called at the end of the animation.
 */
- (void)reloadAnimated:(BOOL)animated withCompletionBlock:(void(^)())completionBlock;

@end
