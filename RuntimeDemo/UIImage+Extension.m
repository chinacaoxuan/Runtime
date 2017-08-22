//
//  UIImage+Extension.m
//  RuntimeDemo
//
//  Created by Demon on 2017/8/21.
//  Copyright © 2017年 Demon. All rights reserved.
//

#import "UIImage+Extension.h"

#import "NSObject+Runtime.h"

@implementation UIImage (Extension)

+ (void)load {
    [UIImage swapClassMethod:@selector(imageNamed:) currentMethod:@selector(cx_imageName:)];
}

+ (instancetype)cx_imageName:(NSString *)imageName {
    UIImage *image = [self cx_imageName:imageName];
    if (!image) {
        NSLog(@"我要加载背景图片咯");
    }
    
    return image;
}

@end
