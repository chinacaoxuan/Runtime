//
//  AppDelegate.m
//  RuntimeDemo
//
//  Created by Demon on 2017/8/9.
//  Copyright © 2017年 lisong. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[ViewController alloc] init];
    [self.window makeKeyAndVisible];
    [self configDataBase];
    return YES;
}

- (void)configDataBase {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Sakila" ofType:@"sqlite3"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *dirPath = [docDir stringByAppendingPathComponent:@"test.db"];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:dirPath]) {
        NSError *error;
        [fm copyItemAtPath:path toPath:dirPath error:&error];
        if (error) {
            NSLog(@"save fail");
        } else {
            NSLog(@"save success");
        }
    } else {
        NSLog(@"has saved database");
    }
}

@end
