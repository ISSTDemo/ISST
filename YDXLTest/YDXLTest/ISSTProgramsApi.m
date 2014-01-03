//
//  ISSTProgramsApi.m
//  iSST
//
//  Created by liuyang_sy on 13-12-12.
//  Copyright (c) 2013年 LY. All rights reserved.
//

#import "ISSTProgramsApi.h"
#import "VoteProgramParse.h"
@implementation ISSTProgramsApi

@synthesize datas;
@synthesize webApiDelegate;
- (void)requestProgramsListWithUserId:(NSString *)userId   //获取列表
{
    self.method_id = PROGRAMS_LIST;
    datas = [NSMutableData new];
    NSString *subUrl = [NSString stringWithFormat:@"/users/%@/shows",userId];
    NSDictionary *md5Dic =@{@"userId": userId};
    [super requestWithSuburl:subUrl Method:@"GET" Delegate:self Info:@"" MD5Dictionary:md5Dic];
}

- (void)voteWithUserId:(NSString *)userId WithShowID:(int)showId    //投票
{
    self.method_id = VOTE;
    datas = [NSMutableData new];
    NSString *subUrl = [NSString stringWithFormat:@"/users/%@/shows/%d/votes", userId, showId];
    NSDictionary *md5Dic =@{@"userId": userId,@"showId":[NSString stringWithFormat:@"%d",showId]};
    [super requestWithSuburl:subUrl Method:@"POST" Delegate:self Info:@"" MD5Dictionary:md5Dic];

}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
     [self.webApiDelegate requestDataOnFail:@"请查看您的网络连接！"];
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
    if (self.method_id == PROGRAMS_LIST){
        NSArray *dict=(NSArray*)[NSJSONSerialization JSONObjectWithData:datas options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",dict);
        if (dict == nil||[dict count]==0)
        {
            [self.webApiDelegate requestDataOnFail:@"网络连接出现问题"];
        }
        else{
            
            [self.webApiDelegate requestDataOnSuccess:[VoteProgramParse iSSTShowModelParse:datas]];
        }
    }
    else if (self.method_id == VOTE) {
        NSDictionary *dict = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:datas options:NSJSONReadingAllowFragments error:nil];
        NSString *codeString = [dict objectForKey:@"code"];//获取返回的code，确定返回数据是否正确。
        if ([codeString intValue] <= 0) {
            [self.webApiDelegate requestDataOnFail:[dict objectForKey:@"message"]];
        }
        else
        {
            [self.webApiDelegate requestDataOnSuccess:dict];
        }
    }
}


@end
