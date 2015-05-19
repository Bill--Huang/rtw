//
//  NSString+encrypto.m
//  bweather
//
//  Created by 黄泽彪 on 15/5/5.
//  Copyright (c) 2015年 BillDev. All rights reserved.
//

#import "NSString+encrypto.h"


@implementation NSString(encrypto)

- (NSString *)URLEncodedString
{
    NSString *encodedString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)self, nil, (CFStringRef) @"!$&'()*+,-./:;=?@_~%#[]", kCFStringEncodingUTF8);
    
    return encodedString;
}

- (NSDictionary *)dictionaryWithJsonString {
    
    if (self == nil) {
        return nil;
    }
    NSData *jsonData = [self dataUsingEncoding: NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
        
    }
    return dic;
}


- (NSDictionary *)dictionaryWithJsonStringInkCFStringEncoding {
    if (self == nil) {
        return nil;
    }
    NSData *jsonData = [self dataUsingEncoding: NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
        
    }
    return dic;
}

@end
