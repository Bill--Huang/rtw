//
//  DayCondition.m
//  bweather
//
//  Created by 黄泽彪 on 15/5/11.
//  Copyright (c) 2015年 BillDev. All rights reserved.
//

#import "DayCondition.h"

@implementation DayCondition

- (id) initWithDictionary: (NSDictionary *) dic {
    if(self = [super init]) {
        if(dic != nil) {
            self.rawDictionary = dic;
            self.code = [NSNumber numberWithInt:-1];
            self.date = @"";
            self.temp = [NSNumber numberWithInt:-999];
            self.text = @"";
            
            self.code = [self convert:@"code" :self.code];
            self.date = [self convert:@"date" :self.date];
            self.temp = [self convert:@"temp" :self.temp];
            self.text = [self convert:@"text" :self.text];
        }
    }

    return self;
}

- (id) convert:(NSString *) key :(id)value {
    if([self.rawDictionary objectForKey:key]) {
        if([value isKindOfClass:[NSString class]]) {
            return [self.rawDictionary objectForKey:key];
        } else if([value isKindOfClass:[NSNumber class]]) {
            return [NSNumber numberWithInt:[[self. rawDictionary objectForKey:key] intValue]];
        }
    }
    
    return nil;
}


@end
