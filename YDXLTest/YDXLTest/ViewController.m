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

-(void) viewWillAppear:(BOOL)animated {
    
    if (userModel) {
        NSLog(@"%@",userModel.Uid );
        //self..titleLabel.text = userModel.Unickname;
        nameLable.text= userModel.Unickname;
    }
    
    [super viewWillAppear:animated];
    [spittleApi requestDownGetSpittlesWithUserId:userModel.Uid andPage:0 andPageSize:10];
    spittleContent=[[ISSTSpittleContentModel alloc]init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.spittleApi = [[ISSTSpittlesApi alloc]init];
    self.spittleApi.webApiDelegate =self;
    NSLog(@"userModel=%@",userModel.Utype);
//    array = [JsonParser parser];
  
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
    //注册键盘出现通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardDidShow:) name: UIKeyboardDidShowNotification object:nil];
    //注册键盘隐藏通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardDidHide:) name: UIKeyboardDidHideNotification object:nil];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [array count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *CellIdentifier = @"WeiboCell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        UILabel *title=[cell viewWithTag:101];
        UILabel *Likes=[cell viewWithTag:6];
        UILabel *Dislikes=[cell viewWithTag:7];
        spittleContent.SCnickname=[[array objectAtIndex:indexPath.section] valueForKey:@"nickname"];
        spittleContent.SClikes=[[[array objectAtIndex:indexPath.section]valueForKey:@"likes"] stringValue];
        spittleContent.SCdislikes=[[[array objectAtIndex:indexPath.section]valueForKey:@"dislikes"]stringValue];
//        if(spittleContent!=nil)
        title.text=spittleContent.SCnickname;
        Likes.text=spittleContent.SClikes;
        Dislikes.text=spittleContent.SCdislikes;
        NSLog(@"celllikes=%@",Dislikes.text);
//        else title.text=nil;
        return cell;
     }
    else {
        static NSString *CellIdentifier = @"WeiboCell2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        UILabel *content=[cell viewWithTag:104];
        UILabel *Time=[cell viewWithTag:105];
        NSLog(@"CellArray=%@",[[array objectAtIndex:indexPath.section] valueForKey:@"content"]);
        spittleContent.SCcontent=[[array objectAtIndex:indexPath.section] valueForKey:@"content"];
        spittleContent.SCposttime=
        content.text=spittleContent.SCcontent;
        NSString  *postTime =[[[array objectAtIndex:indexPath.section]valueForKey:@"postTime"]stringValue];
        NSDate  *datePT = [NSDate dateWithTimeIntervalSince1970:[postTime longLongValue]];
        NSLog(@"%@",datePT);
        //得到毫秒
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm:ss"];
        spittleContent.SCposttime = [dateFormatter stringFromDate:datePT];
        NSLog(@"Date%@",spittleContent.SCposttime);
        Time.text=spittleContent.SCposttime;
        return cell;
    }
    
    //cell.textLabel.text = @"Haha!!";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 40.0f;
    } else {
        return 70.0f;
    }
    //return 70.0f;
}

