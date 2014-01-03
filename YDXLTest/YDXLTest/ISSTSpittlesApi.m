//
//  ISSTSpittlesApi.m
//  iSST
//
//  Created by liuyang_sy on 13-12-6.
//  Copyright (c) 2013年 LY. All rights reserved.
//

#import "ISSTSpittlesApi.h"
#import "SpittleParse.h"

@implementation ISSTSpittlesApi

@synthesize datas;
@synthesize webApiDelegate;

- (void)requestPostSpittleWithUserId:(NSString*)user_id andContent:(NSString *)content
{
    self.method_id = POST_SPITTLE;
    datas=[NSMutableData new];
    NSString *subUrlString = [NSString stringWithFormat:@"/users/%@/spittles",user_id];
    NSString  *postSpittle = [NSString stringWithFormat:@"content=%@",content];
    
    NSDictionary *md5Dic = @{@"userId": user_id,@"content":content};
    [super requestWithSuburl:subUrlString Method:@"POST" Delegate:self Info:postSpittle MD5Dictionary:md5Dic];
}
- (void)requestDownGetSpittlesWithUserId:(NSString *)user_id andPage:(int)page andPageSize:(int)pageSize
{
    self.method_id = DOWN_REFRESH;
    datas=[NSMutableData new];
    NSString *subUrl = [NSString stringWithFormat:@"/users/%@/spittles?page=%d&pageSize=%d",user_id,page,pageSize];
    NSDictionary *md5Dic = @{@"userId": user_id,@"page":[NSString stringWithFormat:@"%d",page],@"pageSize":[NSString stringWithFormat:@"%d",pageSize]};
    [super requestWithSuburl:subUrl Method:@"GET" Delegate:self Info:@"" MD5Dictionary:md5Dic];
}

- (void)requestUpGetSpittlesGetSpittlesWithUserId:(NSString *)user_id andMaxSpittleIdOfCurrentPage:(int)maxSpittleId andNextPage:(int)nextPage andPageSize:(int)pageSize
{
    self.method_id = UP_REFRESH;
    datas=[NSMutableData new];
    NSString *subUrl = [NSString stringWithFormat:@"/users/%@/spittles?id=%d&page=%d&pageSize=%d",user_id,maxSpittleId,nextPage,pageSize];
    NSDictionary *md5Dic = @{@"userId": user_id,@"id":[NSString stringWithFormat:@"%d",maxSpittleId],@"page":[NSString stringWithFormat:@"%d",nextPage],@"pageSize":[NSString stringWithFormat:@"%d",pageSize]};
    [super requestWithSuburl:subUrl Method:@"GET" Delegate:self Info:@"" MD5Dictionary:md5Dic];
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
    NSString *subUrl = [NSString stringWithFormat:@"/users/%@/spittles/likes?isLike=%d&count=%d",user_id,like?1:0,count];
    
    NSDictionary *md5Dic = @{@"userId": user_id,@"isLike":[NSString stringWithFormat:@"%d",(like?1:0)],@"count":[NSString stringWithFormat:@"%d",count]};

    [super requestWithSuburl:subUrl Method:@"GET" Delegate:self Info:@""MD5Dictionary:md5Dic ];
}

- (void)requestLikeSpittleWithUserId:(NSString *)user_id andSpittlesId:(NSString *)spittleId andLike:(BOOL)like
{
    datas=[NSMutableData new];
    if(like)
        self.method_id = LIKE_SPITTLE;
    else
        self.method_id=EGG_SPITTLE;
    NSString *subUrl = [NSString stringWithFormat:@"/users/%@/spittles/%@/likes",user_id,spittleId];
    NSString *info = [NSString stringWithFormat:@"isLike=%d",like?1:0];
    
    NSDictionary *md5Dic = @{@"userId": user_id,@"spittleId":spittleId, @"isLike":[NSString stringWithFormat:@"%d",(like?1:0)]};

    [super requestWithSuburl:subUrl Method:@"POST" Delegate:self Info:info MD5Dictionary:md5Dic];
}

- (void)requestNoGetSpittles
{
    datas=[NSMutableData new];
    self.method_id = EGG_SPITTLE_REFRESH;
    [super requestWithSuburl:@"" Method:@"GET" Delegate:self Info:nil];

}

