//
//  PublicTableViewController.m
//  TwitterTest
//
//  Created by Munib Siddiqui on 11/10/16.
//  Copyright (c) 2016 Munib Siddiqui. All rights reserved.
//

#import "SettingTableViewController.h"
#import "PublicTableViewController.h"
#import "PublicTwitterViewModel.h"
#import "PublicCell.h"

@interface PublicTableViewController ()<UISearchBarDelegate,UIScrollViewDelegate,PublicCellProtocol>

@property (strong, nonatomic) NSMutableArray *publicModelArray;
@property (strong, nonatomic) NSDictionary *searchMetaData;
@property (strong, nonatomic) NSTimer *refreshTimer;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) PublicTwitterViewModel *publicViewModel;

@end

@implementation PublicTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60.0;
    _publicModelArray = [NSMutableArray new];
    
    [self setupTwitterModel];

    [self setupRefreshControl];
    
    [self rightBarButtonItemSetting];
    
    [self initiateTimer];
    
    [self addObserverForUserFault];
}

-(void)dealloc{
    
    [self removeAddObserverForUserDefault];
}

- (void)addObserverForUserFault{
    
    [[NSUserDefaults standardUserDefaults] addObserver:self
                                            forKeyPath:kSettingKey
                                               options:NSKeyValueObservingOptionNew
                                               context:NULL];
}

-(void) removeAddObserverForUserDefault{
    
    [[NSUserDefaults standardUserDefaults] removeObserver:self forKeyPath:kSettingKey];

}

- (void) initiateTimer{
    
    int timerIntervale = 0;
    
   NSNumber *number =  [[NSUserDefaults standardUserDefaults] objectForKey:kSettingKey];
    if ([number intValue] == 1) {
        timerIntervale = 2.0;
    }else if ([number intValue] == 2){
        timerIntervale = 5.0;
    }else if ([number intValue] == 3){
        timerIntervale = 30.0;
    }else if ([number intValue] == 4){
        timerIntervale = 30.0;
    }
    
    if (timerIntervale > 0) {
        
        
        
        
        _refreshTimer = [NSTimer scheduledTimerWithTimeInterval:timerIntervale
                                                             target:self
                                                           selector:@selector(refresh:)
                                                           userInfo:nil
                                                            repeats:YES];
        
        
    }
    
    
}


- (void)restartTimer{
    
    [_refreshTimer invalidate];
    _refreshTimer = nil;
    
    [self initiateTimer];
}


- (void) navigateToSettingViewController{
    
    SettingTableViewController *settingVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingTableViewController"];
    [self.navigationController pushViewController:settingVC animated:YES];
}

#pragma mark - Local Methods


- (void) rightBarButtonItemSetting{
    
    UIImage *faceImage = [UIImage imageNamed:@"setting_img"];
    UIButton *face = [UIButton buttonWithType:UIButtonTypeCustom];
    [face addTarget:self action:@selector(navigateToSettingViewController) forControlEvents:UIControlEventTouchUpInside];
    face.bounds = CGRectMake( 0, 0, 30, 30 );
    [face setImage:faceImage forState:UIControlStateNormal];
    
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithCustomView:face];
    
    [self.navigationItem setRightBarButtonItem:settingsButton];
}

-(void)showProgressView{

    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];

    [SVProgressHUD showWithStatus:@"Fetching Tweets."];
}

- (void)setupTwitterModel{
   
    if (!_publicViewModel)
    _publicViewModel = [[PublicTwitterViewModel alloc] init];
    
    __weak typeof(self) weakSelfViewController = self;
    
    [_publicViewModel setBlockWithReturnBlock:^(id returnValue, id searchMetaData) {
        
        [SVProgressHUD dismiss];
        NSArray *statusArray = (NSArray *)returnValue;
        
        if (weakSelfViewController.isRefreshAnimating) {
            
            [weakSelfViewController.publicModelArray insertObjects:statusArray
                                                         atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, statusArray.count)]];
        }else{
            [weakSelfViewController.publicModelArray addObjectsFromArray:returnValue];
        }
        
        [weakSelfViewController.refreshControl endRefreshing];
    
        
        _searchMetaData = searchMetaData;
        [weakSelfViewController.tableView reloadData];
        DDLog(@"%@",weakSelfViewController.publicModelArray);
        
    } WithErrorBlock:^(id errorCode) {
        
        [SVProgressHUD dismiss];
        
    } WithFailureBlock:^{
        
        [SVProgressHUD dismiss];
        
    }];
    
}

// load tweets
- (void) loadTweetsWithSearchQuery:(NSString *)searchQuery {

    if (searchQuery.length > 0) {
        
        [self showProgressView];
        
        [_publicViewModel fetchPublicWeiBoWithQuery:searchQuery SinceID:[self getLatestTweetID] Page:[self getPageCount] SearchMetaData:_searchMetaData];
    }
  

}

- (NSString *)getLatestTweetID{
    
    if (!_isRefreshAnimating) {
        if (_publicModelArray.count > 0 ) {
            TweetModel *tweet = [_publicModelArray objectAtIndex:_publicModelArray.count-1];
            NSLog(@"identifier -----> %@",tweet.identifier);
            return [[NSNumber numberWithInt:[tweet.identifier longLongValue] - 1.0 ] stringValue];
        }
    }else{
        if (_publicModelArray.count > 0 ) {
            TweetModel *tweet = [_publicModelArray objectAtIndex:0];
            NSLog(@"identifier -----> %@",tweet.identifier);
            return [tweet.identifier  stringValue];
        }

    }
  
    return @"0";
}

