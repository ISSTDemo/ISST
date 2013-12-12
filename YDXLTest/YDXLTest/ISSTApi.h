//
//  YDXLApi.h
//  YDXLTest
//
//  Created by liuyang_sy on 13-12-6.
//  Copyright (c) 2013年 LY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+URLEncoding.h"

@interface ISSTApi : NSObject

//@property (nonatomic, strong);

@property (assign, nonatomic) int method_id;

- (void)requestWithSuburl:(NSString *)subUrl Method:(NSString *)method Delegate:(id<NSURLConnectionDataDelegate>)delegate Info:(NSString *)info;

@end
