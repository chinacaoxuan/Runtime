//
//  FMDBSingle.h
//  RuntimeDemo
//
//  Created by Demon on 2017/8/9.
//  Copyright © 2017年 lisong. All rights reserved.
//

#import <fmdb/FMDB.h>

@interface FMDBSingle : FMDatabase

+ (instancetype)sharedInstace;

- (void)query;

@end