- (NSString *)getPageCount{
    
    if (self.publicModelArray.count == 0) {
        return @"0";
    }
    
    NSInteger pageNumber = self.publicModelArray.count/kTweetPerPage;
    return [NSString stringWithFormat:@"%ld",(long)pageNumber];
}

- (NSString *)getSearchStringFromSearchBar{
    if (_searchBar.text.length > 0) {
        return _searchBar.text;
    }
    return @"";
}

-(void)setSearchStringToSearchBar:(NSString *)searchQuery{
    
    if(self.searchBar)
    [self.searchBar setText:searchQuery];
    [_publicModelArray removeAllObjects];
    [self.tableView reloadData];

    [self loadTweetsWithSearchQuery:searchQuery];
    
}


#pragma mark - Refresh

- (void)setupRefreshControl {
    
    // Programmatically inserting a UIRefreshControl & Get Rect
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor clearColor];
    CGRect refreshBounds = self.refreshControl.bounds;
    
    // Setup the loading view, which will hold the moving graphics
    self.refreshLoadingView = [[UIView alloc] initWithFrame:refreshBounds];
    self.refreshLoadingView.backgroundColor = [UIColor clearColor];
    self.refreshLoadingView.clipsToBounds = YES;
    
    // Setup the color view, which will display the rainbowed background
    self.refreshColorView = [[UIView alloc] initWithFrame:refreshBounds];
    self.refreshColorView.backgroundColor = [UIColor lightGrayColor];
    self.refreshColorView.alpha = 0.30;
    
    // Add the loading and colors views to our refresh control
    [self.refreshControl addSubview:self.refreshColorView];
    [self.refreshControl addSubview:self.refreshLoadingView];
    
    // Initalize flags
    self.isRefreshAnimating = NO;
    
    // When activated, invoke our refresh function
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    // Refresh shapes setup & call draw refresh element
    _myRefresh = [[Refresh alloc] init];
    [_myRefresh drawRefreshShapes];
    
    // Add it two element of animationsLayers into refreshLoadingView layer
    [self.refreshLoadingView.layer addSublayer:_myRefresh.animationLayerCirclePath];
    [self.refreshLoadingView.layer addSublayer:_myRefresh.animationLayerStrokePath];
}

- (void)animateRefreshView {
    
    // Animate Refresh shapes
    [_myRefresh animateRefreshShapes];
    
    // Flag that we are animating
    self.isRefreshAnimating = YES;
    
    // Background color to loop through for our color view
    NSArray *colorArray = @[
                            [UIColor lightGrayColor],
                            [UIColor greenColor],
                            [UIColor darkGrayColor],
                            [UIColor lightGrayColor],
                            [UIColor orangeColor],
                            [UIColor blueColor],
                            [UIColor lightGrayColor],
                            [UIColor redColor]];
    
    static int colorIndex = 0;
    
    [UIView animateWithDuration:1.5
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         // Change the background color
                         self.refreshColorView.backgroundColor = [colorArray objectAtIndex:colorIndex];
                         colorIndex = (colorIndex + 1) % colorArray.count;
                     }
                     completion:^(BOOL finished) {
                         
                         if (self.refreshControl.isRefreshing)
                         {
                             [self animateRefreshView];
                         }
                         else
                         {
                             self.isRefreshAnimating = NO;
                         }
                     }];
}

- (void)refresh:(id)sender {
    
    [self loadTweetsWithSearchQuery:[self getSearchStringFromSearchBar]];
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _publicModelArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PublicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PublicCell" forIndexPath:indexPath];
    
    [cell setValueWithTweetObject:_publicModelArray[indexPath.row]];
    cell.delegationListener = self;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //PublicWeiboViewModel *publicViewModel = [[PublicWeiboViewModel alloc] init];
    //[publicViewModel weiboDetailWithPublicModel:_publicModelArray[indexPath.row] WithViewController:self];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    [self.view endEditing:YES];
    
    
    // Get the current size of the refresh controller
    CGRect refreshBounds = self.refreshControl.bounds;
    
    // Distance the table has been pulled >= 0
    CGFloat pullDistance = MAX(0.0, -self.refreshControl.frame.origin.y);
    
    // Set the encompassing view's frames
    refreshBounds.size.height = pullDistance;
    
    self.refreshColorView.frame = refreshBounds;
    self.refreshLoadingView.frame = refreshBounds;
    
    // If we're refreshing and the animation is not playing
    if (self.refreshControl.isRefreshing && !self.isRefreshAnimating)
    {
        [self animateRefreshView];
    }
    
//    if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
//        
//        [self loadTweetsWithSearchQuery:[self getSearchStringFromSearchBar]];
//
//    }

}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    NSInteger currentOffset = scrollView.contentOffset.y;
    NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    if (maximumOffset - currentOffset <= -1) {
        [self loadTweetsWithSearchQuery:[self getSearchStringFromSearchBar]];
    }
}

#pragma mark UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [self.view endEditing:YES];
    
    [_publicModelArray removeAllObjects];
    [self.tableView reloadData];
    
    [self loadTweetsWithSearchQuery:[self getSearchStringFromSearchBar]];
}



#pragma mark - PublicCellProtocol

-(void)userHandleLinkTapHandler:(NSString *)UserHandler{

    [self setSearchStringToSearchBar:UserHandler];
}

-(void)hashtagLinkTapHandler:(NSString *)HashTag{
    
    [self setSearchStringToSearchBar:HashTag];
}

-(void)urlLinkTapHandler:(NSString *)LinkURL{
    
    //[self setSearchStringToSearchBar:LinkURL];
}


- (void)observeValueForKeyPath:(NSString *) keyPath ofObject:(id) object change:(NSDictionary *) change context:(void *) context
{
    if([keyPath isEqual:kSettingKey])
    {
        [self restartTimer];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
