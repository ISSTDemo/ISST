//
//  ISSTShowVoteModel.h
//  YDXLTest
//
//  Created by apple on 13-12-6.
//  Copyright (c) 2013年 LY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISSTShowVoteModel : NSObject//对节目打分
@property(strong,nonatomic)NSString *SVid;//打分表的唯一标识
@property(strong,nonatomic)NSString *Sid;//节目号
@property(strong,nonatomic)NSString *Uid;//用户id
@property(strong,nonatomic)NSString *SVposttime;//投票时间
@end
