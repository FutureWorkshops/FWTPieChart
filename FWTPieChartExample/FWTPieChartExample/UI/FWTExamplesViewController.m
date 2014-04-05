//
//  FWTExamplesViewController.m
//  FWTPieChartExample
//
//  Created by Carlos Vidal on 05/04/2014.
//  Copyright (c) 2014 Carlos Vidal. All rights reserved.
//

#import "FWTExamplesViewController.h"
#import "FWTPieChartTableViewCell.h"

NSString *const FWTPieChartCellReuseIdentifier      = @"FWTPieChartCellReuseIdentifier";
NSString *const FWTExamplesToInfoSegueIdentifier    = @"FWTExamplesToInfoSegueIdentifier";

@interface FWTExamplesViewController ()

@property (nonatomic, strong) NSArray *segments;
@property (nonatomic, strong) NSArray *segmentsWithoutTexts;
@property (nonatomic, strong) NSArray *segmentsWithInnerTexts;
@property (nonatomic, strong) NSArray *segmentsWithOuterTexts;

@end

@implementation FWTExamplesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *aboutButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"About" style:UIBarButtonItemStyleDone target:self action:@selector(_presentAboutScreen:)];
    self.navigationItem.rightBarButtonItem = aboutButtonItem;
}

#pragma mark - Private methods
- (void)_presentAboutScreen:(id)sender
{
    [self performSegueWithIdentifier:FWTExamplesToInfoSegueIdentifier sender:self];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FWTPieChartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FWTPieChartCellReuseIdentifier forIndexPath:indexPath];
    FWTPieChartView *pieChartView = cell.pieChartView;
    pieChartView.font = [UIFont fontWithName:@"HelveticaNeue" size:14.f];
    pieChartView.segments = self.segments;
    
    switch (indexPath.row) {
        case 0:{
            cell.descriptionLabel.text = @"50% inner radius";
            
            pieChartView.innerCircleProportionalRadius = 0.5f;
            pieChartView.shouldDrawPercentages = YES;
            pieChartView.shouldDrawSeparators = YES;
            break;
        }
        case 1:{
            cell.descriptionLabel.text = @"0% inner radius";

            pieChartView.innerCircleProportionalRadius = 0.0f;
            pieChartView.shouldDrawPercentages = YES;
            pieChartView.shouldDrawSeparators = YES;
            
            break;
        }
        case 2:{
            cell.descriptionLabel.text = @"75% inner radius";

            pieChartView.innerCircleProportionalRadius = 0.75f;
            pieChartView.shouldDrawPercentages = YES;
            pieChartView.shouldDrawSeparators = YES;
            
            break;
        }
        case 3:{
            cell.descriptionLabel.text = @"Without percentages";

            pieChartView.innerCircleProportionalRadius = 0.5f;
            pieChartView.shouldDrawPercentages = NO;
            pieChartView.shouldDrawSeparators = YES;
            
            break;
        }
        case 4:{
            cell.descriptionLabel.text = @"Without separator lines";

            pieChartView.innerCircleProportionalRadius = 0.5f;
            pieChartView.shouldDrawPercentages = YES;
            pieChartView.shouldDrawSeparators = NO;
            
            break;
        }
        case 5:{
            cell.descriptionLabel.text = @"Only percentages";
            
            pieChartView.segments = self.segmentsWithoutTexts;
            pieChartView.innerCircleProportionalRadius = 0.5f;
            pieChartView.shouldDrawPercentages = YES;
            pieChartView.shouldDrawSeparators = YES;
            break;
        }
        case 6:{
            cell.descriptionLabel.text = @"Without texts";
            
            pieChartView.segments = self.segmentsWithoutTexts;
            pieChartView.innerCircleProportionalRadius = 0.5f;
            pieChartView.shouldDrawPercentages = NO;
            pieChartView.shouldDrawSeparators = YES;
            
            break;
        }
        case 7:{
            cell.descriptionLabel.text = @"Only inner texts";
            
            pieChartView.segments = self.segmentsWithInnerTexts;
            pieChartView.innerCircleProportionalRadius = 0.5f;
            pieChartView.shouldDrawPercentages = YES;
            pieChartView.shouldDrawSeparators = YES;
            
            break;
        }
        case 8:{
            cell.descriptionLabel.text = @"Only outer texts";
            
            pieChartView.segments = self.segmentsWithOuterTexts;
            pieChartView.innerCircleProportionalRadius = 0.5f;
            pieChartView.shouldDrawPercentages = YES;
            pieChartView.shouldDrawSeparators = YES;
            
            break;
        }
        case 9:{
            cell.descriptionLabel.text = @"Custom fonts";
            
            pieChartView.font = [UIFont fontWithName:@"DINCondensed-Bold" size:14.f];
            pieChartView.innerCircleProportionalRadius = 0.5f;
            pieChartView.shouldDrawPercentages = YES;
            pieChartView.shouldDrawSeparators = YES;
            
            break;
        }
        default:
            break;
    }
    
    [pieChartView reloadAnimated:NO withCompletionBlock:nil];
    
    return cell;
}

