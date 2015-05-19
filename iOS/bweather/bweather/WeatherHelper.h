//
//  WeatherHelper.h
//  bweather
//
//  Created by 黄泽彪 on 15/5/6.
//  Copyright (c) 2015年 BillDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnumCollection.h"
#import "ForecastDataEntity.h"
#import "IndexDataEntity.h"


//@protocol WeatherRequestDelegate
//
//- (void) requestWeatherFinished: (NSMutableArray *) weatherArray;
//- (void) requestCityWoeidFinished: (NSString *) woeid;
//- (void) requestDataFailed: (NSString *) message;
//
//@end

@interface WeatherHelper : NSObject

- (id) init;
- (NSMutableArray *) getYForecastWeatherEntityWithArray: (NSArray *) array;
- (ForecastDataEntity *) getSWAForecastWeatherEntity;
- (NSString *) getCityWoeidWithLat: (float) lat AndLog: (float) log;
- (IndexDataEntity *) getIndexWeatherEntity;

@end
