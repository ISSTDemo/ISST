//
//  SSTLoginViewController.m
//  ISST
//
//  Created by jasonross on 13-12-6.
//  Copyright (c) 2013年 LY. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize shouldShowSplashView ;
@synthesize splashView = _splashView;
@synthesize nameField;
@synthesize passwordField;
@synthesize errorLabel;
@synthesize userApi;
@synthesize user;// 用户信息

bool isok;//确定登陆是否成功，成功的话页面跳转，否则，不跳转

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
	// Do any additional setup after loading the view.
    isok=false;
    errorLabel.hidden = YES;
    self.userApi = [[ISSTUserApi alloc]init];
    self.userApi.webApiDelegate = self;
    shouldShowSplashView = YES;
    if (self.shouldShowSplashView) {
        [self showSplashView];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showSplashView
{
    const int screen4S = 480;
    const int screen5 = 568;
    CGSize size = [[UIScreen mainScreen] bounds].size;
    if (size.height <= 480) {
        UIImageView *splashView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, screen4S)];
        self.splashView =splashView;
        splashView.image = [UIImage imageNamed:@"splash.jpg"];
        [self.view addSubview:splashView];
        [self.view bringSubviewToFront:splashView];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:2.0f];
        [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view cache:YES];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(startupAnimationDone:finished:context:)];
        splashView.alpha=0.0;
        splashView.frame = CGRectMake(-320*0.5, -screen4S*0.5, 320*2, screen4S*2);
        [UIView commitAnimations];
    } else {
        UIImageView *splashView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, screen5)];
        self.splashView =splashView;
        splashView.image = [UIImage imageNamed:@"splash.jpg"];
        [self.view addSubview:splashView];
        [self.view bringSubviewToFront:splashView];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:2.0f];
        [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view cache:YES];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(startupAnimationDone:finished:context:)];
        splashView.alpha=0.0;
        splashView.frame = CGRectMake(-320*0.5, -screen5*0.5, 320*2, screen5*2);
        [UIView commitAnimations];
    }
    
    
}

- (void)startupAnimationDone:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    [self.splashView removeFromSuperview];
}

- (IBAction)nameDoneEditing:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)passwordDoneEditing:(id)sender {
     [sender resignFirstResponder];
}


//点击登录按钮
- (IBAction)loginBtnClicked:(id)sender {
   
    //get name and password
    NSString *nameString = nameField.text;
    NSString *passwordString = passwordField.text;
    
    //neither name and password is nil , give an alert
    if ([nameString isEqualToString:@""]||[passwordString isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您好:" message:@"请输入用户名或者密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    else{
        self.userApi.method_id = _LOGIN_; //1  means login
        [self.userApi requestLoginName:nameString andPassword:passwordString];
    }
}

- (IBAction)backgroundTap:(id)sender
{
    [self.nameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//- (void)loginOnSuccess
//{
//    [UIView beginAnimations:@"View Flip" context:nil];
//    [UIView setAnimationDuration:1.25];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
//    [UIView commitAnimations];
//
//}

//确定是否执行页面跳转  ,开始不允许跳转，只有当验证账号和密码正确可以进入后由登录代码执行切换
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    NSLog(@"shouldPerformSegueWithIdentifier ISOK =%d",isok);
    if (isok) {
        return YES;
    }
    else{

        return NO;//
        
    }
  }

//页面跳转传递参数
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    //获取目的ViewController
    UITabBarController *destination =  (UITabBarController*)[segue destinationViewController];
    NSLog(@"%@",destination.class);//UITabBarController
    UIViewController *vc =  [destination.childViewControllers objectAtIndex:0];
        NSLog(@"%@",vc.class);
    if ([vc respondsToSelector:@selector(setUserModel:)]) {
        [vc setValue:self.user forKey:@"userModel"];
   }
}

#pragma mark -
#pragma mark ISSTWebApiDelegate methods
//登陆成功后，通过代理返回数据给loginview
- (void)requestDataOnSuccess:(id)info
{
    if (self.userApi.method_id == _LOGIN_)
    {
       // NSString *user_id =
        NSLog(@"user_id=%@", info);

        self.userApi.method_id = _GET_USER_; //1 means getUserInfo;
        [self.userApi requestUserInfo:info];
   
    }
    else if(self.userApi.method_id == _GET_USER_)
    {
        self.user = info;
        isok = YES;//可以进行页面跳转
        if(isok)
          NSLog(@"Hello world");
        if (isok) {
            [self performSegueWithIdentifier:@"login" sender:self];
        }

    }
}

//登陆失败，通过代理返回数据给loginview
- (void)requestDataOnFail:(NSString *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您好:" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    [self.errorLabel setHidden:YES];
    self.nameField.text = @"";
    self.passwordField.text = @"";
}

@end
