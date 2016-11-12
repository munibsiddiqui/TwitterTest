//
//  PublicTableViewController.h
//  TwitterTest
//
//  Created by Munib Siddiqui on 11/10/16.
//  Copyright (c) 2016 Munib Siddiqui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublicTableViewController : UITableViewController

@property (nonatomic, strong) UIView *refreshLoadingView;
@property (nonatomic, strong) UIView *refreshColorView;
@property (assign) BOOL isRefreshAnimating;

@property (nonatomic, strong) Refresh *myRefresh;
@end
