//
//  WeatherHelper.m
//  bweather
//
//  Created by 黄泽彪 on 15/5/6.
//  Copyright (c) 2015年 BillDev. All rights reserved.
//

#import "WeatherHelper.h"
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

- (ForecastDataEntity *) getForecastWeatherEntityWithAPIType: (APIType) type  {
    
    ForecastDataEntity* tempEntity = nil;
    
    switch (type) {
        case SWA: {
            NSLog(@"apid swa");
            SWAWeatherDataRequest* request = [[SWAWeatherDataRequest alloc] initWithAreaId:nil
                                                                                AndDate:nil];
            tempEntity = [[SWAForecastDataEntity alloc] initWithDictionary:[request send]];
            break;
        }
        case Yahoo: {
            YWeatherDataRequest *request = [[YWeatherDataRequest alloc] initWithCityInfo: @"Shanghai"];
            tempEntity = [[YForecastDataEntity alloc] initWithDictionary:[request send]];
            break;
        }
        default:
            break;
    }
    
    return tempEntity;
}

- (IndexDataEntity *) getIndexWeatherEntity {
    return [[IndexDataEntity alloc] init];
}


@end
