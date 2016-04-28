//
//  DbController.m
//  Fmdb
//
//  Created by 松尾 慎治 on 2016/03
//  Copyright © 2016年 sample. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DbController.h"
@implementation DbController : NSObject


- (void)createTable{
    NSArray  *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dir = [paths objectAtIndex:0];
    NSString *db_path  = [dir stringByAppendingPathComponent:@"/Weather.db"];
    NSLog(@"%@", db_path );
    
    FMDatabase *db = [FMDatabase databaseWithPath:db_path];
    // テーブルを作成2
    NSString *sql = @"CREATE TABLE IF NOT EXISTS weather2(id INTEGER PRIMARY KEY AUTOINCREMENT,date TEXT,tenki TEXT,tenki,icon TEXT);";
    [db open];
    // SQLを実行
    [db executeUpdate:sql];
    [db close];
}


//DBのPathを取得する
+ (NSString*)getDbPath{
    //DBのパスを取得
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directry = [paths objectAtIndex:0];
    //    NSLog(@"path=%@",directry);
    return directry;
}



//tabelにINSERTする
- (void)insertTable : (NSArray *)insertValues{
    NSString *path = [[DbController getDbPath] stringByAppendingString:@"/Weather.db"];
    FMDatabase *fmDataBase = [FMDatabase databaseWithPath:path];
    NSString *sql = @"INSERT INTO weather2(date,tenki,icon) VALUES (?,?,?)";
    [fmDataBase open];
    
    @try{
        [fmDataBase executeUpdate:sql,
         [insertValues objectAtIndex:0],
         [insertValues objectAtIndex:1],
         [insertValues objectAtIndex:2]];
    }@catch(NSException *exception) {
        NSLog(@"---insert erro---");
        @throw exception;
        
    }
    [fmDataBase close];
}



//tabelからSelectする
- (NSArray*)selectTable{
    NSString *path = [[DbController getDbPath] stringByAppendingString:@"/Weather.db"];
    FMDatabase *fmDataBase = [FMDatabase databaseWithPath:path];
    NSString *sql = @"SELECT date,tenki,icon FROM weather2;";
    
    [fmDataBase open];
    FMResultSet *result = [fmDataBase executeQuery:sql];
    
    NSMutableArray *dataValues = [[NSMutableArray alloc]init];
    while ([result next]) {
        DbController *data = [[DbController alloc]init];
        data.ydate = [result stringForColumnIndex:0];
        data.tenki = [result stringForColumnIndex:1];
        data.iconURL = [result stringForColumnIndex:2];
        [dataValues addObject:data];
    }
    [fmDataBase close];
    return  dataValues;
}



@end

