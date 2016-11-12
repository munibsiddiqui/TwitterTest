//
//  Validator.h
//  TwitterTest
//
//  Created by Munib Siddiqui on 11/10/16.
//  Copyright (c) 2016 Munib Siddiqui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Validator : NSObject

+(BOOL)validateObject:(id)object;
+(BOOL)isEmptyString:(NSString *)string;

@end
