//
//  FWTExampleViewController.m
//  FWTEnhancedPieChartTest
//
//  Created by Carlos Vidal on 27/03/2014.
//  Copyright (c) 2014 Carlos Vidal. All rights reserved.
//

#import "FWTExampleViewController.h"

#import <FWTEnhancedPieChartView/FWTPieChartView.h>

@interface FWTExampleViewController ()

@property (nonatomic, strong) FWTPieChartView *pieChartView;

@end

@implementation FWTExampleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //[[self.pieChartView setValues:@[@(0.3f), @(0.5f), @(0.2f)]] animated:NO];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.pieChartView.center = CGPointMake(CGRectGetWidth(self.view.frame)/0.5f, CGRectGetHeight(self.view.frame)/0.5f);
}

#pragma mark - Lazy loading
- (FWTPieChartView*)pieChartView
{
    if (self->_pieChartView == nil){
        self->_pieChartView = [[FWTPieChartView alloc] initWithFrame:CGRectMake(0, 0, 280, 280)];
        self->_pieChartView.backgroundColor = [UIColor redColor];
    }
    
    if (self->_pieChartView.superview == nil){
        [self.view addSubview:self->_pieChartView];
    }
    
    return self->_pieChartView;
}

@end
