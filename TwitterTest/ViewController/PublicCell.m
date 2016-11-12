//
//  PublicCell.m
//  TwitterTest
//
//  Created by Munib Siddiqui on 11/10/16.
//  Copyright (c) 2016 Munib Siddiqui. All rights reserved.
//

#import "PublicCell.h"



@interface PublicCell ()
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UIImageView *headImageView;
@property (strong, nonatomic) IBOutlet KILabel *tweetText;
@property (strong, nonatomic) IBOutlet UIButton *btnRetweetCount;

@end

@implementation PublicCell
@synthesize delegationListener = delegationListener;

-(void) setValueWithTweetObject : (TweetModel *) tweetObject
{
    _userName.text = tweetObject.userName;
    _tweetText.text = [tweetObject.detail stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [_btnRetweetCount setTitle:tweetObject.retweetCount forState:UIControlStateNormal];
    if (tweetObject.imageUrl != nil) {
            [_headImageView setImageWithURL:tweetObject.imageUrl];
    }
    NSLog(@"identifier Cell -- > %@",tweetObject.identifier);
    
    __weak typeof(self) weakSelf = self;

    // Attach a block to be called when the user taps a user handle
    _tweetText.userHandleLinkTapHandler = ^(KILabel *label, NSString *string, NSRange range) {

        if(weakSelf.delegationListener && [weakSelf.delegationListener respondsToSelector:@selector(userHandleLinkTapHandler:)]){
            [weakSelf.delegationListener userHandleLinkTapHandler:string];
        }
        
    };
    
    // Attach a block to be called when the user taps a hashtag
    _tweetText.hashtagLinkTapHandler = ^(KILabel *label, NSString *string, NSRange range) {
        
        if(weakSelf.delegationListener && [weakSelf.delegationListener respondsToSelector:@selector(hashtagLinkTapHandler:)]){
            [weakSelf.delegationListener hashtagLinkTapHandler:string];
        }
        
    };
    
    // Attach a block to be called when the user taps a URL
    _tweetText.urlLinkTapHandler = ^(KILabel *label, NSString *string, NSRange range) {

        if(weakSelf.delegationListener && [weakSelf.delegationListener respondsToSelector:@selector(urlLinkTapHandler:)]){
            [weakSelf.delegationListener urlLinkTapHandler:string];
        }
    };
}

-(void)prepareForReuse{
    
    _headImageView.image = nil;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
