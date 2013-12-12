//
//  ISSTSpittleIslikeModel.h
//  YDXLTest
//
//  Created by apple on 13-12-6.
//  Copyright (c) 2013年 LY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISSTSpittleIslikeModel : NSObject//吐槽鸡蛋 还是赞
@property(strong,nonatomic)NSString *SIid;//吐槽赞表的唯一标识
@property(strong,nonatomic)NSString *Uid;//用户id
@property(strong,nonatomic)NSString *SCid;//吐槽编号
@property(strong,nonatomic)NSString *SIislike;//是否为赞

@end
