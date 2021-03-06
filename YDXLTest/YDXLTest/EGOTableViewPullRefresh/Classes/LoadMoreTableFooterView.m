//
//  EGORefreshTableHeaderView.m
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "LoadMoreTableFooterView.h"

#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f

@interface LoadMoreTableFooterView (Private)
- (void)setState:(EGOPullRefreshState)aState;
//- (CGFloat)scrollViewOffsetFromBottom:(UIScrollView *) scrollView;
//- (CGFloat)visibleTableHeightDiffWithBoundsHeight:(UIScrollView *) scrollView;
@end

@implementation LoadMoreTableFooterView

@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor  {
    if((self = [super initWithFrame:frame])) {
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
        //modify by shenjx begin
        //		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 18, self.frame.size.width, 20.0f)];
        //modify by shenjx end
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont systemFontOfSize:12.0f];
		label.textColor = textColor;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		[self addSubview:label];
		_lastUpdatedLabel=label;
		[label release];
		
        //modify by shenjx begin
        //		label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 48.0f, self.frame.size.width, 20.0f)];
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 5.0f, self.frame.size.width, 20.0f)];
        //modify by shenjx end
        
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:13.0f];
		label.textColor = textColor;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
		[label release];
		
		CALayer *layer = [CALayer layer];
        //modify by shenjx begin
		//layer.frame = CGRectMake(25.0f, frame.size.height - 65.0f, 30.0f, 55.0f);
        layer.frame = CGRectMake(25.0f, 5.0f, 30.0f, 55.0f);
        //modify by shenjx end
		layer.contentsGravity = kCAGravityResizeAspect;
		layer.contents = (id)[UIImage imageNamed:arrow].CGImage;
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			layer.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		
		[[self layer] addSublayer:layer];
		_arrowImage=layer;
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        //modify by shenjx begin
		//view.frame = CGRectMake(25.0f, frame.size.height - 38.0f, 20.0f, 20.0f);
        view.frame = CGRectMake(25.0f, 5.0f, 20.0f, 20.0f);
        //modify by shenjx end
        
		[self addSubview:view];
		_activityView = view;
		[view release];
		
		
		[self setState:EGOOPullRefreshNormal];
		
    }
	
    return self;
	
}

- (id)initWithFrame:(CGRect)frame  {
    return [self initWithFrame:frame arrowImageName:@"blueArrow.png" textColor:TEXT_COLOR];
}

