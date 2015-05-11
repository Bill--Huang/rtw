//
//  DayCondition.h
//  bweather
//
//  Created by 黄泽彪 on 15/5/11.
//  Copyright (c) 2015年 BillDev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DayCondition : NSObject

@property(strong, nonatomic) NSDictionary* rawDictionary;
@property(strong, nonatomic) NSNumber* code;
@property(strong, nonatomic) NSString* date;
@property(strong, nonatomic) NSNumber* temp;
@property(strong, nonatomic) NSString* text;

- (id) initWithDictionary: (NSDictionary *) dic;
- (id) convert:(NSString *) key :(id)value;
@end

