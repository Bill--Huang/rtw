//
//  YWeatherDataRequest.m
//  bweather
//
//  Created by 黄泽彪 on 15/5/7.
//  Copyright (c) 2015年 BillDev. All rights reserved.
//

#import "YWeatherDataRequest.h"
#import "NSString+encrypto.h"

@implementation YWeatherDataRequest

- (id) initWithCityInfo: (NSString *) info {
    if (self = [super init]) {
        self.cityInfo = info;
        self.yql = [[YQL alloc] init];
    }
    
    return self;
}

- (NSDictionary *) send {
    // get woeid by cityinfo and get weather data
    NSDictionary* weatherResults = [self query:
                                    [NSString stringWithFormat: @"select * from weather.forecast where woeid in (select woeid from geo.places(1) where text='%@') and u = 'c'", self.cityInfo]];
    return weatherResults[@"query"][@"results"];
    
//    
//    NSDictionary* cityResults = [self query:
//                                 [NSString stringWithFormat: @"select * from geo.placefinder where text = '%@'", self.cityInfo]];
//    NSNumber *count = cityResults[@"query"][@"count"];
//    
//    if(count > 0) {
//        NSDictionary *city = nil;
//        
//        if ([count isEqualToNumber:[NSNumber numberWithInt:1]]) {
//            city = cityResults[@"query"][@"results"][@"Result"];
//        } else {
//            NSArray *cityArray = cityResults[@"query"][@"results"][@"Result"];
//            city = [cityArray objectAtIndex:0];
//        }
//        
//        self.woeid = city[@"woeid"];
//        
//        NSDictionary* weatherResults = [self query:
//                                     [NSString stringWithFormat: @"select * from weather.forecast where woeid = '%@' and u = 'c'", self.woeid]];
//        return weatherResults;
//    } else {
//        // no city
//        NSLog(@"can't find city");
//        return nil;
//    }
//    
//    return nil;
}

- (NSDictionary *) query: (NSString *) statement {
    NSString *queryString = statement;
    queryString = [queryString URLEncodedString];
    NSDictionary *results = [self.yql query:queryString];
    return results;
}

@end
