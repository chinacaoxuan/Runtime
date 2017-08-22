//
//  ViewController.m
//  RuntimeDemo
//
//  Created by Demon on 2017/8/9.
//  Copyright © 2017年 Demon. All rights reserved.
//

#import "ViewController.h"

#import "FMDBTool.h"
#import "Actor.h"

#import "NSObject+Runtime.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Actor *a = objc_msgSend(objc_getClass("Actor"), sel_registerName("alloc"));
    a = objc_msgSend(a, sel_registerName("init"));
    objc_msgSend(a, sel_registerName("eat"));
}
- (IBAction)printObjectPropertieAndType:(id)sender {
    NSArray *array = [Actor fetchIvarList];
    for (IvarModel *ivarModel in array) {
        NSLog(@"%@---%@",ivarModel.ivarName,ivarModel.type);
    }
}

- (IBAction)exchangeSystemMethod:(id)sender {
    [UIImage imageNamed:@"caoxa"];
}
- (IBAction)printMethod:(id)sender {
    NSArray *methodArray = [UIViewController fetchInstanceMethodList];
    NSArray *classMthodArray = [UIViewController fetchClassMethodList];
    
    NSLog(@"%@\n-----------\n%@",methodArray,classMthodArray);
}

- (IBAction)actionBtnClick:(id)sender {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        self.dataArray = [[FMDBTool sharedInstance] selectFormModel:NSStringFromClass(Actor.class)];
        self.dataArray = [[FMDBTool sharedInstance] selectFromSql:[NSString stringWithFormat:@"SELECT * FROM %@ ac WHERE ac.first_name LIKE '%%A%%'",FMDBDic[NSStringFromClass(Actor.class)]] withModel:NSStringFromClass(Actor.class)];
        dispatch_async(dispatch_get_main_queue(), ^{
            for (Actor *actor in self.dataArray) {
                NSMutableString *string = [[NSMutableString alloc] init];
                for (IvarModel *ivarModel in [Actor fetchIvarList]) {
                        [string appendFormat:@"%@\t",[actor valueForKey:ivarModel.ivarName]];
                }
                NSLog(@"%@\n",string);
            }
        });
    });
}

@end
