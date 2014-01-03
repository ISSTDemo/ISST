//
//  ViewController.m
//  YDXLTest
//
//  Created by liuyang_sy on 13-12-3.
//  Copyright (c) 2013年 LY. All rights reserved.
//

#import "ViewController.h"

#define UPScrollToRequestOld 1
#define DownScrollToRefresh  2

@interface ViewController ()

@end

@implementation ViewController

@synthesize textFieldView, textField, tableViewSS, array,nameLable;
@synthesize spittleApi;
@synthesize userModel;
@synthesize spittleContent;
@synthesize selectedCell;
@synthesize selectedindexPath;
@synthesize segmentedControl;
@synthesize activityIndicatorView;
@synthesize secondTableViewCell;

int  currentPage =1;
BOOL sendMessageTimeOk = TRUE;


- (void)viewDidLoad
{
    [super viewDidLoad];
    if(([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.edgesForExtendedLayout= UIRectEdgeNone;
    }
    if (userModel) {
        nameLable.text= userModel.Unickname;
        NSUserDefaults *defaults=[[NSUserDefaults alloc]init];
       [defaults setObject:userModel.Unickname forKey:@"nickname"];
    }
	if (_refreshTableView == nil) {
        EGORefreshTableHeaderView *refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableViewSS.bounds.size.height, self.view.frame.size.width, self.tableViewSS.bounds.size.height)];
        refreshView.delegate = self;
        [self.tableViewSS addSubview:refreshView];
        _refreshTableView = refreshView;
    }
    if (_loadMoreTableView == nil) {
        LoadMoreTableFooterView  *loadMoreTableView = [[LoadMoreTableFooterView alloc]initWithFrame:CGRectZero];
        loadMoreTableView.delegate =self;
        [self.tableViewSS addSubview:loadMoreTableView];
        _loadMoreTableView = loadMoreTableView;
    }
    _reloading = NO;
 
}

-(void) viewWillAppear:(BOOL)animated {
    self.spittleApi = [[ISSTSpittlesApi alloc]init];
    self.spittleApi.webApiDelegate = self;
    
    NSUserDefaults *defaults=[[NSUserDefaults alloc]init];
    if ([defaults objectForKey:@"nickname"]!=nil) {
        nameLable.text=[defaults objectForKey:@"nickname"];
    }
    else if (userModel) {
        nameLable.text= userModel.Unickname;
    }
    
    activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicatorView.center =CGPointMake(160, 200);
    [self.view addSubview:self.activityIndicatorView];
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    [self.spittleApi requestDownGetSpittlesWithUserId:self.userModel.Uid andPage:1 andPageSize:20];
    
    [defaults setObject:userModel.Uid forKey:@"userid"];
    [defaults setObject:userModel.Ufullname forKey:@"userfullname"];
    [self.tableViewSS setBackgroundView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tableview_back.jpg"]]];
    
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setRefreshViewFrame];
    
}

