//
//  ForecastCondition.h
//  bweather
//
//  Created by 黄泽彪 on 15/5/11.
//  Copyright (c) 2015年 BillDev. All rights reserved.
//

#import "DayCondition.h"

@interface ForecastCondition : DayCondition

@property(strong, nonatomic) NSString* day;
@property(strong, nonatomic) NSNumber* low;
@property(strong, nonatomic) NSNumber* high;

- (id) initWithDictionary: (NSDictionary *) dic;


@end
