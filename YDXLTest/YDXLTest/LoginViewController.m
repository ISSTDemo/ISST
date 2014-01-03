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
@synthesize   activityIndicatorView;
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
    if(([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.edgesForExtendedLayout= UIRectEdgeNone;
    }
    [self.passwordField setSecureTextEntry:YES]; //设置密码输入框的格式为............格式
    isok=false;
    errorLabel.hidden = YES;
    
    self.userApi = [[ISSTUserApi alloc]init];
    self.userApi.webApiDelegate = self;
    [self.activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
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
    [self.nameField resignFirstResponder];
}


- (IBAction)passwordDoneEditing:(id)sender {
    [self.passwordField resignFirstResponder];
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
    else
    {
        //先把虚拟键盘隐藏
        [self.nameField resignFirstResponder];
        [self.passwordField resignFirstResponder];
        self.activityIndicatorView.hidesWhenStopped = NO;
        [activityIndicatorView startAnimating];
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

//确定是否执行页面跳转  ,开始不允许跳转，只有当验证账号和密码正确可以进入后由登录代码执行切换
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if (isok)
        return YES;
    else
        return NO;
  }

//页面跳转传递参数
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UITabBarController *destination =  (UITabBarController*)[segue destinationViewController];
    UIViewController *vc =  [destination.childViewControllers objectAtIndex:0];
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
        self.userApi.method_id = _GET_USER_; //1 means getUserInfo;
        [self.userApi requestUserInfo:info];
   
    }
    else if(self.userApi.method_id == _GET_USER_)
    {
        self.user = info;
        self.activityIndicatorView.hidesWhenStopped = YES;
        [activityIndicatorView stopAnimating];
        isok = YES;//可以进行页面跳转
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
    self.activityIndicatorView.hidesWhenStopped = YES;
    [activityIndicatorView stopAnimating];
}

@end
