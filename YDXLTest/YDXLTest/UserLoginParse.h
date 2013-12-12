//
//  UserModelParse.h
//  iSST
//
//  Created by xueshuMac on 13-12-11.
//  Copyright (c) 2013年 LY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserLoginParse : NSObject

//解析用户信息
+ (id)userInfoParse:(NSData *)datas;
//返回登陆成功或失败
+ (BOOL)loginSuccessOrNot:(NSData *)datas;
//返回登陆失败信息
+ (NSString *)loginFailMessage:(NSData *)datas;

+ (NSString *)getloginSuccessUserId:(NSData *)datas;
+ (NSDictionary *)loginSerialization:(NSData*)datas;
@end
