//
//  ISSTSpittlesApi.m
//  iSST
//
//  Created by liuyang_sy on 13-12-6.
//  Copyright (c) 2013年 LY. All rights reserved.
//

#import "ISSTSpittlesApi.h"

@implementation ISSTSpittlesApi

@synthesize datas;
@synthesize webApiDelegate;

- (void)requestPostSpittleWithUserId:(NSString*)user_id andContent:(NSString *)content
{
    self.method_id = POST_SPITTLE;
 //URL: /isst/api{userId}/spittles, POST {content: string}
    datas=[NSMutableData new];
    NSString *subUrlString = [NSString stringWithFormat:@"/users/%@/spittles",user_id];
    NSString  *postSpittle = [NSString stringWithFormat:@"content=%@",content];
    [super requestWithSuburl:subUrlString Method:@"POST" Delegate:self Info:postSpittle];
}
- (void)requestDownGetSpittlesWithUserId:(NSString *)user_id andPage:(int)page andPageSize:(int)pageSize
{
    self.method_id = DOWN_REFRESH;
    datas=[NSMutableData new];
    //URL: /isst/api/users/{userId}/spittles?page=int&pageSize=int,GET
    NSString *subUrl = [NSString stringWithFormat:@"/users/%@/spittles?page=%d&pageSize=%d",user_id,page,pageSize];
    [super requestWithSuburl:subUrl Method:@"GET" Delegate:self Info:@""];
}

- (void)requestUpGetSpittles
{
    self.method_id = UP_REFRESH;

   
    [super requestWithSuburl:@"" Method:@"GET" Delegate:self Info:nil];

}

- (void)requestLikeGetSpittlesWithUserId:(NSString *)user_id andLike:(BOOL)like andCount:(int)count
{    datas=[NSMutableData new];
    if (like) {
        self.method_id = LIKE_SPITTLE_REFRESH;
    }
    else
    {
        self.method_id = EGG_SPITTLE_REFRESH;
        
    }
    
    //URL: /isst/api/users/{userId}/spittles/likes?isLike=0|1&count=int, GET
    NSString *subUrl = [NSString stringWithFormat:@"/users/%@/spittles/likes?isLike=%d&count=%d",user_id,like?1:0,count];
    [super requestWithSuburl:subUrl Method:@"GET" Delegate:self Info:@""];
    

}

- (void)requestLikeSpittleWithUserId:(NSString *)user_id andSpittlesId:(NSString *)spittleId andLike:(BOOL)like
{
    self.method_id = LIKE_SPITTLE;
  //  URL: /isst/api/users/{userId}/spittles/{spittleId}/likes, POST{isLike:0|1}
///RESPONSE: {code: int, message: string} code==0?error(message):success
    NSString *subUrl = [NSString stringWithFormat:@"/users/%@/spittles/%@/likes",user_id,spittleId];
    NSString *info = [NSString stringWithFormat:@"isLike=%d",like?1:0];
     [super requestWithSuburl:subUrl Method:@"GET" Delegate:self Info:info];
}

- (void)requestNoGetSpittles
{
    self.method_id = EGG_SPITTLE_REFRESH;
    [super requestWithSuburl:@"" Method:@"GET" Delegate:self Info:nil];

}

- (void)requestPutNameWithUserId:(NSString *)user_id andNickName:(NSString *)newNickName
{
    //URL: /isst/api/users/{userId}, POST {nickname: string, _method: PUT}
    self.method_id = PUT_NAME;
    datas=[NSMutableData new];
    NSString *putName = [NSString stringWithFormat:@"nickname=%@&_method=PUT",newNickName];
    [super requestWithSuburl:[NSString stringWithFormat:@"/users/%@",user_id] Method:@"POST" Delegate:self Info:putName];
}



- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
     NSLog(@"error=%@",[error localizedDescription]);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [datas setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [datas appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"请求完成");
   // NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:datas options:NSJSONReadingAllowFragments error:nil];
  //  NSLog(@"%@",dict);
    if (self.method_id == PUT_NAME) {
        //RESPONSE: {code: int, message: string} code==0?error(message):success
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:datas options:NSJSONReadingAllowFragments error:nil];
        NSString *codeString = [dict objectForKey:@"code"];//获取返回的code，确定返回数据是否正确。
        if ([codeString intValue] <= 0) {
            NSLog(@"网络连接错误");
            [self.webApiDelegate requestDataOnFail:@"网络连接错误"];
        }
        else
        {
            [self.webApiDelegate requestDataOnSuccess:dict];
        }

    }
    else if(self.method_id == POST_SPITTLE)
    {
    //RESPONSE: {code: int, message: string} code==0?error(message):success
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:datas options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"splitepost=%@",dict);
        NSString *codeString = [dict objectForKey:@"code"];//获取返回的code，确定返回数据是否正确。
        if ([codeString intValue] <= 0) {
            NSLog(@"网络连接错误");
            [self.webApiDelegate requestDataOnFail:@"网络连接错误"];
        }
        else
        {
            [self.webApiDelegate requestDataOnSuccess:dict];
        }
    }
    else if(self.method_id == DOWN_REFRESH)
    {////////注意这是一个NSArray
        //RESPONSE: [{id: int, userId: int, nickname: string, content: string, postTime: timestamp, likes: int, dislikes: int, isLiked: 0|1, isDisliked:0|1}]
        NSArray *dict = [NSJSONSerialization JSONObjectWithData:datas options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"Arraydict=%@",dict);
        if (dict==nil) {
            NSLog(@"网络连接错误");
            [self.webApiDelegate requestDataOnFail:@"网络连接错误"];
        }
        else
        {
            [self.webApiDelegate requestDataOnSuccess:dict];
        }

    }
    else if(self.method_id == UP_REFRESH)
    {
        
    }
    else if(self.method_id == LIKE_SPITTLE_REFRESH)
    {
       //RESPONSE: [{id: int, userId: int, nickname: string, content: string, postTime: timestamp, likes: int, dislikes: int, isLiked: 0|1, isDisliked:0|1}]
        NSArray *dict = [NSJSONSerialization JSONObjectWithData:datas options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"Arraydict=%@",dict);
        [self.webApiDelegate requestDataOnSuccess:dict];
        
    }
    else if(self.method_id == EGG_SPITTLE_REFRESH)
    {
        
    }
    else if(self.method_id == EGG_SPITTLE)
    {
    
    }
    else if (self.method_id == LIKE_SPITTLE)
    {
    
    }
}

@end
