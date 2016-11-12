//
//  TweetModel.m
//  TwitterTest
//
//  Created by Munib Siddiqui on 11/10/16.
//  Copyright (c) 2016 Munib Siddiqui. All rights reserved.
//

#import "TweetModel.h"

@implementation TweetModel

-(TweetModel *)setupWithJson:(NSDictionary *)j {
    
    if ( ! [Validator validateObject:j] )
        return nil;
    
    TweetModel *t = [TweetModel new];
    
    NSDictionary *user = j[kTweetUser];
    
    t.identifier = [NSNumber numberWithLongLong:[j[kTweetIdentifier] longLongValue]];
    t.userName = user[kTweetUserName];
    t.imageUrl = [NSURL URLWithString:user[kTweetUserProfileImageUrl]];
    t.detail = j[kTweetText];
    t.retweetCount = [j[kTweetReTweetCount] stringValue];
    t.date = [self formatedDate:j[kTweetdate]];
    return t;
    
}

-(NSString *)formatedDate:(NSString *)created_date{
    

    NSDateFormatter *iosDateFormater=[[NSDateFormatter alloc]init];
    iosDateFormater.dateFormat=@"EEE MMM d HH:mm:ss Z yyyy";
    
    iosDateFormater.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    NSDate *date=[iosDateFormater dateFromString:created_date];
    
    NSDateFormatter *resultFormatter=[[NSDateFormatter alloc]init];
    [resultFormatter setDateFormat:@"MM dd HH:mm"];
    
    return  [resultFormatter stringFromDate:date];
}

@end
