//
//  SecurityUtility.h
//  bweather
//
//  Created by 黄泽彪 on 15/5/5.
//  Copyright (c) 2015年 BillDev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SecurityUtility : NSObject

#pragma mark - base64
+ (NSString*)encodeBase64String:(NSString *)input;
+ (NSString*)decodeBase64String:(NSString *)input;
+ (NSString*)encodeBase64Data:(NSData *)data;
+ (NSString*)decodeBase64Data:(NSData *)data;

#pragma mark - hash_hmac('sha1',$public_key,$private_key,TRUE)
+ (NSData *)hmacSha1WithPublicKey:(NSString*)public_key AndPrivateKey:(NSString*)private_key;

@end
