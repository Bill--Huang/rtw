//
//  DayForecastCell2.h
//  bweather
//
//  Created by 黄泽彪 on 15/5/15.
//  Copyright (c) 2015年 BillDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DayForecastCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel* dayLabel;
@property (strong, nonatomic) IBOutlet UILabel* dayConditionLabel;
@property (strong, nonatomic) IBOutlet UILabel* dayHighTempLabel;
@property (strong, nonatomic) IBOutlet UILabel* dayLowTempLabel;


@end
