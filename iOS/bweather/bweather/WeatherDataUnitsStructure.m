//
//  WeatherDataUnitsStructure.m
//  bweather
//
//  Created by 黄泽彪 on 15/5/11.
//  Copyright (c) 2015年 BillDev. All rights reserved.
//

#import "WeatherDataUnitsStructure.h"

@implementation WeatherDataUnitsStructure

- (id) init {
    if(self = [super init]) {
        //
        self.distance = @"km";
        self.pressure = @"mb";
        self.speed = @"km/h";
        self.temperature = @"C";
    }
    return self;
}

- (id) initWithDictionary: (NSDictionary *) dic {
    if([self init]) {
        self.distance = [dic objectForKey:@"distance"];
        self.pressure = [dic objectForKey:@"pressure"];
        self.speed = [dic objectForKey:@"speed"];
        self.temperature = [dic objectForKey:@"temperature"];
    }
    
    return self;
}

@end
