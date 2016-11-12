//
//  PublicTwitterViewModel.m
//  TwitterTest
//
//  Created by Munib Siddiqui on 11/10/16.
//  Copyright (c) 2016 Munib Siddiqui. All rights reserved.
//

#import "PublicTwitterViewModel.h"
#import "AppDelegate.h"

@implementation PublicTwitterViewModel


-(void) fetchPublicWeiBoWithQuery:(NSString *)query SinceID:(NSString *)sinceID Page:(NSString *)pageCount SearchMetaData:(NSDictionary *)searchMeta
{
    NSString *maxID = nil;
    
    DDLog(@"SInce ID ------- >>>>> %@",sinceID);

    if (pageCount > 0) {
        maxID = [[searchMeta objectForKey:@"max_id"] stringValue];
    }
    
    [[(AppDelegate*)kAppDelegate twitterClient] getSearchTweetsWithQuery:query
                                                                 geocode:nil
                                                                    lang:nil
                                                                  locale:nil
                                                              resultType:nil
                                                                   count:[NSString stringWithFormat:@"%d",kTweetPerPage]
                                                                   until:nil
                                                                 sinceID:nil
                                                                   maxID:sinceID
                                                         includeEntities:nil
                                                                callback:nil
                                                            successBlock:^(NSDictionary *searchMetadata, NSArray *statuses) {
                                                                
                                                                
                                                                NSMutableArray *list = [NSMutableArray new];

                                                                if ( statuses.count > 0 ) {
                                                                    
                                                                    for ( NSDictionary *obj in statuses ) {
                                                                        
                                                                        TweetModel *t = [[TweetModel new] setupWithJson:obj];
                                                                        
                                                                        [list addObject:t];
                                                                        
                                                                    }
                                                                    
                                                                }
                                                                self.returnBlock(list,searchMetadata);

                                                            } errorBlock:^(NSError *error) {
                                                                
                                                                self.errorBlock(error);
                                                                
                                                            }];
    
}




#pragma 对ErrorCode进行处理
-(void) errorCodeWithDic: (NSDictionary *) errorDic
{
    self.errorBlock(errorDic);
}

#pragma 对网路异常进行处理
-(void) netFailure
{
    self.failureBlock();
}



@end
