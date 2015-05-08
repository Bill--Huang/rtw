//
//  SWAWeatherDataRequest.h
//  bweather
//
//  Created by 黄泽彪 on 15/5/7.
//  Copyright (c) 2015年 BillDev. All rights reserved.
//

#import "WeatherDataRequest.h"

/**
 *  SWA API Request
 */
@interface SWAWeatherDataRequest : WeatherDataRequest

@property(strong, nonatomic) NSString *aid;
@property(strong, nonatomic) NSDate *date;

- (id) initWithAreaId: (NSString *) aid AndDate: (NSDate *) date;

@end
