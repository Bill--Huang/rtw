//
//  ForecastCondition.m
//  bweather
//
//  Created by 黄泽彪 on 15/5/11.
//  Copyright (c) 2015年 BillDev. All rights reserved.
//

#import "ForecastCondition.h"

@implementation ForecastCondition

- (id) initWithDictionary: (NSDictionary *) dic {
    if(self = [super initWithDictionary:dic]) {
        if(dic != nil) {
            self.day = @"";
            self.low = [NSNumber numberWithInt:-999];
            self.high = [NSNumber numberWithInt:-999];
            
            self.day = [self convert:@"day" : self.day];
            self.low = [self convert:@"low" : self.low];
            self.high = [self convert:@"high" : self.high];
        }
    }
    
    return self;
}


@end
