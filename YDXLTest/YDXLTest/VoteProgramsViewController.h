//
//  VoteProgramsViewController.h
//  iSST
//
//  Created by liuyang_sy on 13-12-11.
//  Copyright (c) 2013年 LY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISSTProgramsApi.h"
#import "ISSTWebApiDelegate.h"
#import "ISSTShowModel.h"

@interface VoteProgramsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, ISSTWebApiDelegate>

@property (strong, nonatomic) ISSTProgramsApi *programsApi;
@property  (strong, nonatomic) NSMutableArray *array;
@property (weak, nonatomic) IBOutlet UITableView *tableViewSS;
@property(strong,nonatomic)UITableViewCell *selectedCell;
@property(strong,nonatomic) NSIndexPath* selectedindexPath;
@property(strong,nonatomic) ISSTShowModel *showModel;

@property(strong,nonatomic) NSMutableArray *tempVote;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

- (IBAction)voteProgram:(id)sender;

- (IBAction)refreshTableView:(id)sender;  //刷新列表

@end
