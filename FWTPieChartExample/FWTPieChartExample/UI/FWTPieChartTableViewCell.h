//
//  FWTPieChartTableViewCell.h
//  FWTPieChartExample
//
//  Created by Carlos Vidal on 05/04/2014.
//  Copyright (c) 2014 Carlos Vidal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FWTPieChartTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet FWTPieChartView *pieChartView;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;

@end
