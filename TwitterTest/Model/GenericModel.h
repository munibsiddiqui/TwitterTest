//
//  GenericModel.h
//  TwitterTest
//
//  Created by Munib Siddiqui on 11/10/16.
//  Copyright (c) 2016 Munib Siddiqui. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Validator.h"

@interface GenericModel : NSObject

-(NSArray *)setupListWithJson:(NSArray *)list;
-(id)setupWithJson:(NSDictionary *)json;

@end