- (void)requestPutNameWithUserId:(NSString *)user_id andNickName:(NSString *)newNickName
{
    self.method_id = PUT_NAME;
    datas=[NSMutableData new];
    NSString *putName = [NSString stringWithFormat:@"nickname=%@&_method=PUT",newNickName];
    NSDictionary *md5Dic = @{@"userId": user_id,@"nickname":newNickName};
    [super requestWithSuburl:[NSString stringWithFormat:@"/users/%@",user_id] Method:@"POST" Delegate:self Info:putName MD5Dictionary:md5Dic];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
     NSLog(@"error=%@",[error localizedDescription]);
    [self.webApiDelegate requestDataOnFail:@"请查看网络连接"];
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
    NSString *codeString;//返回的 code
    NSDictionary *dict ; //返回的NSDictionary
    NSArray *array;
    switch (self.method_id) {
        case PUT_NAME:
           dict= [NSJSONSerialization JSONObjectWithData:datas options:NSJSONReadingAllowFragments error:nil];
           codeString = [dict objectForKey:@"code"];//获取返回的code，确定返回数据是否正确。
            if ([codeString intValue] <= 0) {
                [self.webApiDelegate requestDataOnFail:[dict objectForKey:@"message"]];
            }
            else
            {
                [self.webApiDelegate requestDataOnSuccess:dict];
            }
            break;
        case POST_SPITTLE:
            //RESPONSE: {code: int, message: string} code==0?error(message):success
            dict = [NSJSONSerialization JSONObjectWithData:datas options:NSJSONReadingAllowFragments error:nil];
            //NSLog(@"splitepost=%@",dict);
            codeString = [dict objectForKey:@"code"];//获取返回的code，确定返回数据是否正确。
            if ([codeString intValue] <= 0) {
               // NSLog(@"网络连接错误");
                [self.webApiDelegate requestDataOnFail:[dict objectForKey:@"message"]];
            }
            else
            {
                [self.webApiDelegate requestDataOnSuccess:dict];
            }
            break;
        case DOWN_REFRESH:
            array = [NSJSONSerialization JSONObjectWithData:datas options:NSJSONReadingAllowFragments error:nil];
          //  NSLog(@"Arraydict=%@",array);
            if (array==nil) {
               // NSLog(@"网络连接错误");
                [self.webApiDelegate requestDataOnFail:@"网络连接错误"];
            }
            else
            {
                  [self.webApiDelegate requestDataOnSuccess:[SpittleParse iSSTSpittleContentModelParse:datas]];
               // [self.webApiDelegate requestDataOnSuccess:array];
            }
            break;
        case UP_REFRESH:
            array = [NSJSONSerialization JSONObjectWithData:datas options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"Arraydict=%@",array);
            [self.webApiDelegate requestDataOnSuccess:[SpittleParse iSSTSpittleContentModelParse:datas]];
            // [self.webApiDelegate requestDataOnSuccess:array];
            break;
        case LIKE_SPITTLE_REFRESH:
            array = [NSJSONSerialization JSONObjectWithData:datas options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"Arraydict=%@",array);
            [self.webApiDelegate requestDataOnSuccess:[SpittleParse iSSTSpittleContentModelParse:datas]];
            // [self.webApiDelegate requestDataOnSuccess:array];
        case EGG_SPITTLE_REFRESH:
            array = [NSJSONSerialization JSONObjectWithData:datas options:NSJSONReadingAllowFragments error:nil];
            [self.webApiDelegate requestDataOnSuccess:[SpittleParse iSSTSpittleContentModelParse:datas]];
            // [self.webApiDelegate requestDataOnSuccess:array];

            break;
        case EGG_SPITTLE:
            dict = [NSJSONSerialization JSONObjectWithData:datas options:NSJSONReadingAllowFragments error:nil];
            codeString = [dict objectForKey:@"code"];//获取返回的code，确定返回数据是否正确。
            if ([codeString intValue] <= 0) {
                NSLog(@"网络连接错误");
                [self.webApiDelegate requestDataOnFail:[dict objectForKey:@"message"]];
            }
            else
            {
                [self.webApiDelegate requestDataOnSuccess:dict];
            }

            break;
        case LIKE_SPITTLE:
            dict = [NSJSONSerialization JSONObjectWithData:datas options:NSJSONReadingAllowFragments error:nil];
            codeString = [dict objectForKey:@"code"];//获取返回的code，确定返回数据是否正确。
            if ([codeString intValue] <= 0) {
                NSLog(@"网络连接错误");
                [self.webApiDelegate requestDataOnFail:[dict objectForKey:@"message"]];
            }
            else
            {
                [self.webApiDelegate requestDataOnSuccess:dict];
            }

            break;
        default:
            break;
    }
}

@end
