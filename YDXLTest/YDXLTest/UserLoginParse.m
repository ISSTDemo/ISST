//
//  UserModelParse.m
//  iSST
//
//  Created by xueshuMac on 13-12-11.
//  Copyright (c) 2013年 LY. All rights reserved.
//

#import "UserLoginParse.h"
#import "ISSTUserModel.h"
@implementation UserLoginParse

  NSDictionary *dict;  

+ (NSDictionary*)loginSerialization:(NSData*)datas
{
    return [NSJSONSerialization JSONObjectWithData:datas options:NSJSONReadingAllowFragments error:nil];
}

+ (id)userInfoParse:(NSData *)datas
{
    /*
     {
     fullname = test;
     id = 1;
     name = test;
     nickname = test;
     password = b92c7c17eaa47973b4d0970306e21906;
     type = 0;
     }
     */
    
    dict = [self loginSerialization:datas];
    NSLog(@"userInfoParse.dict:%@",dict);
    ISSTUserModel *user = [[ISSTUserModel alloc]init];
    NSLog(@"%@",dict);
    user.Uname = [dict objectForKey:@"name"];
    user.Ufullname = [dict objectForKey:@"fullname"];
    user.Unickname = [dict objectForKey:@"nickname"];
    user.Uid = [dict objectForKey:@"id"];
    user.Upassword = [dict objectForKey:@"password"];
    user.Utype = [dict objectForKey:@"type"];
    NSLog(@"%@",user.Ufullname);
    return user;
}

+ (BOOL)loginSuccessOrNot:(NSData *)datas
{/*
  {
    code = 1;
    message = "";
  }
  */

      dict = [UserLoginParse loginSerialization:datas];
     NSLog(@"loginSuccessOrNot.dict:%@",dict);
   NSString *codeString  = [dict objectForKey:@"code"];
    NSLog(@"code=%d",[codeString intValue]);
    return [codeString intValue]>0?YES:NO;
   
}

+ (NSString *)loginFailMessage:(NSData *)datas
{
    dict = (NSDictionary*)[self loginSerialization:datas];
       NSLog(@"loginFailMessage.dict:%@",dict);
    NSString *messageString  = [dict objectForKey:@"message"];
    NSLog(@"code=%@",messageString);
    return messageString;

}

+ (NSString *)getloginSuccessUserId:(NSData *)datas
{
    dict = (NSDictionary*)[self loginSerialization:datas];
   // NSLog(@"getloginSuccessUserId:%@",dict);
    NSString *codeString  = [dict objectForKey:@"code"];
    NSLog(@"code=%d",[codeString intValue]);
    return codeString;
}

@end
