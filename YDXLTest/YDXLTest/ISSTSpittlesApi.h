//
//  ISSTSpittlesApi.h
//  iSST
//
//  Created by liuyang_sy on 13-12-6.
//  Copyright (c) 2013年 LY. All rights reserved.
//

#import "ISSTApi.h"
#import "ISSTWebApiDelegate.h"
#define POST_SPITTLE 1     //发送列表
#define DOWN_REFRESH 2     //下拉刷新
#define UP_REFRESH 3
#define LIKE_SPITTLE_REFRESH 4//获取最赞列表
#define EGG_SPITTLE_REFRESH 5//砸鸡蛋
#define PUT_NAME 6    //修改昵称
#define LIKE_SPITTLE  7 //点赞
#define  EGG_SPITTLE  8   //砸金蛋

@interface ISSTSpittlesApi : ISSTApi <NSURLConnectionDataDelegate>
{
    
}

@property (strong, nonatomic)NSMutableData *datas;
@property (nonatomic, assign)id<ISSTWebApiDelegate> webApiDelegate;
//发布评论
- (void)requestPostSpittleWithUserId:(NSString*)user_id andContent:(NSString *)content;
//获取列表
- (void)requestDownGetSpittlesWithUserId:(NSString *)user_id andPage:(int)page andPageSize:(int)pageSize;

- (void)requestUpGetSpittles;

//获取最赞列表
- (void)requestLikeGetSpittlesWithUserId:(NSString *)user_id andLike:(BOOL)like andCount:(int)count;
//点赞
- (void)requestLikeSpittleWithUserId:(NSString *)user_id andSpittlesId:(NSString *)spittleId andLike:(BOOL)like;

- (void)requestNoGetSpittles;
//修改昵称
- (void)requestPutNameWithUserId:(NSString *)user_id andNickName:(NSString *)newNickName;

@end
