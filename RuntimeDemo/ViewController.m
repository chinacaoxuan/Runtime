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
#import "TableViewCell.h"

@interface ViewController ()<UITabBarDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [UIImage imageNamed:@"caoxa"];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:nil options:nil][0];
    }
    Actor *actor = self.dataArray[indexPath.row];
    cell.actor_id.text = [NSString stringWithFormat:@"%d",actor.actor_id];
    cell.first_name.text = actor.first_name;
    cell.last_name.text = actor.last_name;
    cell.last_update.text = [self formatter:actor.last_update];
    return cell;
}

- (NSString *)formatter:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-mm-dd HH:mm:ss"];
    NSString *currentDateString = [formatter stringFromDate:date];
    return currentDateString;
}

- (IBAction)actionBtnClick:(id)sender {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        self.dataArray = [[FMDBTool sharedInstance] selectFormModel:NSStringFromClass(Actor.class)];
        self.dataArray = [[FMDBTool sharedInstance] selectFromSql:[NSString stringWithFormat:@"SELECT * FROM %@ ac WHERE ac.first_name LIKE '%%A%%'",FMDBDic[NSStringFromClass(Actor.class)]] withModel:NSStringFromClass(Actor.class)];
        dispatch_async(dispatch_get_main_queue(), ^{
             [self.tableView reloadData];
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
