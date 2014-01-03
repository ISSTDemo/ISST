//
//  PrizeViewController.m
//  iSST
//
//  Created by jasonross on 13-12-15.
//  Copyright (c) 2013年 LY. All rights reserved.
//

#import "PrizeViewController.h"

@interface PrizeViewController ()

@end

@implementation PrizeViewController
@synthesize webView;
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
	// Do any additional setup after loading the view.
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://xplan.cloudapp.net:8080/isst/party/announcement.html"]];
    [self.view addSubview: webView];
    [webView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
