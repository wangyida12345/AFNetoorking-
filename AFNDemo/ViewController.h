//
//  ViewController.h
//  AFNDemo
//  小武
//  Created by malong on 14/11/14.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak,nonatomic)IBOutlet UITableView * tableView;

@end

