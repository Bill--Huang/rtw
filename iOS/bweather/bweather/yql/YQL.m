//
//  YQL.m
//  yql-ios
//
//  Created by Guilherme Chapiewski on 10/19/12.
//  Copyright (c) 2012 Guilherme Chapiewski. All rights reserved.
//

#import "YQL.h"
#import "NSString+encrypto.h"
#import "RequestHelper.h"

#define QUERY_PREFIX @"http://query.yahooapis.com/v1/public/yql?q="
#define QUERY_SUFFIX @"&format=json&market=zh-hant-tw&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="

@implementation YQL

+ (NSDictionary *) query: (NSString *)statement {
    
    NSString *queryString = statement;
    queryString = [queryString URLEncodedString];
   
    NSString *query = [NSString stringWithFormat:@"%@%@%@", QUERY_PREFIX, queryString, QUERY_SUFFIX];
    
    NSURL *url = [NSURL URLWithString:query];
    ASIHTTPRequest* request = [[RequestHelper sharedRequestHelper] sendRequestWithURL:url];
    NSError *error = [request error];
    
    if (!error) {
        NSString * response= [request responseString];
        NSDictionary *dic = [response dictionaryWithJsonString];
        return dic;
    } else {
        return nil;
    }
    
    // do not encode
    // NSString *query = [NSString stringWithFormat:@"%@%@%@", QUERY_PREFIX, [statement stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding], QUERY_SUFFIX];
    
    //    NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:query]
    //                                                 encoding:NSUTF8StringEncoding
    //                                                    error:nil]
    //                        dataUsingEncoding:NSUTF8StringEncoding];
    //    NSError *error = nil;
    //
    //    NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error] : nil;
    //
    //    if (error) {
    //        NSLog(@"[%@ %@] JSON error: %@",
    //              NSStringFromClass([self class]),
    //              NSStringFromSelector(_cmd),
    //              error.localizedDescription);
    //    }
    //return results;
}

@end
