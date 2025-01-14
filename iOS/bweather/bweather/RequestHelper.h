//
//  RequestHelper.h
//  bweather
//
//  Created by 黄泽彪 on 15/5/7.
//  Copyright (c) 2015年 BillDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "ASIHTTPRequest.h"


@interface RequestHelper : NSObject

/**
 *  Singleton
 *
 *  @return id
 */
+ (id)sharedRequestHelper;

- (ASIHTTPRequest *) sendRequestWithURL: (NSURL *) url;


@end