-(void)setRefreshViewFrame
{
    //如果contentsize的高度比表的高度小，那么就需要把刷新视图放在表的bounds的下面
    int height = MAX(self.tableViewSS.bounds.size.height, self.tableViewSS.contentSize.height);
    _loadMoreTableView.frame =CGRectMake(0.0f, height, self.view.frame.size.width, self.tableViewSS.bounds.size.height);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [array count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    spittleContent=[[ISSTSpittleContentModel alloc]init];
        spittleContent=[array objectAtIndex:indexPath.section] ;
    if (indexPath.row == 0) {
        static NSString *CellIdentifier = @"WeiboCell1";
       
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        UILabel *title=(UILabel *)[cell viewWithTag:101];
        UILabel *Likes=(UILabel *)[cell viewWithTag:6];
        UILabel *Dislikes=(UILabel *)[cell viewWithTag:7];
        UIImageView *islike=(UIImageView *)[cell viewWithTag:1];
        UIImageView *isdislike=(UIImageView *)[cell viewWithTag:2];
//        spittleContent.SCnickname=[[array objectAtIndex:indexPath.section] valueForKey:@"nickname"];
//        spittleContent.SClikes=[[[array objectAtIndex:indexPath.section]valueForKey:@"likes"] stringValue];
//        spittleContent.SCdislikes=[[[array objectAtIndex:indexPath.section]valueForKey:@"dislikes"]stringValue];
//        spittleContent.SCisliked=[[[array objectAtIndex:indexPath.section] valueForKey:@"isLiked"]stringValue];
//        spittleContent.SCisdisliked=[[[array objectAtIndex:indexPath.section]valueForKey:@"isDisliked"]stringValue];
        if([spittleContent.SCisliked isEqualToString:@"1"])
            islike.image=[UIImage imageNamed:@"Good2.png"];
        else
            islike.image=[UIImage imageNamed:@"Good1.png"];
        if([spittleContent.SCisdisliked isEqualToString:@"1"])
            isdislike.image=[UIImage imageNamed:@"Bad2.png"];
        else
            isdislike.image=[UIImage imageNamed:@"Bad1.png"];
        
        title.text=spittleContent.SCnickname;
        Likes.text=spittleContent.SClikes;
        Dislikes.text=spittleContent.SCdislikes;
        return cell;
     }
    else {
        static NSString *CellIdentifier = @"WeiboCell2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        UILabel *content=(UILabel *)[cell viewWithTag:104];
        UILabel *Time=(UILabel *)[cell viewWithTag:105];
       // spittleContent.SCcontent=[[array objectAtIndex:indexPath.section] valueForKey:@"content"];
        content.text=spittleContent.SCcontent;
        UIFont *font = [UIFont systemFontOfSize:14.0];
        CGSize size = CGSizeMake(280, 2000.0f);
        size = [spittleContent.SCcontent sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
        [content setFrame:CGRectMake(20, 0, size.width, size.height+10)];
        
//        NSString  *postTime = spittleContent.SCposttime; //[[[array objectAtIndex:indexPath.section]valueForKey:@"postTime"]stringValue];
//        NSDate  *datePT = [NSDate dateWithTimeIntervalSince1970:[postTime longLongValue]];
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"HH:mm:ss"];
//        spittleContent.SCposttime = [dateFormatter stringFromDate:datePT];
        Time.text=spittleContent.SCposttime;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 40.0f;
    } else {
        UIFont *font = [UIFont systemFontOfSize:14.0];
        ISSTSpittleContentModel *model = [array objectAtIndex:indexPath.section];
                                          NSString *content =model.SCcontent;
        CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(280, 1000)lineBreakMode:UILineBreakModeWordWrap];
        return size.height + 30; // 5即消息上下的空间，可自由调整
    }
}

