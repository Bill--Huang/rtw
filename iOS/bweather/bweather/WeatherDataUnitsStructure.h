//
//  WeatherDataUnitsStructure.h
//  bweather
//
//  Created by 黄泽彪 on 15/5/11.
//  Copyright (c) 2015年 BillDev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherDataUnitsStructure : NSObject

@property(strong, nonatomic) NSString* distance;
@property(strong, nonatomic) NSString* pressure;
@property(strong, nonatomic) NSString* speed;
@property(strong, nonatomic) NSString* temperature;

- (id) initWithDictionary: (NSDictionary *) dic;
@end
