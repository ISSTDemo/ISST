//
//  ISSTProgramsApi.h
//  iSST
//
//  Created by liuyang_sy on 13-12-12.
//  Copyright (c) 2013年 LY. All rights reserved.
//

#import "ISSTApi.h"
#import "ISSTWebApiDelegate.h"

#define PROGRAMS_LIST 1
#define VOTE 2

@interface ISSTProgramsApi : ISSTApi <NSURLConnectionDataDelegate>

@property (strong, nonatomic)NSMutableData *datas;

@property (nonatomic, strong)id<ISSTWebApiDelegate> webApiDelegate;

- (void)requestProgramsListWithUserId:(NSString *)userId;   //获取列表

- (void)voteWithUserId:(NSString *)userId WithShowID:(int)showId;    //投票

@end
