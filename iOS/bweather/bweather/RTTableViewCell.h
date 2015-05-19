//
//  RTTableViewCell.h
//  bweather
//
//  Created by 黄泽彪 on 15/5/17.
//  Copyright (c) 2015年 BillDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RTTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *dataLabel;
@property (strong, nonatomic) IBOutlet UILabel *unitLabel;
@property (strong, nonatomic) IBOutlet UILabel *superUnitLabel;

@end
