//
//  JsonParser.m
//  YDXLTest
//
//  Created by liuyang_sy on 13-12-4.
//  Copyright (c) 2013年 LY. All rights reserved.
//

#import "JsonParser.h"

@implementation JsonParser

+ (NSMutableArray *)JSONParser:(NSData *)data
{
    id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
    NSString *tableName = [result valueForKey:@"table"];
    NSLog(@"table = %@", tableName);
    NSArray *contents = [result valueForKey:@"contents"];
    NSLog(@"contents count = %d", [contents count]);
    
    NSMutableArray *results = [NSMutableArray array];
    return results;
}

+ (NSMutableArray *)parser
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Object" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    return [self JSONParser:data];
}

@end
