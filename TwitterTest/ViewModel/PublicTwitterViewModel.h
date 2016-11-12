//
//  PublicTwitterViewModel.h
//  TwitterTest
//
//  Created by Munib Siddiqui on 11/10/16.
//  Copyright (c) 2016 Munib Siddiqui. All rights reserved.
//

#import "ViewModelClass.h"
#import "PublicModel.h"

@interface PublicTwitterViewModel : ViewModelClass

-(void) fetchPublicWeiBoWithQuery:(NSString *)query SinceID:(NSString *)sinceID Page:(NSString *)pageCount SearchMetaData:(NSDictionary *)searchMeta;

@end
