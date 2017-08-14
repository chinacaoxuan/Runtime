//
//  TableViewCell.h
//  RuntimeDemo
//
//  Created by Demon on 2017/8/14.
//  Copyright © 2017年 lisong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *actor_id;
@property (weak, nonatomic) IBOutlet UILabel *first_name;
@property (weak, nonatomic) IBOutlet UILabel *last_name;
@property (weak, nonatomic) IBOutlet UILabel *last_update;

@end
