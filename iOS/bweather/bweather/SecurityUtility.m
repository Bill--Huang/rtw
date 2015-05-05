//
//  SecurityUtility.m
//  bweather
//
//  Created by 黄泽彪 on 15/5/5.
//  Copyright (c) 2015年 BillDev. All rights reserved.
//

#import "SecurityUtility.h"
#import "GTMBase64.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#define APP_PUBLIC_PASSWORD     @"boundary"

@implementation SecurityUtility

#pragma mark - base64
+ (NSString*)encodeBase64String:(NSString * )input {
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    data = [GTMBase64 encodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

+ (NSString*)decodeBase64String:(NSString * )input {
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    data = [GTMBase64 decodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

+ (NSString*)encodeBase64Data:(NSData *)data {
    data = [GTMBase64 encodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

+ (NSString*)decodeBase64Data:(NSData *)data {
    data = [GTMBase64 decodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

#pragma mark - hash_hmac('sha1',$public_key,$private_key,TRUE)

+ (NSData *)hmacSha1WithPublicKey:(NSString*)public_key AndPrivateKey:(NSString*)private_key {
    
    NSData* secretData = [private_key dataUsingEncoding:NSUTF8StringEncoding];
    NSData* stringData = [public_key dataUsingEncoding:NSUTF8StringEncoding];
    
    const void* keyBytes = [secretData bytes];
    const void* dataBytes = [stringData bytes];
    
    ///#define CC_SHA1_DIGEST_LENGTH   20          /* digest length in bytes */
    void* outs = malloc(CC_SHA1_DIGEST_LENGTH);
    
    CCHmac(kCCHmacAlgSHA1, keyBytes, [secretData length], dataBytes, [stringData length], outs);
    
    // Soluion 1
    NSData* signatureData = [NSData dataWithBytesNoCopy:outs length:CC_SHA1_DIGEST_LENGTH freeWhenDone:YES];
    
    return signatureData;
}


@end
