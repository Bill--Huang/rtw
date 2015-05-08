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

@interface WeatherHelper : NSObject

- (id) init;
- (ForecastDataEntity *) getForecastWeatherEntityWithAPIType: (APIType) type;
- (IndexDataEntity *) getIndexWeatherEntity;

@end
