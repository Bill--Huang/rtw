//
//  RequestHelper.m
//  bweather
//
//  Created by 黄泽彪 on 15/5/7.
//  Copyright (c) 2015年 BillDev. All rights reserved.
//

#import "RequestHelper.h"
#import "AppDelegate.h"

@interface RequestHelper ()

@property (weak, nonatomic) AppDelegate *appDelegate;

@end

@implementation RequestHelper

+ (id)sharedRequestHelper
{
    static dispatch_once_t onceToken = 0;
    __strong static id _sharedRequestHelper = nil;
    dispatch_once(&onceToken, ^{
        _sharedRequestHelper = [[self alloc] initWithDefaultSetting];
    });;
    return _sharedRequestHelper;
}

- (id)initWithDefaultSetting
{
    if (self = [super init]) {
        // TODO:
    }
    
    return self;
}

- (ASIHTTPRequest *) sendRequestWithURL: (NSURL *) url {
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    return request;
}

#pragma mark - Helper
- (AppDelegate *)appDelegate
{
    if (_appDelegate == nil) {
        _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    
    return _appDelegate;
}

@end
