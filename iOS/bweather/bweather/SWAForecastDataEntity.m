//
//  SWAForecastDataEntity.m
//  bweather
//
//  Created by 黄泽彪 on 15/5/6.
//  Copyright (c) 2015年 BillDev. All rights reserved.
//

#import "SWAForecastDataEntity.h"

@implementation SWAForecastDataEntity

- (id) init {
    if(self = [super init]) {
        // init
    }
    
    return self;
}

- (id) initWithDictionary: (NSDictionary *) dic; {
    if([self init]) {
        self.rawDictionary = dic;
        
//        NSLog(self.weatherString);
    }
    
    return self;
}

@end
