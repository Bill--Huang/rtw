//
//  YForecastDataEntity.m
//  bweather
//
//  Created by 黄泽彪 on 15/5/7.
//  Copyright (c) 2015年 BillDev. All rights reserved.
//

#import "YForecastDataEntity.h"

@implementation YForecastDataEntity

- (id) init {
    if(self = [super init]) {
        // init
    }
    
    return self;
}

- (id) initWithDictionary: (NSDictionary *) dictionary; {
    if([self init]) {
        self.dictionary = dictionary;
    }
    
    return self;
}


@end
