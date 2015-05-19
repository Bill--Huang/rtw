//
//  YWeatherDataRequest.h
//  bweather
//
//  Created by 黄泽彪 on 15/5/7.
//  Copyright (c) 2015年 BillDev. All rights reserved.
//

#import "WeatherDataRequest.h"
#import "YQL.h"
/**
 *  Yahoo API Request
 */
@interface YWeatherDataRequest : WeatherDataRequest

@property(strong, nonatomic) NSArray *woeidArray;

- (id) initWithWoeids: (NSArray *) array;

@end
