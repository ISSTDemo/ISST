//
//  SSTWebApiDelegate.h
//  ISST
//
//  Created by jasonross on 13-12-6.
//  Copyright (c) 2013年 LY. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ISSTWebApiDelegate <NSObject>

@optional

- (void)requestDataOnSuccess:(id)backToControllerData;

- (void)requestDataOnFail:(NSString *)error;
@end
