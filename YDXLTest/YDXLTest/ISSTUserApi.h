//
//  UserApi.h
//  iSST
//
//  Created by liuyang_sy on 13-12-6.
//  Copyright (c) 2013年 LY. All rights reserved.
//

#import "ISSTApi.h"
#import "ISSTWebApiDelegate.h"

#define _LOGIN_ 1
#define _GET_USER_ 2
//#define _EDIT_NICKNAME_ 6

@interface ISSTUserApi : ISSTApi <NSURLConnectionDataDelegate>
{
    
}

@property (strong, nonatomic)NSMutableData *datas;
@property (nonatomic, assign)id<ISSTWebApiDelegate> webApiDelegate;
- (void)requestLoginName:(NSString *)name andPassword:(NSString *)password;

- (void)requestUserInfo:(NSString *)user_id;
//-(void)requestUserId:(NSString*) userid NickName:(NSString*) nickname;

@end