#pragma mark -
#pragma mark ISSTWebApiDelegate
- (void)requestDataOnSuccess:(id)backToControllerData
{
    if (self.spittleApi.method_id == PUT_NAME) {
        nameLable.text=userModel.Unickname;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改成功！！！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    else if(self.spittleApi.method_id == POST_SPITTLE)
    {
        [self.tableViewSS reloadData];
        
    }
    else if(self.spittleApi.method_id == DOWN_REFRESH)
    {
        array=backToControllerData;
        NSLog(@"array=%@",array);
        [self.tableViewSS reloadData];
    }
    else if(self.spittleApi.method_id == UP_REFRESH)
    {
        [self.tableViewSS reloadData];
    }
    else if(self.spittleApi.method_id == LIKE_SPITTLE_REFRESH)
    {
        //RESPONSE: [{id: int, userId: int, nickname: string, content: string, postTime: timestamp, likes: int, dislikes: int, isLiked: 0|1, isDisliked:0|1}]
        array=backToControllerData;
        NSLog(@"likedict=%@",array);
        [self.tableViewSS reloadData];
    }
    else if(self.spittleApi.method_id == EGG_SPITTLE_REFRESH)
    {
        
    }
    else if(self.spittleApi.method_id == EGG_SPITTLE)
    {
        
    }
    else if (self.spittleApi.method_id == LIKE_SPITTLE)
    {
        
    }

}

- (void)requestDataOnFail:(NSString *)error
{
   // UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您好:" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
   // [alert show];
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
  //  self.scrollOrientation = DownScrollToRefresh;
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
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    NSLog(@"1234");
//    NSLog(@"视图滚动中X轴坐标%f",scrollView.contentOffset.x);
//
//    NSLog(@"视图滚动中X轴坐标%f",scrollView.contentOffset.y);
//    
//}
//滚动控件的委托方法  // 触摸屏幕来滚动画面还是其他的方法使得画面滚动，皆触发该函数
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int height = MAX(self.tableViewSS.bounds.size.height, self.tableViewSS.contentSize.height);
    height =self.tableViewSS.contentSize.height-self.tableViewSS.bounds.size.height;
    NSLog(@"height=%d",height);
    NSLog(@"bounds.size=%f",self.tableViewSS.bounds.size.height);
        NSLog(@"contentSize=%f", self.tableViewSS.contentSize.height);
 //   NSLog(@"视图滚动中X轴坐标%f",scrollView.contentOffset.x);
    
    NSLog(@"视图滚动中Y轴坐标%f",scrollView.contentOffset.y);

    if(scrollView.contentOffset.y<= 0) //加载新数据
    {
        self.scrollOrientation = DownScrollToRefresh;
    }
   else
   {//加载旧数据
        self.scrollOrientation = UPScrollToRequestOld;
    }

    if (self.scrollOrientation == UPScrollToRequestOld) {
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

//// 滚动停止时，触发该函数
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    NSLog(@"scrollViewDidEndDecelerating  -   End of Scrolling.");
//}



#pragma mark -
#pragma mark  upload data
//请求数据
-(void)reloadData
{
    _reloading = YES;
    //新建一个线程来加载数据
    [NSThread detachNewThreadSelector:@selector(requestData)
                             toTarget:self
                           withObject:nil];
}

-(void)requestData
{
  //  NSArray *arr = @[@"柳眉",@"李倩梅",@"清水",@"天运子"];
  //  [self.array addObjectsFromArray:arr];
    sleep(3);
    //在主线程中刷新UI
    [self performSelectorOnMainThread:@selector(reloadUI)
                           withObject:nil
                        waitUntilDone:NO];
}

-(void)reloadUI
{
	_reloading = NO;
    
    //停止下拉的动作,恢复表格的便宜
	[_loadMoreTableView loadMoreScrollViewDataSourceDidFinishedLoading:self.tableViewSS];
    //更新界面
    [self.tableViewSS reloadData];
    [self setRefreshViewFrame];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods
//开始重新加载时调用的方法
- (void)reloadTableViewDataSource{
	_reloading = YES;
    //开始刷新后执行后台线程，在此之前可以开启HUD或其他对UI进行阻塞
    [NSThread detachNewThreadSelector:@selector(doInBackground) toTarget:self withObject:nil];
}

//完成加载时调用的方法
- (void)doneLoadingTableViewData{
    //NSLog(@"doneLoadingTableViewData");
    
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
    //NSLog(@"doInBackground");
    
    [NSThread sleepForTimeInterval:1];
    
    //后台操作线程执行完后，到主线程更新UI
    [self performSelectorOnMainThread:@selector(doneLoadingTableViewData) withObject:nil waitUntilDone:YES];
}




-(void) viewWillDisappear:(BOOL)animated {
    //解除键盘出现通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name: UIKeyboardDidShowNotification object:nil];
    //解除键盘隐藏通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name: UIKeyboardDidHideNotification object:nil];
    [super viewWillDisappear:animated];
}

- (void)keyboardDidShow:(NSNotification *) notify
{
    NSDictionary *info = [notify userInfo];
    NSValue *aValue = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyBoardSize = [aValue CGRectValue].size;
    
    CGRect rect = self.textFieldView.frame;
    rect.origin.y = self.view.frame.size.height - keyBoardSize.height - rect.size.height;
    self.textFieldView.frame = rect;
}

- (void)keyboardDidHide:(NSNotification *) notify
{
    
    CGRect rect = self.textFieldView.frame;
    rect.origin.y = self.view.frame.size.height - rect.size.height -  49;
    self.textFieldView.frame = rect;
}




//修改昵称
- (IBAction)nameBtnClick:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改昵称" message:@"输入新的昵称" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%@",userModel.Uid);
    UITextField *tf=[alertView textFieldAtIndex:0];
    NSLog(@"%@",tf.text);
    if(buttonIndex==1)
    {
        [self.spittleApi requestPutNameWithUserId:userModel.Uid andNickName:tf.text];
        userModel.Unickname=tf.text;
    }
    
}


- (IBAction)textFieldReturnEditing:(id)sender
{
    [sender resignFirstResponder];
}

//发送吐槽内容
- (IBAction)backgroundTab:(id)sender
{
    if(textField.text!=nil)
    {
        spittleContent.SCuserid=userModel.Uid;
        spittleContent.SCcontent=textField.text;
//        spittleContent.SCdislikes=@"0";
//        spittleContent.SClikes=@"0";
//        spittleContent.SCyear=@"2013";
        [spittleApi requestPostSpittleWithUserId:spittleContent.SCuserid andContent:spittleContent.SCcontent];
        //[array insertObject:spittleContent atIndex:0];
    }
    
    [self.textFieldView endEditing:YES];
    
}
-(IBAction)likeBtnClick:(id)sender
{
    
   
}
-(IBAction)dislikeBtnClick:(id)sender
{
    
}
- (IBAction)SortControls:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0:
            [spittleApi requestDownGetSpittlesWithUserId:userModel.Uid andPage:0 andPageSize:10];
            break;
        case 1:
            NSLog(@"1=%d",sender.selectedSegmentIndex);
          [spittleApi requestLikeGetSpittlesWithUserId:userModel.Uid andLike:YES andCount:20];
            break;
        case 2:
             NSLog(@"2=%d",sender.selectedSegmentIndex);
            [spittleApi requestLikeGetSpittlesWithUserId:userModel.Uid andLike:NO andCount:20];
            break;
        default:
            break;
       }
    
}
@end
