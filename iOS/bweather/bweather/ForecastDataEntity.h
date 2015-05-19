//
//  ForecastDataEntity.h
//  bweather
//
//  Created by 黄泽彪 on 15/5/6.
//  Copyright (c) 2015年 BillDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreImage/CoreImage.h>
#import "DayCondition.h"
#import "ForecastCondition.h"
#import "WeatherDataUnitsStructure.h"
@interface ForecastDataEntity : NSObject

- (id) init;
- (id) initWithDictionary: (NSDictionary *) dic;

@property (strong, nonatomic) NSDictionary *rawDictionary;
@property (strong, nonatomic) NSString* cityName;
@property (strong, nonatomic) NSString* countryName;
@property (strong, nonatomic) NSString* woeid;
@property (strong, nonatomic) NSString* updateTime;
@property (strong, nonatomic) NSDate* requestUpdateTime;
@property (nonatomic) CGPoint cityLocation;
@property (strong, nonatomic) DayCondition* todayCondition;
@property (strong, nonatomic) NSMutableArray* dayForcastConditionsArray;
@property (strong, nonatomic) WeatherDataUnitsStructure* unitStructuer;


@end
