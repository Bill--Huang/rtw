//
//  WeatherHelper.m
//  bweather
//
//  Created by 黄泽彪 on 15/5/6.
//  Copyright (c) 2015年 BillDev. All rights reserved.
//

#import "WeatherHelper.h"
#import "RequestHelper.h"
#import "SWAForecastDataEntity.h"
#import "YForecastDataEntity.h"
#import "SWAWeatherDataRequest.h"
#import "YWeatherDataRequest.h"

@implementation WeatherHelper 
- (id) init {
    if(self = [super init]) {
        // init
    }
    
    return self;
}

- (NSMutableArray *) getYForecastWeatherEntityWithArray: (NSArray *) array {
    YWeatherDataRequest *request = [[YWeatherDataRequest alloc] initWithWoeids: array];
    NSMutableArray *tempArray = [request send];
    
    return tempArray;
}

- (ForecastDataEntity *) getSWAForecastWeatherEntity {
    SWAWeatherDataRequest *request = [[SWAWeatherDataRequest alloc] initWithAreaId:nil
                                                                           AndDate:nil];
    //ForecastDataEntity *tempEntity = [[SWAForecastDataEntity alloc] initWithDictionary:[request send]];
    
    return nil;
}

- (NSString *) getCityWoeidWithLat: (float) lat AndLog: (float) log {
    // get location' woeid
    NSDictionary* woeidResult = [YQL query:
                                 [NSString stringWithFormat: @"select * from geo.placefinder where text='%f, %f' and gflags='R'", lat, log]];
    
    // add
    if(woeidResult != nil
       && woeidResult[@"query"][@"results"][@"Result"][@"woeid"] != nil
       && ![woeidResult[@"query"][@"results"][@"Result"][@"woeid"] isEqualToString:@""]) {
        // get woeid
        return woeidResult[@"query"][@"results"][@"Result"][@"woeid"];
    }

    return nil;
}

- (IndexDataEntity *) getIndexWeatherEntity {
    return [[IndexDataEntity alloc] init];
}


@end
