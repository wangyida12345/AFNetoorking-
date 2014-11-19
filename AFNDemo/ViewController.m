//
//  ViewController.m
//  AFNDemo
//  小武
//  Created by malong on 14/11/14.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import "ViewController.h"
#import "BreadTripTableViewCell.h"

#import "AFNRequestManager.h"


@interface ViewController ()
{
    NSMutableArray * items;
}
@end

static NSString * breadTrip = @"breadTrip";


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //利用抓取面包旅行每日精选图片接口
    
    self.tableView.frame = self.view.bounds;
    
    [AFNRequestManager  getInfoWithSubUrl:@"featured/photos" parameters:@{@"start":@"0"} block:^(NSDictionary *resultDic, NSError *error) {
        if ([[resultDic valueForKey:@"items"] isKindOfClass:[NSArray class]] && [[resultDic valueForKey:@"items"] count]) {
            items = [NSMutableArray arrayWithArray:[resultDic valueForKey:@"items"]];
            NSLog(@"items.count = %ld",(unsigned long)items.count);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BreadTripTableViewCell" bundle:nil] forCellReuseIdentifier:breadTrip];
    // Do any additional setup after loading the view, typically from a nib.
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BreadTripTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:breadTrip forIndexPath:indexPath];
    cell.infoDic = items[indexPath.row];

    return cell;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 240;
}

@end
