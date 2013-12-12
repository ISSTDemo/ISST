//
//  ISSTUserModel.h
//  YDXLTest
//
//  Created by apple on 13-12-6.
//  Copyright (c) 2013年 LY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISSTUserModel : NSObject//用户表
@property(nonatomic,strong)NSString *Uid;//用户id，在用户表里唯一标识
@property(nonatomic,strong)NSString *Uname;//学号
@property(nonatomic,strong)NSString *Upassword;//密码
@property(nonatomic,strong)NSString *Utype;//用户权限
@property(nonatomic,strong)NSString *Ufullname;//真实姓名
@property(nonatomic,strong)NSMutableString *Unickname;//昵称

@end
