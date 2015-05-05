//
//  ViewController.m
//  bweather
//
//  Created by 黄泽彪 on 15/5/2.
//  Copyright (c) 2015年 BillDev. All rights reserved.
//

#import "ViewController.h"
#import "ASIHTTPRequest.h"
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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self weatherRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) testNetwork {
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];

    [request startSynchronous];

    NSError *error = [request error];

    if (!error) {
        NSString *response = [request responseString];
        
    }
}


- (void) weatherRequest {
    // test: get weather data from SWA
    
    
    // send request by GET
    NSURL *url = [self generateSWAURL];
    ASIHTTPRequest* request = [self sendRequestWithURL: url];
    NSError *error = [request error];
    
    if (!error) {
        NSString *response = [request responseString];
        NSLog(response);
    } else {
        NSLog(@"n");
    }
    //
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

- (ASIHTTPRequest *) sendRequestWithURL: (NSURL *) url {
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    return request;
}




@end
