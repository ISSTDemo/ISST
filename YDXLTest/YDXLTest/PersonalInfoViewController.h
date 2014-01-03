//
//  PersonalInfoViewController.h
//  iSST
//
//  Created by liuyang_sy on 13-12-11.
//  Copyright (c) 2013年 LY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISSTSpittlesApi.h"

@interface PersonalInfoViewController : UIViewController

@property (strong,nonatomic)ISSTSpittlesApi *spittleApi;

@property (strong, nonatomic) IBOutlet UITextField *nickNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *userFullNameTextField;

- (IBAction)changeNickName:(id)sender;

- (IBAction)useridQuit:(id)sender;
@end
