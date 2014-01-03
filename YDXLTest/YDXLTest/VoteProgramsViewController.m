//
//  VoteProgramsViewController.m
//  iSST
//
//  Created by liuyang_sy on 13-12-11.
//  Copyright (c) 2013年 LY. All rights reserved.
//

#import "VoteProgramsViewController.h"

@interface VoteProgramsViewController ()

@end

@implementation VoteProgramsViewController

@synthesize programsApi;
@synthesize array;
@synthesize tableViewSS;
@synthesize selectedCell;
@synthesize selectedindexPath;
@synthesize tempVote;

@synthesize showModel;

@synthesize activityIndicatorView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.programsApi = [[ISSTProgramsApi alloc] init];
    self.programsApi.webApiDelegate =self;
    [self dataLoad];
    tempVote=[[NSMutableArray alloc] initWithCapacity:30];
    if (activityIndicatorView==nil) {
          activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    self.activityIndicatorView.center =CGPointMake(160, 200);
    [self.view addSubview:self.activityIndicatorView];
    [self.tableViewSS setBackgroundView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tableview_back.jpg"]]];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if(([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.edgesForExtendedLayout= UIRectEdgeNone;
    }
	// Do any additional setup after loading the view.
    self.array= [NSMutableArray arrayWithCapacity:50];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [array count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"programvote";
    showModel = [array objectAtIndex:indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    UILabel *programName = (UILabel *)[cell viewWithTag:1];
    UILabel *programStatus = (UILabel *)[cell viewWithTag:2];
    UIButton *vote = (UIButton *)[cell viewWithTag:3];
    
    if(array!=nil)
    {
      //  programName.text=[[array objectAtIndex:indexPath.section]valueForKey:@"name"];
        programName.text = showModel.Sname;
        UIFont *font = [UIFont systemFontOfSize:17.0];
        CGSize size = CGSizeMake(280, 2000.0f);
        size = [ programName.text sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
        [programName setFrame:CGRectMake(15, 0, size.width, size.height+10)];
       // switch ([[[array objectAtIndex:indexPath.section]valueForKey:@"status"] intValue])

        switch ([showModel.Sstatus intValue])
        {
        case 0:
            programStatus.text=@"未开始";
            break;
        case 1:
            programStatus.text=@"正在进行";
            break;
        case 2:
            programStatus.text=@"已结束";
            break;
        }
        if([showModel.SvoteTime intValue]==0)
        {
          //  [tempVote addObject:@"0"];
            UIImage *voteimage=[UIImage imageNamed:@"vote.png"];
            [vote setImage:voteimage forState:nil];
        }
        else
        {
            //[tempVote addObject:@"1"];
            UIImage *voteimage=[UIImage imageNamed:@"voted.png"];
            [vote setImage:voteimage forState:nil];
        }
    }
    else
    {
        [self dataLoad];
    }
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIFont *font = [UIFont systemFontOfSize:17.0];
    ISSTShowModel *tempModel = [array objectAtIndex:indexPath.section];
  //  NSString *content = [[array objectAtIndex:indexPath.section] valueForKey:@"name"];
    NSString *content = tempModel.Sname;

    CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(280, 1000)lineBreakMode:UILineBreakModeWordWrap];
    return size.height + 50; // 5即消息上下的空间，可自由调整
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)requestDataOnSuccess:(id)backToControllerData;
{
    
    if(programsApi.method_id==PROGRAMS_LIST)
    {
        array=[[NSMutableArray alloc]init];
        array=backToControllerData;
        [tableViewSS reloadData];
    }
    else if(programsApi.method_id==VOTE)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"投票结果" message:@"恭喜你投票成功！！！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        UIButton *vote = (UIButton *)[selectedCell viewWithTag:3];
        UIImage *voteimage=[UIImage imageNamed:@"voted.png"];
        [vote setImage:voteimage forState:nil];
       // [tempVote setObject:@"1" atIndexedSubscript:selectedindexPath.section];
        showModel = [array objectAtIndex:selectedindexPath.section];
        showModel.SvoteTime = @"1";
        [self.tableViewSS reloadData];
    }
    [self.activityIndicatorView stopAnimating];
    self.activityIndicatorView.hidesWhenStopped = YES;
    
}

- (void)requestDataOnFail:(NSString *)error
{
    [self.activityIndicatorView stopAnimating];
    self.activityIndicatorView.hidesWhenStopped = YES;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您好:" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}


- (IBAction)voteProgram:(id)sender {
    UIView *v=(UIView *)[sender superview];
    UITableViewCell *mycell=(UITableViewCell *)[v superview];
    
    if(([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
        selectedCell=(UITableViewCell *)[mycell superview];
    else
        selectedCell=(UITableViewCell *)mycell;
    selectedindexPath=[tableViewSS indexPathForCell:selectedCell];
    showModel =[array objectAtIndex:selectedindexPath.section] ;
    if([showModel.Sstatus intValue]==0)
    {
        NSString *info=[[NSString alloc]initWithFormat:@"节目《%@》尚未开始，请开始后再投，谢谢！",showModel.Sname];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"说明" message:info delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if([showModel.SvoteTime intValue]==0)
    {
        NSString *info=[[NSString alloc]initWithFormat:@"您可投的票数有限，确定为《%@》投上您宝贵的一票吗？",showModel.Sname];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"投票确认" message:info delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"说明" message:@"每个节目限投一票，您已为本节目投过，谢谢您的支持！！！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        NSUserDefaults *defaults=[[NSUserDefaults alloc]init];
        NSString *userId = [defaults valueForKey:@"userid"];
        showModel = [array objectAtIndex:selectedindexPath.section];
        [self.programsApi voteWithUserId:userId WithShowID:[showModel.Sid  intValue]];
    }
    
}
-(void)dataLoad
{
    [self.activityIndicatorView startAnimating];
    self.activityIndicatorView.hidesWhenStopped = NO;
    
    NSUserDefaults *defaults=[[NSUserDefaults alloc]init];
    NSString *userId = [defaults valueForKey:@"userid"];
    [self.programsApi requestProgramsListWithUserId:userId];
  //  [tempVote removeAllObjects];
    [tableViewSS reloadData];
    
}


- (IBAction)refreshTableView:(id)sender {
    [self dataLoad];
}
@end
