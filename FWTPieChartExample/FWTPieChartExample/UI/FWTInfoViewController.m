//
//  FWTInfoViewController.m
//  FWTPieChartExample
//
//  Created by Carlos Vidal on 05/04/2014.
//  Copyright (c) 2014 Carlos Vidal. All rights reserved.
//

#import "FWTInfoViewController.h"

@interface FWTInfoViewController ()

@property (nonatomic, weak) IBOutlet UIWebView *webView;

@end

@implementation FWTInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *dismissButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(_dismiss:)];
    self.navigationItem.rightBarButtonItem = dismissButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.futureworkshops.com"]];
    [self.webView loadRequest:request];
}

#pragma mark - Private methods
- (void)_dismiss:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
