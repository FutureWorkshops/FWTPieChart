//
//  FWTPieChartExampleViewController.m
//  FWTEnhancedPieChartView
//
//  Created by Carlos Vidal on 27/03/2014.
//
//

#import "FWTPieChartExampleViewController.h"
#import "FWTPieChartView.h"

@interface FWTPieChartExampleViewController ()

@property (nonatomic, strong) FWTPieChartView *pieChartView;

@end

@implementation FWTPieChartExampleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self performAnimation];
}

- (void)performAnimation
{
    [self.pieChartView animate];
    [UIView commitAnimations];
}

#pragma mark - Lazy loading
- (FWTPieChartView*)pieChartView
{
    if (self->_pieChartView == nil){
        self->_pieChartView = [[FWTPieChartView alloc] initWithFrame:CGRectMake(340, 220, 340, 340)];
    }
    
    if (self->_pieChartView.superview == nil){
        [self.view addSubview:self->_pieChartView];
    }
    
    return self->_pieChartView;
}

@end
