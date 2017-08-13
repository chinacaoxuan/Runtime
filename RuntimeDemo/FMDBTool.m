//
//  FMDBTool.m
//  RuntimeDemo
//
//  Created by 曹旋 on 17/8/13.
//  Copyright © 2017年 lisong. All rights reserved.
//

#import "FMDBTool.h"
#import <FMDB.h>
#import "NSObject+Runtime.h"
#import "FMDBConfig.h"

static FMDBTool *tool;
static FMDatabase *db;
@implementation FMDBTool

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[self alloc] init];
    });
    return tool;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        db = [[FMDatabase alloc] initWithPath:getDBPath()];
    }
    return self;
}

- (NSMutableArray *)selectFormModel:(NSString *)model {
    if (![db open]) {
        return nil;
    }
    NSArray *ivarList = [NSClassFromString(model) fetchIvarList];
    NSMutableArray *result = [NSMutableArray array];
    NSString *sql = [NSString stringWithFormat:@"select * from %@",FMDBDic[model]];
    NSLog(@"%@",sql);
    FMResultSet *s = [db executeQuery:sql];
    while ([s next]) {
         id object = [[NSClassFromString(model) alloc] init];
        for (IvarModel *ivarModel in ivarList) {
            if ([ivarModel.type isEqualToString:NSStringFromClass([NSString class])]) {
                NSString *str = [s stringForColumn:ivarModel.ivarName];
                [object setValue:str forKey:ivarModel.ivarName];
            } else if ([ivarModel.type isEqualToString:NSStringFromClass([NSDate class])]) {
                NSDate *date = [s dateForColumn:ivarModel.ivarName];
                [object setValue:date forKey:ivarModel.ivarName];
            } else if ([ivarModel.type isEqualToString:@"i"] || [ivarModel.type isEqualToString:@"NSInteger"]) {
                NSInteger intValue = [s intForColumn:ivarModel.ivarName] ? : 0;
                [object setValue:@(intValue) forKey:ivarModel.ivarName];
            } else if ([ivarModel.type isEqualToString:@"long"]) {
                long longValue = [s longForColumn:ivarModel.ivarName];
                [object setValue:@(longValue) forKey:ivarModel.ivarName];
            } else if ([ivarModel.type isEqualToString:@"longlong"]) {
                long long longlongValue = [s longLongIntForColumn:ivarModel.ivarName];
                [object setValue:@(longlongValue) forKey:ivarModel.ivarName];
            } else if ([ivarModel.type isEqualToString:@"BOOL"]) {
                BOOL boolValue = [s boolForColumn:ivarModel.ivarName];
                [object setValue:@(boolValue) forKey:ivarModel.ivarName];
            }
            
        }
        [result addObject:object];
    }
    return result;
}

void configDataBase() {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Sakila" ofType:@"sqlite3"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:getDBPath()]) {
        NSError *error;
        [fm copyItemAtPath:path toPath:getDBPath() error:&error];
        if (error) {
            NSLog(@"save fail");
        } else {
            NSLog(@"save success");
        }
    } else {
        NSLog(@"has saved database");
    }
}

NSString *getDBPath() {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *dirPath = [docDir stringByAppendingPathComponent:@"test.db"];
    return dirPath;
}



@end