#pragma mark -
#pragma mark ISSTWebApiDelegate
- (void)requestDataOnSuccess:(id)backToControllerData
{

    if (self.spittleApi.method_id == PUT_NAME) {
        
        [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
        nameLable.text=userModel.Unickname;
        NSUserDefaults *defaults=[[NSUserDefaults alloc]init];
        [defaults setObject:nameLable.text forKey:@"nickname"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改成功！！！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if(self.spittleApi.method_id == POST_SPITTLE)
    {
        [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
        self.activityIndicatorView.hidesWhenStopped=YES;
        [self.activityIndicatorView stopAnimating];
        segmentedControl.selectedSegmentIndex=0;
        [spittleApi requestDownGetSpittlesWithUserId:userModel.Uid andPage:1 andPageSize:20];
    }
    else if(self.spittleApi.method_id == DOWN_REFRESH)
    {
        [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
        array=backToControllerData;
        currentPage =1;
        [self.tableViewSS reloadData];
    }
    else if(self.spittleApi.method_id == UP_REFRESH)
    {
        [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
        NSMutableArray *tempArray = [[NSMutableArray alloc]init];
        [tempArray addObjectsFromArray:array];
        for (ISSTSpittleContentModel *spittle in (NSArray*)backToControllerData) {
            [tempArray addObject:spittle];
        }
        _reloading = NO;
        array=tempArray;
        [_loadMoreTableView loadMoreScrollViewDataSourceDidFinishedLoading:self.tableViewSS];
        [self.tableViewSS reloadData];
        [self setRefreshViewFrame];
    }
    else if(self.spittleApi.method_id == LIKE_SPITTLE_REFRESH)
    {
        //RESPONSE: [{id: int, userId: int, nickname: string, content: string, postTime: timestamp, likes: int, dislikes: int, isLiked: 0|1, isDisliked:0|1}]
        [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
        array=backToControllerData;
        [self.tableViewSS reloadData];
    }
    else if(self.spittleApi.method_id == EGG_SPITTLE_REFRESH)
    {
        [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
        array=backToControllerData;
        [self.tableViewSS reloadData];
    }
    else if(self.spittleApi.method_id == EGG_SPITTLE)
    {
        [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
        UILabel *Dislikes=(UILabel *)[selectedCell viewWithTag:7];
        UIImageView *islike=(UIImageView *)[selectedCell viewWithTag:2];
        spittleContent=   [array objectAtIndex:selectedindexPath.section];

        NSString *dislikes=[[NSString alloc] initWithFormat:@"%d",[spittleContent.SCdislikes intValue]+1];
        Dislikes.text=dislikes;
        islike.image=[UIImage imageNamed:@"Bad2.png"];
        spittleContent.SCisdisliked=@"1";
        spittleContent.SCdislikes=[NSString stringWithFormat:@"%d",[spittleContent.SCdislikes intValue]+1 ];
        [self.tableViewSS reloadData];
    }
    else if (self.spittleApi.method_id == LIKE_SPITTLE)
    {
        [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
        UILabel *Likes=(UILabel *)[selectedCell viewWithTag:6];
        UIImageView *islike=(UIImageView *)[selectedCell viewWithTag:1];
        
     spittleContent=   [array objectAtIndex:selectedindexPath.section];
        
        NSString *likes=[[NSString alloc] initWithFormat:@"%d",[spittleContent.SClikes intValue]+1];
        Likes.text=likes;
        islike.image=[UIImage imageNamed:@"Good2.png"];
        spittleContent.SCisliked=@"1";
        spittleContent.SClikes=[NSString stringWithFormat:@"%d",[spittleContent.SClikes intValue]+1 ];
        [self.tableViewSS reloadData];
    }
    self.activityIndicatorView.hidesWhenStopped=YES;
    [self.activityIndicatorView stopAnimating];

}

- (void)requestDataOnFail:(NSString *)error
{
    UIAlertView *alert ;
    switch (self.spittleApi.method_id) {
        case POST_SPITTLE:
        case PUT_NAME:
            break;
        case LIKE_SPITTLE:
        case EGG_SPITTLE:
            break;
        case LIKE_SPITTLE_REFRESH:
        case EGG_SPITTLE_REFRESH:
        case UP_REFRESH:
        case DOWN_REFRESH:
            array= nil;
            break;
        default:
            break;
    }
    alert  = [[UIAlertView alloc] initWithTitle:@"您好:" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    self.activityIndicatorView.hidesWhenStopped=YES;
    [self.activityIndicatorView stopAnimating];

    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
}

#pragma mark -
#pragma mark LoadMoreTableFooterDelegate Methods
//出发下拉刷新动作，开始拉取数据
- (void)loadMoreTableFooterDidTriggerLoadMore:(LoadMoreTableFooterView*)view
{
   // self.scrollOrientation = UPScrollToRequestOld;
    [self reloadData];
}
//返回当前刷新状态：是否在刷新
- (BOOL)loadMoreTableFooterDataSourceIsLoading:(LoadMoreTableFooterView*)view
{
    return _reloading;
}
//返回刷新时间
-(NSDate *)loadMoreTableFooterDataSourceLastUpdated:(LoadMoreTableFooterView *)view
{
    return [NSDate date];
}
#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods
//下拉被触发调用的委托方法
-(void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    [self reloadTableViewDataSource];
}

//返回当前是刷新还是无刷新状态
-(BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return _reloading;
}

//返回刷新时间的回调方法
-(NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
    return [NSDate date];
}
#pragma mark -
#pragma mark UIScrollViewDelegate Methods
//滚动控件的委托方法  // 触摸屏幕来滚动画面还是其他的方法使得画面滚动，皆触发该函数
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.textFieldView endEditing:YES];
    int height = MAX(self.tableViewSS.bounds.size.height, self.tableViewSS.contentSize.height);
    height =self.tableViewSS.contentSize.height-self.tableViewSS.bounds.size.height;

    if(scrollView.contentOffset.y<= 0) //加载新数据
    {
        self.scrollOrientation = DownScrollToRefresh;
    }
   else
   {
        self.scrollOrientation = UPScrollToRequestOld;
    }

    if (self.scrollOrientation == UPScrollToRequestOld)
    {
         [_loadMoreTableView loadMoreScrollViewDidScroll:scrollView];
    }
    else if(self.scrollOrientation ==DownScrollToRefresh)
    {
        [_refreshTableView egoRefreshScrollViewDidScroll:scrollView];

    }
}
// 触摸屏幕并拖拽画面，再松开，最后停止时，触发该函数
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.scrollOrientation == UPScrollToRequestOld) {
        [_loadMoreTableView loadMoreScrollViewDidEndDragging:scrollView];
    }
    else if(self.scrollOrientation ==DownScrollToRefresh)
    {
        [_refreshTableView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

#pragma mark -
#pragma mark  upload data
//请求数据
-(void)reloadData
{
    _reloading = YES;
    switch (segmentedControl.selectedSegmentIndex)
    {
        case 0:
            [self.tableViewSS addSubview: _loadMoreTableView ];
             [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
            spittleContent = [array objectAtIndex:0];
            [self.spittleApi requestUpGetSpittlesGetSpittlesWithUserId:self.userModel.Uid andMaxSpittleIdOfCurrentPage:spittleContent.SCid  andNextPage:++currentPage andPageSize:20];
            break;
        case 1:
             [_loadMoreTableView removeFromSuperview ];
            break;
        case 2:
             [_loadMoreTableView removeFromSuperview ];
            break;
        default:
            break;
    }
    //新建一个线程来加载数据
    [NSThread detachNewThreadSelector:@selector(requestData)
                             toTarget:self
                           withObject:nil];
}

-(void)requestData
{

    sleep(1);
    //在主线程中刷新UI
    [self performSelectorOnMainThread:@selector(reloadUI)
                           withObject:nil
                        waitUntilDone:NO];
}

-(void)reloadUI
{
	_reloading = NO;
	[_loadMoreTableView loadMoreScrollViewDataSourceDidFinishedLoading:self.tableViewSS];
    //更新界面
    [self.tableViewSS reloadData];
    [self setRefreshViewFrame];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods
//开始重新加载时调用的方法  ,加载最新数据
- (void)reloadTableViewDataSource{
	_reloading = YES;
     [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    switch (segmentedControl.selectedSegmentIndex)
    {
        case 0:
            //加载20条新数据，时间排序
            [self.spittleApi requestDownGetSpittlesWithUserId:self.userModel.Uid andPage:1 andPageSize:20];
            break;
        case 1:
             //加载20条新数据，赞排序
            [self.spittleApi requestLikeGetSpittlesWithUserId:self.userModel.Uid andLike:YES andCount:20];
            break;
        case 2:
             //加载20条新数据，鸡蛋排序
             [self.spittleApi requestLikeGetSpittlesWithUserId:self.userModel.Uid andLike:NO andCount:20];
            break;
        default:
            break;
    }
    //开始刷新后执行后台线程，在此之前可以开启HUD或其他对UI进行阻塞
    [NSThread detachNewThreadSelector:@selector(doInBackground) toTarget:self withObject:nil];
}

//完成加载时调用的方法
- (void)doneLoadingTableViewData{
	_reloading = NO;
	[_refreshTableView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableViewSS];
    //刷新表格内容
    [self.tableViewSS reloadData];
}

#pragma mark -
#pragma mark Background operation
//这个方法运行于子线程中，完成获取刷新数据的操作
-(void)doInBackground
{
    [NSThread sleepForTimeInterval:1];
    
    //后台操作线程执行完后，到主线程更新UI
    [self performSelectorOnMainThread:@selector(doneLoadingTableViewData) withObject:nil waitUntilDone:YES];
}




-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect rect = self.textFieldView.frame;
    rect.origin.y = self.view.frame.size.height - 216 - 10;
    
    NSTimeInterval animationDuration = 0.3f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    self.textFieldView.frame = rect;
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    CGRect rect = self.textFieldView.frame;
    self.textFieldView.frame = CGRectMake(0, self.view.frame.size.height - 49 + 10, rect.size.width, rect.size.height);
    return YES;
}

//发送吐槽内容
- (IBAction)SendSpittle:(id)sender
{
    if(textField.text!=nil)
    {
        spittleContent.SCuserid=userModel.Uid;
         if (textField.text.length <= 0 )
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您好:" message:@"输入为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
             [alert show];
             return;

         }
        else if (textField.text.length < 5 ) {
             int index = arc4random() % 5;
            NSArray *messageInfo = @[@"输入字符太少",
                                     @"输入字数不能少于5个奥，亲",
                                     @"亲，请多输入几个字吧",
                                     @"亲，不要太懒奥，再打几个字吧",
                                     @"字数太少不能发送"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您好:" message:[messageInfo objectAtIndex:index] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return;

        }
        else if (textField.text.length>140)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您好:" message:@"输入字符太多" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            textField.text=@"";
            return;
        }
        

        
        if (sendMessageTimeOk) {
            sendMessageTimeOk=NO;
            
            self.activityIndicatorView.hidesWhenStopped =NO;
            [self.activityIndicatorView startAnimating];
            [spittleApi requestPostSpittleWithUserId:spittleContent.SCuserid andContent:textField.text];
            [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(sendSpittle:) userInfo:textField.text repeats:NO];
            spittleContent.SCcontent=textField.text;
            textField.text= @"";
            [self.textFieldView endEditing:YES];
            
            UISegmentedControl *segment=(UISegmentedControl *)[self.view viewWithTag:50];
            segment.selectedSegmentIndex=0;
          
        }
        else
        {
            int index = arc4random() % 3;
            NSArray *messageInfo = @[@"发送过于频繁",
                                     @"等几秒后再发送奥，亲",
                                     @"后面的节目更精彩，别忘了看节目奥",
                                    ];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您好:" message:[messageInfo objectAtIndex:index] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return;
        }
    }
    
}

-(void)sendSpittle:(NSTimer*)timer
{
    sendMessageTimeOk =TRUE;
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
}


-(IBAction)likeBtnClick:(UIButton*)sender
{
    UIView *v=(UIView *)[sender superview];
    UITableViewCell *mycell=(UITableViewCell *)[v superview];
    if(([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
        selectedCell=(UITableViewCell *)[mycell superview];
    else
        selectedCell=(UITableViewCell *)mycell;
    selectedindexPath=[tableViewSS indexPathForCell:selectedCell];
    spittleContent = [array objectAtIndex:selectedindexPath.section];
    if([spittleContent.SCisdisliked isEqualToString:@"0"]  &&[spittleContent.SCisliked isEqualToString:@"0"])
    {
        [self.spittleApi requestLikeSpittleWithUserId:self.userModel.Uid andSpittlesId:spittleContent.SCid andLike:YES];
    }
}
-(IBAction)dislikeBtnClick:(UIButton*)sender
{
    UIView *v=(UIView *)[sender superview];
    UITableViewCell *mycell=(UITableViewCell *)[v superview];
    if(([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
        selectedCell=(UITableViewCell *)[mycell superview];
    else
        selectedCell=(UITableViewCell *)mycell;
    selectedindexPath=[tableViewSS indexPathForCell:selectedCell];
spittleContent = [array objectAtIndex:selectedindexPath.section];
    if([spittleContent.SCisdisliked isEqualToString:@"0"] &&[spittleContent.SCisliked isEqualToString:@"0" ])

    {
        [self.spittleApi requestLikeSpittleWithUserId:self.userModel.Uid andSpittlesId:spittleContent.SCid  andLike:NO];
    }
}
- (IBAction)SortControls:(UISegmentedControl *)sender
{
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    switch (sender.selectedSegmentIndex)
    {
        case 0:
            [spittleApi requestDownGetSpittlesWithUserId:userModel.Uid andPage:1 andPageSize:20];
            break;
        case 1:
            [spittleApi requestLikeGetSpittlesWithUserId:userModel.Uid andLike:YES andCount:20];
            break;
        case 2:
            [spittleApi requestLikeGetSpittlesWithUserId:userModel.Uid andLike:NO andCount:20];
            break;
        default:
            break;
       }
    
}
@end
