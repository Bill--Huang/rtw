//
//  NSString+encrypto.h
//  bweather
//
//  Created by 黄泽彪 on 15/5/5.
//  Copyright (c) 2015年 BillDev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(encrypto)

- (NSString *)URLEncodedString;
- (NSDictionary *)dictionaryWithJsonString;
- (NSDictionary *)dictionaryWithJsonStringInkCFStringEncoding;

@end
