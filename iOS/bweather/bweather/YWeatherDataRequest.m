//
//  YWeatherDataRequest.m
//  bweather
//
//  Created by 黄泽彪 on 15/5/7.
//  Copyright (c) 2015年 BillDev. All rights reserved.
//

#import "YWeatherDataRequest.h"
#import "NSString+encrypto.h"
#import "YForecastDataEntity.h"
#import "UserDefaultDataHelper.h"

@implementation YWeatherDataRequest

- (id) initWithWoeids: (NSArray *) array {
    if (self = [super init]) {
        self.woeidArray = array;
    }
    
    return self;

}

- (NSMutableArray *) send {
    
    NSString *unit = @"c";
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSNumber *toggle = [userDefault objectForKey:SETTING_DIC][SETTING_U_C];
    
    if([toggle intValue] != 1) {
        unit = @"f";
    }
    
    // Example: SELECT * FROM weather.forecast WHERE woeid="2502265" or woeid="56043481" or ...
    NSString *woeidParmas = [NSString stringWithFormat:@"u = '%@' and woeid='%@'", unit, [self.woeidArray objectAtIndex:0]];
    if(self.woeidArray.count > 1) {
        for (int i = 1; i < self.woeidArray.count; i++) {
            NSString* temp = [NSString stringWithFormat:@"woeid='%@'", [self.woeidArray objectAtIndex:i]];
            woeidParmas = [NSString stringWithFormat:@"%@ or u = '%@' and %@", woeidParmas, unit, temp];
        }
    }
    
    // get weather data
    NSDictionary* weatherResults = [YQL query:
                                    [NSString stringWithFormat: @"select * from weather.forecast where u = 'c' and %@", woeidParmas]];
    
    // get dic
    // generat entity array
    return [self generateEntityDic: weatherResults];
}

- (NSMutableArray *) generateEntityDic: (NSDictionary *) dic {
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    NSArray* dics = dic[@"query"][@"results"][@"channel"];
    
    for (int i = 0; i < dics.count; i++) {
        NSDictionary* tempDic = [dics objectAtIndex:i];
        [tempDic setValue: [self.woeidArray objectAtIndex:i] forKey: @"woeid"];
        YForecastDataEntity *temp = [[YForecastDataEntity alloc] initWithDictionary: tempDic];
        
        [result addObject:temp];
    }
    
    return result;
}

@end
