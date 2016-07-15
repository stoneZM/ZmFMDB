//
//  FMDBModel.h
//  ZmFMDB
//
//  Created by stone on 16/7/14.
//  Copyright © 2016年 zm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMDBModel : NSObject

@property (nonatomic,strong)NSString* name;

@property (nonatomic,assign)NSInteger sID;

@property (nonatomic,strong)NSString* hobby;

@property (nonatomic,strong)NSString* sex;

@property (nonatomic,assign)NSInteger age;

+(NSArray*)getAllList;

-(void)insertData;

+(FMDatabase*)defaultFMDB;

-(NSArray*)search;

-(void)remove;

-(void)update;

@end
