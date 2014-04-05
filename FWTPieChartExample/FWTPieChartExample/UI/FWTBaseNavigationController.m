//
//  FWTBaseNavigationController.m
//  FWTPieChartExample
//
//  Created by Carlos Vidal on 05/04/2014.
//  Copyright (c) 2014 Carlos Vidal. All rights reserved.
//

#import "FWTBaseNavigationController.h"

@interface FWTBaseNavigationController ()

@end

@implementation FWTBaseNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self _setupApplicationAppearance];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Private methods
- (void)_setupApplicationAppearance
{
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UIButton appearance] setTintColor:[UIColor colorWithRed:183.f/255.f green:16.f/255.f blue:21.f/255.f alpha:1.f]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:183.f/255.f green:16.f/255.f blue:21.f/255.f alpha:1.f]];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Light" size:16.f]} forState:UIControlStateNormal];
}

@end
