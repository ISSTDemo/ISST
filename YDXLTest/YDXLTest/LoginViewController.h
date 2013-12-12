//
//  SSTLoginViewController.h
//  ISST
//
//  Created by jasonross on 13-12-6.
//  Copyright (c) 2013年 LY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISSTUserApi.h"

//#import "ISSTUserModel.h"

@interface LoginViewController : UIViewController <ISSTWebApiDelegate>

@property (nonatomic, assign) BOOL shouldShowSplashView;

@property (nonatomic,strong)UIImageView *splashView;

@property (nonatomic,strong)ISSTUserApi *userApi;
@property (nonatomic,assign)id user;
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UILabel *errorLabel;


- (IBAction)nameDoneEditing:(id)sender;
- (IBAction)passwordDoneEditing:(id)sender;

- (IBAction)loginBtnClicked:(id)sender;
- (IBAction)backgroundTap:(id)sender;
@end
