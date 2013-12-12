//
//  ISSTShowModel.h
//  YDXLTest
//
//  Created by apple on 13-12-6.
//  Copyright (c) 2013年 LY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISSTShowModel : NSObject //节目
@property(strong,nonatomic)NSString *Sid;//节目表中的唯一id，节目号；
@property(strong,nonatomic)NSString *Syear;//年分
@property(strong,nonatomic)NSString *Sname;//节目名
@property(strong,nonatomic)NSString *Sorganization;//选送单位
@property(strong,nonatomic)NSString *Scategory;//节目类别
@property(strong,nonatomic)NSString *Sstatus;//状态，0，1，2分别代表未开始，正在进行，已经结束
@property(strong,nonatomic)NSString *Svotenum;//投票分数
@end
