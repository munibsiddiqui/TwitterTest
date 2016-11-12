//
//  Config.h
//  TwitterTest
//
//  Created by Munib Siddiqui on 11/10/16.
//  Copyright (c) 2016 Munib Siddiqui. All rights reserved.
//

#ifndef MVVMTest_Config_h
#define MVVMTest_Config_h

typedef void (^ReturnValueBlock) (id returnValue, id searchMeta);
typedef void (^ErrorCodeBlock) (id errorCode);
typedef void (^FailureBlock)();
typedef void (^NetWorkBlock)(BOOL netConnetState);

#define DDLog(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#define kAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

//accessToken

#define kkTwitterOAuth1Version  @"1.0"

#define kTwitterConsumerKey @"FMC9ldAIdSIDEaKT4ytMmXhfJ"
#define kTwitterConsumerSecret @"eQ6SVu3PU4y5pp4sD8sI4A5JaeD5ze6m1TyEZPyO15vmhSgXx1"

#define kTwitterAccessToken @"154433745-qEH3T2lBAI5BFSmvqyVLHcnE6gbRJTt3x5IwzfdQ"
#define kTwitterAccessTokenSecret @"TeV7v6OTTEVqmm5sA7bPjmH28dPDJ7dIqesE55YQvp5pK"


#define REQUESTPUBLICURLTwitter @"https://api.twitter.com/1.1/search/tweets.json?q=twitter"

#define SOURCE @"source"
#define TOKEN @"access_token"
#define COUNT @"count"

#define STATUSES @"statuses"
#define CREATETIME @"created_at"
#define WEIBOID @"id"
#define WEIBOTEXT @"text"
#define USER @"user"
#define UID @"id"
#define HEADIMAGEURL @"profile_image_url"
#define USERNAME @"screen_name"


//// Tweet
#define kTweetIdentifier  @"id"
#define kTweetUser  @"user"
#define kTweetUserName  @"name"
#define kTweetUserProfileImageUrl  @"profile_image_url_https"
#define kTweetText  @"text"
#define kTweetReTweetCount @"retweet_count"
#define kTweetdate @"created_at"

#define kTweetPerPage  10

#define kSettingKey @"SETTINGKEY"

#define kSettingsDefault [NSUserDefaults standardUSerDefaults];

#endif
