//
//  FWTPieChartView.h
//  FWTPieChartView
//
//  Created by Carlos Vidal on 05/04/2014.
//  Copyright (c) 2014 Carlos Vidal. All rights reserved.
//

//FWTPieChartSegmentData
@interface FWTPieChartSegmentData : NSObject

@property (nonatomic, strong) NSNumber *value;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) NSString *innerText;
@property (nonatomic, strong) NSString *outerText;

+ (FWTPieChartSegmentData*)pieChartSegmentWithValue:(NSNumber*)value
                                              color:(UIColor*)color
                                          innerText:(NSString*)innerText
                                       andOuterText:(NSString*)outerText;

@end


//FWTPieChartView
@interface FWTPieChartView : UIView

@property (nonatomic, strong) NSArray *segments;
@property (nonatomic, strong) UIFont *font;

@property (nonatomic, assign) BOOL shouldDrawSeparators;
@property (nonatomic, assign) BOOL shouldDrawPercentages;
@property (nonatomic, assign) float innerCircleProportionalRadius;

- (void)addSegment:(FWTPieChartSegmentData*)segmentData;
- (FWTPieChartSegmentData*)addSegmentWithValue:(NSNumber*)value color:(UIColor*)color innerText:(NSString*)innerText andouterText:(NSString*)outerText;
- (void)removeSegment:(FWTPieChartSegmentData*)segmentData;
- (void)clearSegments;

- (void)reloadAnimated:(BOOL)animated;

@end
