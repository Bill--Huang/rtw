//
//  WeatherPageView.m
//  bweather
//
//  Created by 黄泽彪 on 15/5/15.
//  Copyright (c) 2015年 BillDev. All rights reserved.
//

#import "WeatherPageView.h"
#import "YForecastDataEntity.h"
#import "NSDate+Date.h"
#import "DayForecastCell.h"

@implementation WeatherPageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) updateView {
    self.dayDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                   @"星期一", @"Mon",
                   @"星期二", @"Tue",
                   @"星期三", @"Wed",
                   @"星期四", @"Thu",
                   @"星期五", @"Fri",
                   @"星期六", @"Sat",
                   @"星期天", @"Sun",
                   nil];
    
    
    [self refreshViewLabelsWithEntity:self.forecastDataEntity];
    
    [self.dayForecastTableView setDelegate:self];
    [self.dayForecastTableView setDataSource:self];
    [self.dayForecastTableView reloadData];
}

#pragma mark - Weather UI Refresh
- (void)refreshViewLabelsWithEntity: (YForecastDataEntity *) entity {
    
    // today' ui
    ForecastCondition *todayForecastCondition = [entity.dayForcastConditionsArray objectAtIndex:0];
    
    self.todayTempLabel.text =  [entity.todayCondition.temp stringValue];
    self.todayHighTempLabel.text = [todayForecastCondition.high stringValue];
    self.todayLowTempLabel.text = [todayForecastCondition.low stringValue];
    self.todayConditionLabel.text = entity.todayCondition.text;
    self.todayUnitLabel.text = entity.unitStructuer.temperature;
    self.todayCityLabel.text = entity.cityName;
    self.todayUpdateTimeLabel.text = [NSString stringWithFormat:@"%@ %@", @"更新时间", [entity.requestUpdateTime dateToStringWithFormate]];
    
    // forecast
    // table view refresh
}

#pragma mark - TableView Delegate
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"DayForecastCell";
    DayForecastCell *cell = (DayForecastCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        //cell = [[DayForecastCell alloc] init];
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] lastObject];
    }
    
    ForecastCondition *dayForecastCondition = [self.forecastDataEntity.dayForcastConditionsArray objectAtIndex:indexPath.row];
    
    cell.backgroundColor = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0];
    cell.dayLabel.text = [self.dayDic objectForKey: dayForecastCondition.day];
    if(indexPath.row == 0) {
        cell.dayLabel.text = @"今天";
    }
    
    cell.dayConditionLabel.text = dayForecastCondition.text;
    cell.dayHighTempLabel.text = [dayForecastCondition.high stringValue];
    cell.dayLowTempLabel.text = [dayForecastCondition.low stringValue];
    
    return cell;
}

@end
