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
       //URL: /isst/api/users/    validation?name=string&password:=tring, POST
    NSString *subUrlString = [NSString stringWithFormat:@"/users/validation"];
    NSString *info=[NSString stringWithFormat:@"name=%@&password=%@",name,password];
    [super requestWithSuburl:subUrlString Method:@"POST" Delegate:self Info:info];
}

- (void)requestUserInfo:(NSString *)user_id
{
    self.method_id = _GET_USER_;
     datas=[NSMutableData new];
    //URL: /isst/api/users/{user_id}, GET
    [super requestWithSuburl:[NSString stringWithFormat:@"/users/%@",user_id] Method:@"GET" Delegate:self Info:@""];
}
//-(void)requestUserId:(NSString *)userid NickName:(NSString *)nickname
//{
//    self.method_id=_EDIT_NICKNAME_;
//    datas=[NSMutableData new];
//    //URL:: /isst/api/users/{userId}, POST {nickname: string, _method: PUT}
//    NSString *subUrlString=[NSString stringWithFormat:@"/users/%@",userid];
//    NSString *info=[NSString stringWithFormat:@"nickname=%@&_method=PUT",nickname];
//    [super requestWithSuburl:subUrlString Method:@"POST" Delegate:self Info:info];
//}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@",[error localizedDescription]);
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
    NSLog(@"请求完成");
    NSLog(@"data:%@",datas);
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
