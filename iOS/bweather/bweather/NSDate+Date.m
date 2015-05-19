//
//  NSDate+Date.m
//  bweather
//
//  Created by 黄泽彪 on 15/5/15.
//  Copyright (c) 2015年 BillDev. All rights reserved.
//

#import "NSDate+Date.h"

@implementation NSDate(Date)

- (NSString *) dateToStringWithFormate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:self];
    return dateString;
}


@end
