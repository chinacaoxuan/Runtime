//
//  ViewController.m
//  RuntimeDemo
//
//  Created by Demon on 2017/8/9.
//  Copyright © 2017年 lisong. All rights reserved.
//

#import "ViewController.h"
#import "FMDBTool.h"
#import "Actor.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSMutableArray *array = [[FMDBTool sharedInstance] selectFormModel:@"Actor"];
    for (Actor *actor in array) {
        NSLog(@"%@",actor.first_name);
    }
}



@end
