//
//  NetRequestClass.m
//  TwitterTest
//
//  Created by Munib Siddiqui on 11/10/16.
//  Copyright (c) 2016 Munib Siddiqui. All rights reserved.
//

#import "NetRequestClass.h"

@interface NetRequestClass ()

@end


@implementation NetRequestClass


+ (BOOL) netWorkReachabilityWithURLString:(NSString *) strUrl
{
    __block BOOL netState = NO;
    
    NSURL *baseURL = [NSURL URLWithString:strUrl];
    
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    
    NSOperationQueue *operationQueue = manager.operationQueue;
    
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [operationQueue setSuspended:NO];
                netState = YES;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                netState = NO;
            default:
                [operationQueue setSuspended:YES];
                break;
        }
    }];
    
    [manager.reachabilityManager startMonitoring];
    
    return netState;
}




#pragma --mark GET
+ (void) NetRequestGETWithRequestURL: (NSString *) requestURLString
                       WithParameter: (NSDictionary *) parameter
                WithReturnValeuBlock: (ReturnValueBlock) block
                  WithErrorCodeBlock: (ErrorCodeBlock) errorBlock
                    WithFailureBlock: (FailureBlock) failureBlock
{
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    
    NSURLSessionDataTask *op = [manager GET:requestURLString
                                 parameters:parameter
                                progress:^(NSProgress * _Nonnull downloadProgress) {
                                }
                                success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        DDLog(@"%@", dic);
        
        //block(dic);
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        NSLog(@"%@", [error description]);
        failureBlock();
    }];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [op resume];
    
}

#pragma --mark POST

+ (void) NetRequestPOSTWithRequestURL: (NSString *) requestURLString
                        WithParameter: (NSDictionary *) parameter
                 WithReturnValeuBlock: (ReturnValueBlock) block
                   WithErrorCodeBlock: (ErrorCodeBlock) errorBlock
                     WithFailureBlock: (FailureBlock) failureBlock
{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    
    NSURLSessionDataTask *op = [manager POST:requestURLString
                                  parameters:parameter
                                progress:^(NSProgress * _Nonnull uploadProgress) {
                                }success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        DDLog(@"%@", dic);
        

        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        failureBlock();
    }];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [op resume];

}




@end