#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate {
	
	if ([_delegate respondsToSelector:@selector(loadMoreTableFooterDataSourceLastUpdated:)]) {
		
		NSDate *date = [_delegate loadMoreTableFooterDataSourceLastUpdated:self];
		
		[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
		NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        //		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
        //		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSString *lastUpdated = NSLocalizedString(@"上次更新", @"");
		_lastUpdatedLabel.text = [NSString stringWithFormat:@"%@ %@",lastUpdated, [dateFormatter stringFromDate:date]];
		[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		
	} else {
		
		_lastUpdatedLabel.text = nil;
		
	}
    
}

- (void)setState:(EGOPullRefreshState)aState{
	
	switch (aState) {
		case EGOOPullRefreshPulling:
			
            //			_statusLabel.text = NSLocalizedString(@"Release to refresh...", @"Release to refresh status");
            _statusLabel.text = NSLocalizedString(@"释放刷新...", @"");
            
            
            [CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
            _arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
            
			break;
		case EGOOPullRefreshNormal:
			
			if (_state == EGOOPullRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
                [CATransaction commit];
			}
			
            //			_statusLabel.text = NSLocalizedString(@"Pull down to refresh...", @"Pull down to refresh status");
            _statusLabel.text = NSLocalizedString(@"上拉刷新...", @"");
			[_activityView stopAnimating];
            
            [CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			_arrowImage.hidden = NO;
            _arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
            
			[CATransaction commit];
			[self refreshLastUpdatedDate];
			
			break;
            
		case EGOOPullRefreshLoading:
			
            //			_statusLabel.text = NSLocalizedString(@"Loading...", @"Loading Status");
            _statusLabel.text = NSLocalizedString(@"加载...", @"");
			[_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			_arrowImage.hidden = YES;
			[CATransaction commit];
			break;
		default:
			break;
	}
	
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)loadMoreScrollViewDidScroll:(UIScrollView *)scrollView {
    float offY          = scrollView.contentOffset.y;
    float contentHeight = scrollView.contentSize.height;
    float boundsHeight  = scrollView.bounds.size.height;
	if (_state == EGOOPullRefreshLoading)
    {
        //modify by shenjx begin
        
		//在下拉刷新时中，若正在loading,滚动视图，若继续下拉，则应该只让向下偏移65单位；若向上滚动，则应该可以继续往下看，相应的偏移值就应该减小（但不能小过60），否则有可能看不到最下面一行的数据
        //在上拉加载时，若正在loading，若继续上拉，则应该只让向上偏移65个单位，若向下滚动，则应该可以继续网上看，相应的偏移值应该变小（但不能小过60），否则有可能看不到最上面一行数据
        //		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);//滚动过程中当前偏移
        //		offset = MIN(offset, 60);//滚动过程实际偏移调整（调整后）
        CGFloat  offset = MAX(offY * -1, contentHeight - boundsHeight);
        offset = MIN(offset, 60);
        //		scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
        scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0f, offset, 0.0f);
        
		
	} else if (scrollView.isDragging) {
		
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(loadMoreTableFooterDataSourceIsLoading:)]) {
			_loading = [_delegate loadMoreTableFooterDataSourceIsLoading:self];
		}
		//
        double d = contentHeight - boundsHeight < 0?0:contentHeight - boundsHeight;
        //		if (_state == EGOOPullRefreshPulling && offY > -65.0f && offY < 0.0f && !_loading)
        if (_state == EGOOPullRefreshPulling &&
            offY < d + 65 &&
            offY > d &&
            !_loading)
        {
			[self setState:EGOOPullRefreshNormal];
		}
        //        else if (_state == EGOOPullRefreshNormal && offY < -65.0f && !_loading)
        else if (_state == EGOOPullRefreshNormal &&
                 offY > d + 65
                 && !_loading)
        {
			[self setState:EGOOPullRefreshPulling];
		}
		
		//if (scrollView.contentInset.top != 0) {
        if (scrollView.contentInset.bottom != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
        //modify by shenjx end
	}
	
}


- (void)loadMoreScrollViewDidEndDragging:(UIScrollView *)scrollView {
    //modify by shenjx begin
    float offY = scrollView.contentOffset.y;
    float contentHeight = scrollView.contentSize.height;
    float boundsHeight = scrollView.bounds.size.height;
	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(loadMoreTableFooterDataSourceIsLoading:)]) {
		_loading = [_delegate loadMoreTableFooterDataSourceIsLoading:self];
	}
	//if (scrollView.contentOffset.y <= - 65.0f && !_loading)
    int d = contentHeight - boundsHeight > 0 ? contentHeight - boundsHeight : 0;
	if (offY >= (d + 65) && !_loading)
    {
		
		if ([_delegate respondsToSelector:@selector(loadMoreTableFooterDidTriggerLoadMore:)]) {
			[_delegate loadMoreTableFooterDidTriggerLoadMore:self];
		}
        
		[self setState:EGOOPullRefreshLoading];
        
        
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
        
        //当表里的内容高度小于表格高度时，上拉刷新时，提示是看不到的,故需要做如下处理
        int f = contentHeight - boundsHeight ;
		//scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        if (f < 0)
        {
            CGRect rect = self.frame;
            self.frame = CGRectMake(rect.origin.x, rect.origin.y-60, rect.size.width, rect.size.height);
        }
        else
        {
            scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0f, 60.0f, 0.0f);
        }
        
        //modify by shenjx end
		[UIView commitAnimations];
		
	}
	
}

