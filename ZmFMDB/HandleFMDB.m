//
//  HandleFMDB.m
//  ZmFMDB
//
//  Created by stone on 16/7/15.
//  Copyright © 2016年 zm. All rights reserved.
//

#import "HandleFMDB.h"
#import "FMDBModel.h"

@interface HandleFMDB()

@property (nonatomic,strong)FMDBModel* model;

@end


@implementation HandleFMDB

-(NSArray *)searchByName:(NSString *)name{
    self.model.name = name;
    return [self.model search];
}

-(FMDBModel *)model{
    if (_model == nil) {
        _model = [FMDBModel new];
    }
    return _model;
}


-(NSArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = [FMDBModel getAllList];
    }
    return _dataArr;
}
-(FMDBModel*)modelForRow:(NSInteger)row{

    return self.dataArr[row];
}

-(NSInteger)rowNum{
    return self.dataArr.count;
}

-(NSString *)nameForRow:(NSInteger)row{
    FMDBModel* model = [self modelForRow:row];
    return model.name;
}

-(void)refreshData{
    self.dataArr = [FMDBModel getAllList];
}
-(void)removeForRow:(NSInteger)row{
    FMDBModel* model = [self modelForRow:row];
    [model remove];
}


@end
