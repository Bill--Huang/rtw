//
//  SettingViewController.h
//  bweather
//
//  Created by 黄泽彪 on 15/5/17.
//  Copyright (c) 2015年 BillDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CitySelectViewController.h"

@interface SettingViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, CitySelectControllerDelegete>

@property (strong, nonatomic) NSArray *cityArray;

@property (strong, nonatomic) IBOutlet UITableView *cityTableView;
@property (strong, nonatomic) UIView *tableBottomLine;
@property (strong, nonatomic) IBOutlet UIImageView *staticCellImageView;
@property (strong, nonatomic) IBOutlet UIButton *addCityButton;
@property (strong, nonatomic) IBOutlet UILabel *unitLabel;
@property (strong, nonatomic) IBOutlet UISwitch *unitSwitchButton;

- (IBAction) goBackToWeatherPageView:(id)sender;


@end