#pragma mark - Lazy loading
- (NSArray*)segments
{
    if (self->_segments == nil){
        FWTPieChartSegmentData *firstSegment = [FWTPieChartSegmentData pieChartSegmentWithValue:@0.22f
                                                                                          color:[UIColor colorWithRed:22/255.f green:86/255.f blue:219/255.f alpha:1]
                                                                                      innerText:@"A"
                                                                                   andOuterText:@"2"];
        FWTPieChartSegmentData *secondSegment = [FWTPieChartSegmentData pieChartSegmentWithValue:@0.44f
                                                                                           color:[UIColor colorWithRed:235/255.f green:81/255.f blue:29/255.f alpha:1]
                                                                                       innerText:@"B"
                                                                                    andOuterText:@"4"];
        FWTPieChartSegmentData *thirdSegment = [FWTPieChartSegmentData pieChartSegmentWithValue:@0.34f
                                                                                          color:[UIColor colorWithRed:98/255.f green:200/255.f blue:24/255.f alpha:1]
                                                                                      innerText:@"C"
                                                                                   andOuterText:@"3"];
        self->_segments = @[firstSegment, secondSegment, thirdSegment];
    }
    
    return self->_segments;
}

- (NSArray*)segmentsWithOuterTexts
{
    if (self->_segmentsWithOuterTexts == nil){
        FWTPieChartSegmentData *firstSegment = [FWTPieChartSegmentData pieChartSegmentWithValue:@0.22f
                                                                                          color:[UIColor colorWithRed:22/255.f green:86/255.f blue:219/255.f alpha:1]
                                                                                      innerText:nil
                                                                                   andOuterText:@"2"];
        FWTPieChartSegmentData *secondSegment = [FWTPieChartSegmentData pieChartSegmentWithValue:@0.44f
                                                                                           color:[UIColor colorWithRed:235/255.f green:81/255.f blue:29/255.f alpha:1]
                                                                                       innerText:nil
                                                                                    andOuterText:@"4"];
        FWTPieChartSegmentData *thirdSegment = [FWTPieChartSegmentData pieChartSegmentWithValue:@0.34f
                                                                                          color:[UIColor colorWithRed:98/255.f green:200/255.f blue:24/255.f alpha:1]
                                                                                      innerText:nil
                                                                                   andOuterText:@"3"];
        self->_segmentsWithOuterTexts = @[firstSegment, secondSegment, thirdSegment];
    }
    
    return self->_segmentsWithOuterTexts;
}

- (NSArray*)segmentsWithInnerTexts
{
    if (self->_segmentsWithInnerTexts == nil){
        FWTPieChartSegmentData *firstSegment = [FWTPieChartSegmentData pieChartSegmentWithValue:@0.22f
                                                                                          color:[UIColor colorWithRed:22/255.f green:86/255.f blue:219/255.f alpha:1]
                                                                                      innerText:@"A"
                                                                                   andOuterText:nil];
        FWTPieChartSegmentData *secondSegment = [FWTPieChartSegmentData pieChartSegmentWithValue:@0.44f
                                                                                           color:[UIColor colorWithRed:235/255.f green:81/255.f blue:29/255.f alpha:1]
                                                                                       innerText:@"B"
                                                                                    andOuterText:nil];
        FWTPieChartSegmentData *thirdSegment = [FWTPieChartSegmentData pieChartSegmentWithValue:@0.34f
                                                                                          color:[UIColor colorWithRed:98/255.f green:200/255.f blue:24/255.f alpha:1]
                                                                                      innerText:@"C"
                                                                                   andOuterText:nil];
        self->_segmentsWithInnerTexts = @[firstSegment, secondSegment, thirdSegment];
    }
    
    return self->_segmentsWithInnerTexts;
}

- (NSArray*)segmentsWithoutTexts
{
    if (self->_segmentsWithoutTexts == nil){
        FWTPieChartSegmentData *firstSegment = [FWTPieChartSegmentData pieChartSegmentWithValue:@0.22f
                                                                                          color:[UIColor colorWithRed:22/255.f green:86/255.f blue:219/255.f alpha:1]
                                                                                      innerText:nil
                                                                                   andOuterText:nil];
        FWTPieChartSegmentData *secondSegment = [FWTPieChartSegmentData pieChartSegmentWithValue:@0.44f
                                                                                           color:[UIColor colorWithRed:235/255.f green:81/255.f blue:29/255.f alpha:1]
                                                                                       innerText:nil
                                                                                    andOuterText:nil];
        FWTPieChartSegmentData *thirdSegment = [FWTPieChartSegmentData pieChartSegmentWithValue:@0.34f
                                                                                          color:[UIColor colorWithRed:98/255.f green:200/255.f blue:24/255.f alpha:1]
                                                                                      innerText:nil
                                                                                   andOuterText:nil];
        self->_segmentsWithoutTexts = @[firstSegment, secondSegment, thirdSegment];
    }
    
    return self->_segmentsWithoutTexts;
}

@end
