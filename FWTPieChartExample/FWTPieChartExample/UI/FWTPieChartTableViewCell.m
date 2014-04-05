//
//  FWTPieChartTableViewCell.m
//  FWTPieChartExample
//
//  Created by Carlos Vidal on 05/04/2014.
//  Copyright (c) 2014 Carlos Vidal. All rights reserved.
//

#import "FWTPieChartTableViewCell.h"

@interface FWTPieChartTableViewCell()

@property (nonatomic, weak) IBOutlet UIButton *animateButton;

@end

@implementation FWTPieChartTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.animateButton.layer.borderWidth = 1.f;
    self.animateButton.layer.cornerRadius = 4.f;
    self.animateButton.layer.borderColor = [UIColor colorWithRed:183.f/255.f green:16.f/255.f blue:21.f/255.f alpha:1.f].CGColor;
}

#pragma mark - Private methods
- (IBAction)_animatePieChart:(id)sender
{
    [self.pieChartView reloadAnimated:YES withCompletionBlock:^{
        NSLog(@"Animation finished");
    }];
}

@end
