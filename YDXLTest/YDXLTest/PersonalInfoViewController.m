//
//  PersonalInfoViewController.m
//  iSST
//
//  Created by liuyang_sy on 13-12-11.
//  Copyright (c) 2013年 LY. All rights reserved.
//

#import "PersonalInfoViewController.h"

@interface PersonalInfoViewController ()

@end

@implementation PersonalInfoViewController

@synthesize nickNameTextField;
@synthesize  userFullNameTextField;
@synthesize spittleApi;

NSString *nicknameTemp;
NSUserDefaults *defaults;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.edgesForExtendedLayout= UIRectEdgeNone;
    }
    self.spittleApi = [[ISSTSpittlesApi alloc]init];
    self.spittleApi.webApiDelegate = self;
   }

-(void)viewWillAppear:(BOOL)animated
{
    defaults  =[[NSUserDefaults alloc]init];
    userFullNameTextField.text=[defaults objectForKey:@"userfullname"];
    nickNameTextField.text = [defaults objectForKey:@"nickname"];
}

- (IBAction)changeNickName:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改昵称" message:@"输入新的昵称" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UITextField *tf=[alertView textFieldAtIndex:0];
    if(buttonIndex==1)
    {    nicknameTemp=tf.text;
        [self.spittleApi requestPutNameWithUserId:[defaults objectForKey:@"userid"]    andNickName:tf.text];
    }
}



- (IBAction)useridQuit:(id)sender {
    defaults=[[NSUserDefaults alloc]init];
    [defaults removeObjectForKey:@"userfullname"];
    [defaults removeObjectForKey:@"userid"];
    [defaults removeObjectForKey:@"nickname"];
    
}


#pragma mark -
#pragma mark ISSTWebApiDelegate
- (void)requestDataOnSuccess:(id)backToControllerData
{
    if (self.spittleApi.method_id == PUT_NAME) {
        self.nickNameTextField.text = nicknameTemp;
        NSUserDefaults *defaults  =[[NSUserDefaults alloc]init];
        [defaults removeObjectForKey:@"nickname"];
        [defaults setObject:nicknameTemp forKey:@"nickname"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改成功！！！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
    }

}

- (void)requestDataOnFail:(NSString *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您好:" message:@"修改不成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

@end
