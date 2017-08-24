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
    Actor *a = [[Actor alloc] init];
//    objc_msgSend(a, @selector(eat));
    objc_msgSend(a, sel_registerName("eat"));

}

- (IBAction)printIvarList:(id)sender {
    NSArray *array = [Actor fetchIvarList];
    NSLog(@"%@",array);
}

- (IBAction)printObjectPropertieAndType:(id)sender {
    NSArray *array = [Actor fetchPropertyListAndType];
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
        self.dataArray = [[FMDBTool sharedInstance] selectFromSql:[NSString stringWithFormat:@"SELECT * FROM %@ ac WHERE ac.first_name LIKE '%%B%%'",FMDBDic[NSStringFromClass([Actor class])]] withModel:NSStringFromClass([Actor class])];
        dispatch_async(dispatch_get_main_queue(), ^{
            for (Actor *actor in self.dataArray) {
                NSMutableString *string = [[NSMutableString alloc] init];
                for (IvarModel *ivarModel in [Actor fetchPropertyListAndType]) {
                        [string appendFormat:@"%@\t",[actor valueForKey:ivarModel.ivarName]];
                }
                NSLog(@"%@\n",string);
            }
        });
    });
}

- (IBAction)showRuntime:(id)sender {
    
    //创建继承自NSObject类的People类
    Class People = objc_allocateClassPair([NSObject class], "People", 0);
//    objc_disposeClassPair(People);
    //将People类注册到runtime中
    objc_registerClassPair(People);
    //注册test: 方法选择器
    SEL sel = sel_registerName("test:");
    //函数实现
    IMP imp = imp_implementationWithBlock(^(id this,id args,...){
        NSLog(@"方法的调用者为 %@",this);
        NSLog(@"参数为 %@",args);
        return @"返回值测试";
    });
    
    //向People类中添加 test:方法;函数签名为@@:@,
    //    第一个@表示返回值类型为id,
    //    第二个@表示的是函数的调用者类型,
    //    第三个:表示 SEL
    //    第四个@表示需要一个id类型的参数
    class_addMethod(People, sel, imp, "@@:@");
    //替换People从NSObject类中继承而来的description方法
    class_replaceMethod(People,
                        @selector(description),
                        imp_implementationWithBlock(^NSString*(id this,...){
        return @"我是Person类的对象";}),
                        "@@:");
    //完成 [[People alloc]init];
    id p1 = objc_msgSend(objc_msgSend(People, @selector(alloc)),@selector(init));
    //调用p1的sel选择器的方法,并传递@"???"作为参数
    id result = objc_msgSend(p1, sel,@"???");
    //输出sel方法的返回值
    NSLog(@"sel 方法的返回值为 ： %@",result);
    
    //获取People类中实现的方法列表
    NSLog(@"输出People类中实现的方法列表");
    unsigned int methodCount;
    Method * methods = class_copyMethodList(People, &methodCount);
    for (int i = 0; i<methodCount; i++) {
        NSLog(@"方法名称:%s",sel_getName(method_getName(methods[i])));
        NSLog(@"方法Types:%s",method_getDescription(methods[i])->types);
    }
    free(methods);
}

@end
