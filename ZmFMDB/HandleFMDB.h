//
//  HandleFMDB.h
//  ZmFMDB
//
//  Created by stone on 16/7/15.
//  Copyright © 2016年 zm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HandleFMDB : NSObject

@property (nonatomic,assign)NSInteger rowNum;
@property (nonatomic,strong)NSArray* dataArr;

-(NSString*)nameForRow:(NSInteger)row;
-(void)refreshData;
-(void)removeForRow:(NSInteger)row;
-(NSArray*)searchByName:(NSString*)name;

@end
