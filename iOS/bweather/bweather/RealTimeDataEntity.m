//
//  RealTimeDataEntity.m
//  bweather
//
//  Created by 黄泽彪 on 15/5/19.
//  Copyright (c) 2015年 BillDev. All rights reserved.
//

#import "RealTimeDataEntity.h"
#import "UserDefaultDataHelper.h"
#import "NSDate+Date.h"
#import "NSString+encrypto.h"

#define MAX_COUNT 5
#define SERVER_URL @"http://192.168.1.102:8080/bweather/storeweatherinfo.php"

@implementation RealTimeDataEntity

- (id) init {
    if(self = [super init]) {
        self.temperatureArray = [[NSMutableArray alloc] init];
        self.humidityArray = [[NSMutableArray alloc] init];
        self.pm25Array = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void) addTemperatureData: (NSString *) data{
    if( self.temperatureArray.count < MAX_COUNT) {
        [self.temperatureArray addObject:data];
        
        if([self checkArraysSum]) {
            [self sentRequestToServer];
        }
    }
}

- (void) addHumidityData: (NSString *) data {
    if( self.humidityArray.count < MAX_COUNT) {
        [self.humidityArray addObject:data];
        
        if([self checkArraysSum]) {
           [self sentRequestToServer];
        }
    }
}

- (void) addPM25Data: (NSString *) data {
    if( self.pm25Array.count < MAX_COUNT) {
        [self.pm25Array addObject:data];
        
        if([self checkArraysSum]) {
            [self sentRequestToServer];
        }
    }
}

- (BOOL) checkArraysSum {
    if(self.temperatureArray.count >= MAX_COUNT && self.humidityArray.count >= MAX_COUNT && self.pm25Array.count >= MAX_COUNT) {
        return YES;
    }
    return NO;
}

- (void) sentRequestToServer {
    // get url
    NSString *uuid = [UserDefaultDataHelper getUUID];
    NSString *location = [UserDefaultDataHelper getGPSLocation];
    NSString *city = [UserDefaultDataHelper getGPSCityName];
    float temperature = [self average: self.temperatureArray];
    float humidity = [self average: self.humidityArray];
    float pm25 = [self average: self.pm25Array];
    NSString *dateString = [[NSDate date] getTodayString];

    
    // example: http://120.26.115.186:8080/storeweatherinfo.php?uuid=&location=x,x&city=&temperature=&humidity=&pm25=&date=
    NSString *params = [NSString stringWithFormat:@"uuid=%@&location=%@&city=%@&temperature=%f&humidity=%f&pm25=%f&date=%@", uuid, location, city, temperature, humidity, pm25, dateString];
    
    NSString *encodedValue = [params urlencode];
    NSString *urlS = [NSString stringWithFormat: @"%@?%@", SERVER_URL, encodedValue];
    // send request
    NSURL *url = [NSURL URLWithString: urlS];
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL: url];
    request.delegate = self;
    [request startAsynchronous];
    
    // release array
    [self reset];
}

- (void) reset {
    [self.temperatureArray removeAllObjects];
    [self.humidityArray removeAllObjects];
    [self.pm25Array removeAllObjects];
}

- (float) average: (NSArray *) array {
    float result = 0;
    for (int i = 0; i < array.count; i++) {
        result += [[array objectAtIndex:i] floatValue];
    }
    
    result = result / array.count;
    
    return (float)((int)(result * 100)) / 100;
}

#pragma mark - ASIHTTPRequest delegate
- (void)requestFinished:(ASIHTTPRequest *)request {
    NSError *error = [request error];
    
    if (!error) {
        NSString * response = [request responseString];
        NSDictionary *dic = [response dictionaryWithJsonString];
        if([dic[@"result"] isEqualToString:@"success"]) {
            NSLog(response);
        } else {
            // error
            // NSLog(dic[@"data"]);
        }
    } else {
        // error
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    
    //
    NSLog(@"Error: send weather to server");
}
@end
