//
//  FMDBSingle.m
//  RuntimeDemo
//
//  Created by Demon on 2017/8/9.
//  Copyright © 2017年 lisong. All rights reserved.
//

#import "FMDBSingle.h"

@implementation FMDBSingle
  static FMDBSingle *db = nil;
+ (instancetype)sharedInstace {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        db = [[self alloc] initWithPath:getPath()];
    });
    
    return db;
}

NSString *getPath() {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *dirPath = [docDir stringByAppendingPathComponent:@"test.db"];
    return dirPath;
}

- (void)query {
    if ([db open]) {
        FMResultSet *set = [db executeQuery:@"SELECT * FROM actor"];
        FMResultSet *set1 = [db executeQuery:@"select * from category"];
        
        while ([set next]) {
            NSString *firstName = [set stringForColumn:@"first_name"];
            NSLog(@"%@",firstName);
        }
    }
}

@end
