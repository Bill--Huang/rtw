//
//  ForecastDataEntity.h
//  bweather
//
//  Created by 黄泽彪 on 15/5/6.
//  Copyright (c) 2015年 BillDev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ForecastDataEntity : NSObject

- (id) init;
- (id) initWithDictionary: (NSDictionary *) dictionary;

@property (strong, nonatomic) NSDictionary *dictionary;

@end
