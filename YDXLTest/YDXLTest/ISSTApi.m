//
//  YDXLApi.m
//  YDXLTest
//
//  Created by liuyang_sy on 13-12-6.
//  Copyright (c) 2013年 LY. All rights reserved.
//

#import "ISSTApi.h"

@implementation ISSTApi

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)requestWithSuburl:(NSString *)subUrl Method:(NSString *)method Delegate:(id<NSURLConnectionDataDelegate>)delegate Info:(NSString*)info;
{
    NSString *mainUrl = @"http://xplan.cloudapp.net:8080/isst/api";
    if ([method isEqualToString:@"GET"]) {
        NSString *strUrl = [NSString stringWithFormat:@"%@%@",mainUrl,subUrl];
        NSURL *url = [NSURL URLWithString:[strUrl URLEncodedString]];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:delegate];
        if (connection) {
            NSLog(@"连接成功");
        }
    } else if([method isEqualToString:@"PUT"]) {
        
    } else if([method isEqualToString:@"POST"]) {
        NSString *strUrl = [NSString stringWithFormat:@"%@%@",mainUrl,subUrl];
        NSURL *url = [NSURL URLWithString:[strUrl URLEncodedString]];
        NSData *data = [info dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:data];
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:delegate];
        if (connection) {
            NSLog(@"连接成功");
        }
    } else if([method isEqualToString:@"DELETE"]) {
        
    }
}


@end
