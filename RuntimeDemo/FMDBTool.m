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
#import "MJExtensionConst.h"

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

- (instancetype)init {
    self = [super init];
    if (self) {
        db = [[FMDatabase alloc] initWithPath:getDBPath()];
    }
    return self;
}

- (NSMutableArray *)selectFormModel:(NSString *)className {
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@",FMDBDic[className]];
    NSMutableArray *result = [self selectFromSql:sql withModel:className];
    return result;
}

- (NSMutableArray *)selectFromSql:(NSString *)sql withModel:(NSString *)className {
    if (![db open]) {
        NSLog(@"database is not open");
        return nil;
    }
    NSLog(@"%@",sql);
    
    FMResultSet *s = [db executeQuery:sql];
    NSMutableArray *result = [self excuteSql:s className:className];
    [db close];
    
    return result;
}

- (NSMutableArray *)excuteSql:(FMResultSet *)s className:(NSString *)className {
    NSMutableArray *result = [NSMutableArray array];
    NSArray *ivarList = [NSClassFromString(className) fetchIvarList];
    
    while ([s next]) {
        id object = [[NSClassFromString(className) alloc] init];
        for (IvarModel *ivarModel in ivarList) {
            if ([s columnIsNull:ivarModel.ivarName]) break;
            
            if ([ivarModel.type isEqualToString:NSStringFromClass([NSString class])]) {
                NSString *str = [s stringForColumn:ivarModel.ivarName];
                [object setValue:str forKey:ivarModel.ivarName];
            } else if ([ivarModel.type isEqualToString:NSStringFromClass([NSDate class])]) {
                NSDate *date = [s dateForColumn:ivarModel.ivarName];
                [object setValue:date forKey:ivarModel.ivarName];
            } else if ([ivarModel.type isEqualToString:MJPropertyTypeInt]) {
                NSInteger intValue = [s intForColumn:ivarModel.ivarName] ? : 0;
                [object setValue:@(intValue) forKey:ivarModel.ivarName];
            } else if ([ivarModel.type isEqualToString:MJPropertyTypeLong]) {
                long longValue = [s longForColumn:ivarModel.ivarName];
                [object setValue:@(longValue) forKey:ivarModel.ivarName];
            } else if ([ivarModel.type isEqualToString:MJPropertyTypeLongLong]) {
                long long longlongValue = [s longLongIntForColumn:ivarModel.ivarName];
                [object setValue:@(longlongValue) forKey:ivarModel.ivarName];
            } else if ([ivarModel.type isEqualToString:MJPropertyTypeBOOL2] || [ivarModel.type isEqualToString:MJPropertyTypeBOOL1]) {
                BOOL boolValue = [s boolForColumn:ivarModel.ivarName];
                [object setValue:@(boolValue) forKey:ivarModel.ivarName];
            } else if ([ivarModel.type isEqualToString:MJPropertyTypeFloat] || [ivarModel.type isEqualToString:MJPropertyTypeDouble]) {
                double floatVaue = [s doubleForColumn:ivarModel.ivarName];
                [object setValue:@(floatVaue) forKey:ivarModel.ivarName];
            } else {
                id value = [s objectForColumnName:ivarModel.ivarName];
                [object setValue:value forKey:ivarModel.ivarName];
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
