//
//  YDXLApi.m
//  YDXLTest
//
//  Created by liuyang_sy on 13-12-6.
//  Copyright (c) 2013年 LY. All rights reserved.
//

#define MD5_SECRET  @"vq8ukG8MKrNC7XqsbIbd7PxvX81ufNz9"
#import "ISSTApi.h"
#import "MyMD5.h"
@implementation ISSTApi

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (NSString *)token:(NSDictionary *)dic andTime:(long long)dtime
{
    
    NSString  *postTime =  [NSString stringWithFormat:@"%llu",dtime]; //[[[array objectAtIndex:indexPath.section]valueForKey:@"postTime"]stringValue];
    NSDate  *datePT = [NSDate dateWithTimeIntervalSince1970:[postTime longLongValue]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSLog(@"currentTime=%@",[dateFormatter stringFromDate:datePT]);
    
    
    
    
    NSArray *tempArray = [dic allKeys];
    NSArray *sortArray=  [tempArray sortedArrayUsingComparator:^(id tem1,id tem2)
                          {
                              NSComparisonResult result  = [tem1 compare:tem2];
                              return result;
                          }];
    
    NSMutableString *mutableString  = [[NSMutableString alloc]init];
    for (NSString *sortKey in sortArray) {
        [mutableString appendString:[NSString stringWithFormat:@"%@",[dic objectForKey:sortKey]] ];
    }
    
    NSString *token = [NSString stringWithFormat:@"%@%llu%@",MD5_SECRET,dtime,mutableString];
    return [MyMD5 md5:token];
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
        } else {
            NSLog(@"connect error");
        }
    } else if([method isEqualToString:@"DELETE"]) {
        
    }
}

- (void)requestWithSuburl:(NSString *)subUrl Method:(NSString *)method Delegate:(id<NSURLConnectionDataDelegate>)delegate Info:(NSString*)info  MD5Dictionary:(NSDictionary *)dict
{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    long long dTime = [[NSNumber numberWithDouble:time] longLongValue];
    
    NSString *token = [self token:dict andTime:dTime];
   // NSString *mainUrl = @"http://xplan.cloudapp.net:8080/isst/api";
    //http://www.zjucst.com
    NSString *mainUrl = @"http://www.zjucst.com/isst/api";
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",mainUrl,subUrl];
    
    NSRange foundObj = [strUrl rangeOfString:@"?"];
    if (foundObj.length>0)
    {
        strUrl = [NSString stringWithFormat:@"%@&token=%@&expire=%llu",strUrl,token,dTime];
    }
    else
    {
        strUrl= [NSString stringWithFormat:@"%@?token=%@&expire=%llu",strUrl,token,dTime];
    }
    
    NSURL *url = [NSURL URLWithString:[strUrl URLEncodedString]];
    if ([method isEqualToString:@"GET"]) {
        
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:delegate];
        if (connection) {
            NSLog(@"连接成功");
        }
    } else if([method isEqualToString:@"PUT"]) {
        
    } else if([method isEqualToString:@"POST"]) {
        
        NSData *data = [info dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:data];
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:delegate];
        if (connection) {
            NSLog(@"连接成功");
        } else {
            NSLog(@"connect error");
        }
    } else if([method isEqualToString:@"DELETE"]) {
        
    }
}

@end
