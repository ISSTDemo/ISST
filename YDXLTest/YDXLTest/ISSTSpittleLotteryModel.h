//
//  ISSTSpittleLotteryModel.h
//  YDXLTest
//
//  Created by apple on 13-12-6.
//  Copyright (c) 2013年 LY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISSTSpittleLotteryModel : NSObject//吐槽榜
@property(strong,nonatomic)NSString *SLid;//吐槽榜id，在吐槽榜表中唯一标识
@property(strong,nonatomic)NSString *SCid;//吐槽编号
@property(strong,nonatomic)NSString *Uid;//用户id
@property(strong,nonatomic)NSString *SLprizetype;//排行类型
@property(strong,nonatomic)NSString *SLposttime;//排行时间
@end
