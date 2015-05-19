//
//  WeatherPageView.h
//  bweather
//
//  Created by 黄泽彪 on 15/5/15.
//  Copyright (c) 2015年 BillDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherPageView.h"
#import "WeatherHelper.h"
#import "EnumCollection.h"
#import "ForecastDataEntity.h"
#import "YForecastDataEntity.h"

@interface WeatherPageView : UIView <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSDictionary* dayDic;

@property (strong, nonatomic) IBOutlet UILabel* todayTempLabel;
@property (strong, nonatomic) IBOutlet UILabel* todayUnitLabel;
@property (strong, nonatomic) IBOutlet UILabel* todayHighTempLabel;
@property (strong, nonatomic) IBOutlet UILabel* todayLowTempLabel;
@property (strong, nonatomic) IBOutlet UILabel* todayConditionLabel;
@property (strong, nonatomic) IBOutlet UILabel* todayCityLabel;
@property (strong, nonatomic) IBOutlet UILabel* todayUpdateTimeLabel;

@property (strong, nonatomic) IBOutlet UITableView* dayForecastTableView;

@property (strong, nonatomic) YForecastDataEntity *forecastDataEntity;

- (void) updateView;

@end
