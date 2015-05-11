//
//  YForecastDataEntity.m
//  bweather
//
//  Created by 黄泽彪 on 15/5/7.
//  Copyright (c) 2015年 BillDev. All rights reserved.
//

#import "YForecastDataEntity.h"

@implementation YForecastDataEntity

- (id) init {
    if(self = [super init]) {
        // init
        self.rawDictionary = nil;
        self.cityName = nil;
        self.countryName = nil;
        self.woeid = nil;
        self.updateTime = nil;
        self.cityLocation = CGPointMake(0, 0);
        self.todayCondition = [[DayCondition alloc ]init];
        self.dayForcastConditionsArray = [[NSMutableArray alloc] init];
        self.unitStructuer = [[WeatherDataUnitsStructure alloc] init];
        
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd MM yyyy HH:mm"];
        NSString *dateString = [dateFormatter stringFromDate:date];
        
        self.requestUpdateTime = dateString;
    }
    
    return self;
}

- (id) initWithDictionary: (NSDictionary *) dic {
    if([self init]) {
        self.rawDictionary = dic;
        
        // convert
        [self convert];
    }
    
    return self;
}

- (void) convert {
    if ([self.rawDictionary objectForKey:@"channel"]) {
        NSDictionary* channelTempDic = self.rawDictionary[@"channel"];
        self.cityName = channelTempDic[@"location"][@"city"];
        self.countryName = channelTempDic[@"location"][@"country"];
        self.updateTime = channelTempDic[@"lastBuildDate"];
        
        if([channelTempDic objectForKey:@"item"]) {
            NSDictionary* itemTempDic = channelTempDic[@"item"];
            
            CGFloat lat = [itemTempDic[@"lat"] floatValue];
            CGFloat lng = [itemTempDic[@"long"] floatValue];
            
            self.cityLocation = CGPointMake(lat, lng);
            
            self.todayCondition = [[DayCondition alloc] initWithDictionary:itemTempDic[@"condition"]];
            
            NSArray* forecastArray = itemTempDic[@"forecast"];
            for (int i = 0; i < [forecastArray count]; i++) {
                NSDictionary* forecastDic = [forecastArray objectAtIndex:i];
                ForecastCondition* temp = [[ForecastCondition alloc] initWithDictionary:forecastDic];
                [self.dayForcastConditionsArray addObject:temp];
            }
        }
        
        if([channelTempDic objectForKey:@"units"]) {
            self.unitStructuer = [[WeatherDataUnitsStructure alloc] initWithDictionary:[channelTempDic objectForKey:@"units"]];
        }
    }
    
    
}


@end
