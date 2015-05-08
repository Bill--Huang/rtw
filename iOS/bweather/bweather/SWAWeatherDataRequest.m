//
//  SWAWeatherDataRequest.m
//  bweather
//
//  Created by 黄泽彪 on 15/5/7.
//  Copyright (c) 2015年 BillDev. All rights reserved.
//

#import "SWAWeatherDataRequest.h"
#import "RequestHelper.h"
#import "SecurityUtility.h"
#import "NSString+encrypto.h"

// SWA: Smart Weather API
#define SWA_APP_ID @"71c378afeb22c0a2"
#define SWA_PRIVATE_KEY @"114590_SmartWeatherAPI_f4579d9"

#define SWA_STATIC_URL_PART @"http://open.weather.com.cn/data"
#define SWA_FORECAST_TYPE_NORMAL @"forecast_v"
#define SWA_FORECAST_TYPE_ADVANCED @"forecast_f"
#define SWA_INDEX_TYPE_NORMAL @"index_v"
#define SWA_IDNEX_TYPE_ADVANCED @"index_f"

// current temperature url
// http://m.weather.com.cn/data/101110101.html

@implementation SWAWeatherDataRequest

- (id) initWithAreaId: (NSString *) aid AndDate: (NSDate *) date {
    if (self = [super init]) {
        self.aid = aid;
        self.date = date;
    }
    return self;
}

- (NSDictionary *) send {
    
    // send request by GET
    NSURL *url = [self generateSWAURL];
    ASIHTTPRequest* request = [[RequestHelper sharedRequestHelper] sendRequestWithURL:url];
    NSError *error = [request error];
    
    if (!error) {
        NSString *response = [request responseString];
        return [NSDictionary dictionaryWithObject:response forKey:@"result"];
    } else {
        return nil;
    }
}

- (NSURL *) generateSWAURL {
    // generate public key
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateString = [[dateFormatter stringFromDate:date] substringToIndex:12];
    
    // areaid is shanghai 101020100
    NSString *areaIDString = @"101020100";
    
    NSString *publicKey = [NSString stringWithFormat:@"%@/?areaid=%@&type=%@&date=%@&appid=%@",
                           SWA_STATIC_URL_PART,
                           areaIDString,
                           SWA_FORECAST_TYPE_ADVANCED,
                           dateString,
                           SWA_APP_ID];
    
    // generate key
    NSString *key = [SecurityUtility encodeBase64Data:
                     [SecurityUtility hmacSha1WithPublicKey:publicKey
                                              AndPrivateKey:SWA_PRIVATE_KEY]];
    
    key = [key URLEncodedString];
    
    // generate request url
    NSString *requestURL = [NSString stringWithFormat:@"%@/?areaid=%@&type=%@&date=%@&appid=%@&key=%@",
                            SWA_STATIC_URL_PART,
                            areaIDString,
                            SWA_FORECAST_TYPE_ADVANCED,
                            dateString,
                            [SWA_APP_ID substringToIndex:6],
                            key];
    NSLog(@"url: %@", requestURL);
    
    return [NSURL URLWithString:requestURL];
}


@end
