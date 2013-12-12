//
//  ISSTSpittleModel.h
//  YDXLTest
//
//  Created by apple on 13-12-6.
//  Copyright (c) 2013年 LY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISSTSpittleContentModel : NSObject//吐槽内容
@property(strong,nonatomic)NSString *SCid;//吐槽编号，在吐槽表中的唯一标识
@property(strong,nonatomic)NSString *SCuserid;//用户id
@property(strong,nonatomic)NSString *SCcontent;//吐槽内容
@property(strong,nonatomic)NSString *SCposttime;//发送时间
@property(strong,nonatomic)NSString *SClikes;//吐槽点赞数
@property(strong,nonatomic)NSString *SCdislikes;//吐槽鸡蛋数
@property(strong,nonatomic)NSString *SCnickname;
@property(strong,nonatomic)NSString *SCisliked;
@property(strong,nonatomic)NSString *SCisdisliked;
@end
