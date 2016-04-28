//
//  DbController.h
//  Fmdb
//
//  Created by matsu on 2016/03/30.
//  Copyright © 2016年 sample. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"


@interface DbController : NSObject

+ (NSString*)getDbPath;
- (void)insertTable : (NSArray*)insertValues;
- (NSArray*)selectTable;

@property NSString *ydate;
@property NSString *tenki;
@property NSString *iconURL;
@end

