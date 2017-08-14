//
//  Actor.h
//  RuntimeDemo
//
//  Created by 曹旋 on 17/8/13.
//  Copyright © 2017年 lisong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Actor : NSObject

@property(assign, nonatomic) int actor_id;

/** !<#(NSString *)#>*/
@property(copy, nonatomic) NSString *first_name;
/** !*/
@property(copy, nonatomic) NSString *last_name;
/** !<#(NSString *)#>*/
@property(strong, nonatomic) NSDate *last_update;
@end