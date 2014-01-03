//
//  UserApi.m
//  iSST
//
//  Created by liuyang_sy on 13-12-6.
//  Copyright (c) 2013年 LY. All rights reserved.
//

#import "ISSTUserApi.h"
#import "UserLoginParse.h"

@implementation ISSTUserApi

@synthesize webApiDelegate;
@synthesize datas;

- (void)requestLoginName:(NSString *)name andPassword:(NSString *)password
{
    self.method_id = _LOGIN_;
    datas=[NSMutableData new];
    NSString *subUrlString = [NSString stringWithFormat:@"/users/validation"];
    NSString *info=[NSString stringWithFormat:@"name=%@&password=%@",name,password];
    NSDictionary *md5Dic = @{@"name": name,@"password":password};
    [super requestWithSuburl:subUrlString Method:@"POST" Delegate:self Info:info MD5Dictionary:md5Dic];
}

- (void)requestUserInfo:(NSString *)user_id
{
    self.method_id = _GET_USER_;
    datas=[NSMutableData new];
    NSDictionary *md5Dic = @{ @"userId": user_id};
    [super requestWithSuburl:[NSString stringWithFormat:@"/users/%@",user_id] Method:@"GET" Delegate:self Info:@"" MD5Dictionary:md5Dic];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@",[error localizedDescription]);
    [self.webApiDelegate requestDataOnFail:@"请查看网络连接"];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.datas setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [datas appendData:data];
}
//请求完成
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //登陆
    if (self.method_id == _LOGIN_) {
        if (![UserLoginParse loginSuccessOrNot:datas])//登陆失败
        {
            [self.webApiDelegate requestDataOnFail:[UserLoginParse loginFailMessage:datas]];
        }
        else
        {
            [self.webApiDelegate requestDataOnSuccess:[UserLoginParse getloginSuccessUserId:datas]];
        }
    }
    else if (self.method_id == _GET_USER_)//获取用户信息
    {
       [self.webApiDelegate requestDataOnSuccess:[UserLoginParse userInfoParse:datas]];
    }
  }

@end
