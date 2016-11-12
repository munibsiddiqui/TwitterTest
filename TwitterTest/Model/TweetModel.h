//
//  TweetModel.h
//  TwitterTest
//
//  Created by Munib Siddiqui on 11/10/16.
//  Copyright (c) 2016 Munib Siddiqui. All rights reserved.
//

#import "GenericModel.h"

@interface TweetModel : GenericModel

/*!
 * @brief Number of unique identification
 */
@property(nonatomic,strong) NSNumber *identifier;

/*!
 * @brief Binary content for the image of the user that posted the tweet
 */
@property(nonatomic,strong) NSData *image;

/*!
 * @brief URL to get the image of the user that posted the tweet
 */
@property(nonatomic,strong) NSURL *imageUrl;

/*!
 * @brief Name of the user that posted the tweet
 */
@property(nonatomic,strong) NSString *userName;

/*!
 * @brief Content of the tweet
 */
@property(nonatomic,strong) NSString *detail;

/*!
 * @brief Retweet Count of the tweet
 */
@property(nonatomic,strong) NSString *retweetCount;

/*!
 * @brief date of the tweet posted
 */
@property(nonatomic,strong) NSString *date;
@end
