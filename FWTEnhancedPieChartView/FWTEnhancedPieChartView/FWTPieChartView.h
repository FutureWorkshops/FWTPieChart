//
//  FWTPieChartView.h
//  FWTEnhancedPieChartView
//
//  Created by Carlos Vidal on 27/03/2014.
//
//

#import <UIKit/UIKit.h>

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

@property (nonatomic, strong, readonly) NSArray *segments;

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
