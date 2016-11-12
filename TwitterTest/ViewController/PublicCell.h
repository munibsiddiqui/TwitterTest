//
//  PublicCell.h
//  TwitterTest
//
//  Created by Munib Siddiqui on 11/10/16.
//  Copyright (c) 2016 Munib Siddiqui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicModel.h"


@protocol PublicCellProtocol <NSObject>

-(void) userHandleLinkTapHandler:(NSString *)UserHandler;
-(void) hashtagLinkTapHandler:(NSString *)HashTag;
-(void) urlLinkTapHandler:(NSString *)LinkURL;

@end

@interface PublicCell : UITableViewCell
{

}

@property (nonatomic,assign) id<PublicCellProtocol> delegationListener;

-(void) setValueWithDic : (PublicModel *) publicModel;

-(void) setValueWithTweetObject : (TweetModel *) tweetObject;

@end
