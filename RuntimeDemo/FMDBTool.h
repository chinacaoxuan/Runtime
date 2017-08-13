//
//  FMDBTool.h
//  RuntimeDemo
//
//  Created by 曹旋 on 17/8/13.
//  Copyright © 2017年 lisong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMDBTool : NSObject

+ (instancetype)sharedInstance;

void configDataBase();

- (NSMutableArray *)selectFormModel:(NSString *)model;

@end