- (void)loadMoreScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[self setState:EGOOPullRefreshNormal];
    
}


//- (id)initWithFrame:(CGRect)frame {
//    if (self = [super initWithFrame:frame]) {
//		
//        isLoading = NO;
//        
//        CGFloat midY = PULL_AREA_HEIGTH/2;
//        
//        /* Config Status Updated Label */
//		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, midY - 10, self.frame.size.width, 20.0f)];
//		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//		label.font = [UIFont boldSystemFontOfSize:13.0f];
//		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
//		label.backgroundColor = [UIColor clearColor];
//		label.textAlignment = UITextAlignmentCenter;
//		[self addSubview:label];
//		_statusLabel=label;
//		
//        /* Config Arrow Image */
//		CALayer *layer = [[CALayer alloc] init];
//		layer.frame = CGRectMake(25.0f,midY - 20, 30.0f, 55.0f);
//		layer.contentsGravity = kCAGravityResizeAspect;
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
//		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
//			layer.contentsScale = [[UIScreen mainScreen] scale];
//		}
//#endif
//		[[self layer] addSublayer:layer];
//		_arrowImage=layer;
//		
//        /* Config activity indicator */
//		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:DEFAULT_ACTIVITY_INDICATOR_STYLE];
//		view.frame = CGRectMake(25.0f,midY - 8, 20.0f, 20.0f);
//		[self addSubview:view];
//		_activityView = view;		
//		
//		[self setState:EGOOPullNormal]; // Also transform the image
//        
//        /* Configure the default colors and arrow image */
//        [self setBackgroundColor:nil textColor:nil arrowImage:nil];
//		
//    }
//	
//    return self;
//	
//}
//
//#pragma mark - Util
//- (CGFloat)scrollViewOffsetFromBottom:(UIScrollView *) scrollView
//{
//    CGFloat scrollAreaContenHeight = scrollView.contentSize.height;
//    
//    CGFloat visibleTableHeight = MIN(scrollView.bounds.size.height, scrollAreaContenHeight);
//    CGFloat scrolledDistance = scrollView.contentOffset.y + visibleTableHeight; // If scrolled all the way down this should add upp to the content heigh.
//    
//    CGFloat normalizedOffset = scrollAreaContenHeight -scrolledDistance;
//    
//    return normalizedOffset;
//    
//}
//
//- (CGFloat)visibleTableHeightDiffWithBoundsHeight:(UIScrollView *) scrollView
//{
//    return (scrollView.bounds.size.height - MIN(scrollView.bounds.size.height, scrollView.contentSize.height));
//}
//
//
//#pragma mark -
//#pragma mark Setters
//
//
//- (void)setState:(EGOPullState)aState{
//	
//	switch (aState) {
//		case EGOOPullPulling:
//			
//			_statusLabel.text = NSLocalizedStringFromTable(@"Release to load more...",@"PullTableViewLan", @"Release to load more status");
//			[CATransaction begin];
//			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
//			_arrowImage.transform = CATransform3DIdentity;
//			[CATransaction commit];
//			
//			break;
//		case EGOOPullNormal:
//			
//			if (_state == EGOOPullPulling) {
//				[CATransaction begin];
//				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
//				_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
//				[CATransaction commit];
//			}
//			
//			_statusLabel.text = NSLocalizedStringFromTable(@"Pull up to load more...", @"PullTableViewLan",@"Pull down to load more status");
//			[_activityView stopAnimating];
//			[CATransaction begin];
//			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
//			_arrowImage.hidden = NO;
//			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
//			[CATransaction commit];
//            
//			break;
//		case EGOOPullLoading:
//			
//			_statusLabel.text = NSLocalizedStringFromTable(@"Loading...", @"PullTableViewLan",@"Loading Status");
//			[_activityView startAnimating];
//			[CATransaction begin];
//			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
//			_arrowImage.hidden = YES;
//			[CATransaction commit];
//			
//			break;
//		default:
//			break;
//	}
//	
//	_state = aState;
//}
//
//- (void)setBackgroundColor:(UIColor *)backgroundColor textColor:(UIColor *) textColor arrowImage:(UIImage *) arrowImage
//{
//    self.backgroundColor = backgroundColor? backgroundColor : DEFAULT_BACKGROUND_COLOR;
//    _statusLabel.textColor = textColor? textColor: DEFAULT_TEXT_COLOR;
//    _statusLabel.shadowColor = [_statusLabel.textColor colorWithAlphaComponent:0.1f];
//    _arrowImage.contents = (id)(arrowImage? arrowImage.CGImage : DEFAULT_ARROW_IMAGE.CGImage);
//}
//
//
//#pragma mark -
//#pragma mark ScrollView Methods
//
//
//- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView {	
//    CGFloat bottomOffset = [self scrollViewOffsetFromBottom:scrollView];
//	if (_state == EGOOPullLoading) {
//        
//		CGFloat offset = MAX(bottomOffset * -1, 0);
//		offset = MIN(offset, PULL_AREA_HEIGTH);
//        UIEdgeInsets currentInsets = scrollView.contentInset;
//        currentInsets.bottom = offset? offset + [self visibleTableHeightDiffWithBoundsHeight:scrollView]: 0;
//        scrollView.contentInset = currentInsets;
//		
//	} else if (scrollView.isDragging) {
//		if (_state == EGOOPullPulling && bottomOffset > -PULL_TRIGGER_HEIGHT && bottomOffset < 0.0f && !isLoading) {
//			[self setState:EGOOPullNormal];
//		} else if (_state == EGOOPullNormal && bottomOffset < -PULL_TRIGGER_HEIGHT && !isLoading) {
//			[self setState:EGOOPullPulling];
//            
//		}
//		
//		if (scrollView.contentInset.bottom != 0) {
//            UIEdgeInsets currentInsets = scrollView.contentInset;
//            currentInsets.bottom = 0;
//            scrollView.contentInset = currentInsets;
//		}
//		
//	}
//	
//}
//
//- (void)startAnimatingWithScrollView:(UIScrollView *) scrollView {
//    isLoading = YES;
//    [self setState:EGOOPullLoading];
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:0.2];
//    UIEdgeInsets currentInsets = scrollView.contentInset;
//    currentInsets.bottom = PULL_AREA_HEIGTH + [self visibleTableHeightDiffWithBoundsHeight:scrollView];
//    scrollView.contentInset = currentInsets;
//    [UIView commitAnimations];
//    if([self scrollViewOffsetFromBottom:scrollView] == 0){
//        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y + PULL_TRIGGER_HEIGHT) animated:YES];
//    }
//}
//
//- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
//	
//	
//	if ([self scrollViewOffsetFromBottom:scrollView] <= - PULL_TRIGGER_HEIGHT && !isLoading) {
//        if ([_delegate respondsToSelector:@selector(loadMoreTableFooterDidTriggerLoadMore:)]) {
//            [_delegate loadMoreTableFooterDidTriggerLoadMore:self];
//        }
//        [self startAnimatingWithScrollView:scrollView];
//	}
//	
//}
//
//- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {	
//	
//    isLoading = NO;
//    
//	[UIView beginAnimations:nil context:NULL];
//	[UIView setAnimationDuration:.3];
//    UIEdgeInsets currentInsets = scrollView.contentInset;
//    currentInsets.bottom = 0;
//    scrollView.contentInset = currentInsets;
//	[UIView commitAnimations];
//	
//	[self setState:EGOOPullNormal];
//    
//}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	_delegate=nil;
	_activityView = nil;
	_statusLabel = nil;
	_arrowImage = nil;
	_lastUpdatedLabel = nil;
    [super dealloc];
    
//	_delegate=nil;
//	[_activityView release];
//	[_statusLabel release];
//	[_arrowImage release];
//    [super dealloc];
}


@end
