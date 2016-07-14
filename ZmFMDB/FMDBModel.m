//
//  FMDBModel.m
//  ZmFMDB
//
//  Created by stone on 16/7/14.
//  Copyright © 2016年 zm. All rights reserved.
//

#import "FMDBModel.h"

@implementation FMDBModel

+(FMDatabase*)defaultFMDB{

    static FMDatabase* db = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       
        NSString* dbPath = ZDOCPATH;
        dbPath = [dbPath stringByAppendingPathComponent:@"test.sqlite"];
        db = [FMDatabase databaseWithPath:dbPath];
    });
   BOOL isOpen = [db open];
    if (isOpen) {
        DDLogVerbose(@"数据库成功打开");
    //创建表
        BOOL createResult = [db executeUpdate:@"CREATE TABLE IF  NOT EXISTS t_student(SID integer,Name text,Age integer,Sex text)"];
        if (createResult) {
            DDLogVerbose(@"可以操作表");
        }else{
            DDLogVerbose(@"不能操作表");
        }
    }else{
        DDLogVerbose(@"数据库打开失败");
    }
    return db;
}



//插入数据
-(void)insertData{
    FMDatabase* db = [FMDBModel defaultFMDB];

   BOOL result = [db executeUpdate:@"INSERT INTO t_student (SID, Name, Age, Sex) VALUES (?,?,?,?)",[NSNumber numberWithInteger:self.sID],self.name,[NSNumber numberWithInteger:self.age],self.sex];
    if (result) {
        DDLogVerbose(@"插入数据成功");
    }else{
        DDLogVerbose(@"插入数据失败");
    }
    [db close];

}
//查询数据



//删除数据


//更改数据




//获取所有列表
+(NSArray*)getAllList{
    NSMutableArray* allList = [NSMutableArray new];
    FMDatabase* db = [FMDBModel defaultFMDB];
    FMResultSet* rs = [db executeQuery:@"SELECT * FROM t_student"];
    while ([rs next]) {
        FMDBModel* model = [FMDBModel new];
        model.sID = [[rs stringForColumn:@"SID"] integerValue];
        model.name = [rs stringForColumn:@"Name"];
        model.age = [[rs stringForColumn:@"Age"] integerValue];
        model.sex = [rs stringForColumn:@"Sex"];
        [allList addObject:model];
    }
    return [allList copy];
}



@end
