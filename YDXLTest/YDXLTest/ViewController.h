//
//  ViewController.h
//  YDXLTest
//
//  Created by liuyang_sy on 13-12-3.
//  Copyright (c) 2013年 LY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "LoadMoreTableFooterView.h"
#import "ISSTSpittlesApi.h"
#import "ISSTUserModel.h"
#import "ISSTSpittleContentModel.h"

////////////
#import "JsonParser.h"
////////////

@interface ViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, LoadMoreTableFooterDelegate,EGORefreshTableHeaderDelegate, UITextFieldDelegate>
{
    EGORefreshTableHeaderView *_refreshTableView;
    LoadMoreTableFooterView  *_loadMoreTableView;
    BOOL _reloading;
    
}

@property (strong,nonatomic)ISSTUserModel *userModel;
@property (assign, nonatomic) int scrollOrientation;
@property (strong,nonatomic)ISSTSpittlesApi *spittleApi;
@property (strong, nonatomic) IBOutlet UIButton *nameBtn;//昵称修改
@property (strong, nonatomic) IBOutlet UILabel *nameLable;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) IBOutlet UITableViewCell *secondTableViewCell;

@property (strong, nonatomic)IBOutlet UIActivityIndicatorView *activityIndicatorView;

@property (weak, nonatomic) IBOutlet UIView *textFieldView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableViewSS;
@property (strong, nonatomic) NSMutableArray *array;
@property(strong,nonatomic)ISSTSpittleContentModel *spittleContent;
@property(strong,nonatomic)NSString *userId;
@property(strong,nonatomic)UITableViewCell *selectedCell;
@property(strong,nonatomic) NSIndexPath* selectedindexPath;

- (IBAction)SortControls:(UISegmentedControl *)sender;

- (IBAction)SendSpittle:(id)sender;//发送吐槽内容
-(IBAction)likeBtnClick:(UIButton *)sender;
-(IBAction)dislikeBtnClick:(UIButton *)sender;


//开始重新加载时调用的方法
- (void)reloadTableViewDataSource;
//完成加载时调用的方法
- (void)doneLoadingTableViewData;

@end
