//
//  BreadTripTableViewCell.h
//  AFNDemo
//  小武
//  Created by malong on 14/11/15.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BreadTripTableViewCell : UITableViewCell

@property (nonatomic,weak)IBOutlet UIButton * iconButton;

@property (nonatomic,weak)IBOutlet UIProgressView * progressView;

@property (nonatomic,weak)IBOutlet UILabel * titleLabel;

@property (nonatomic,weak)IBOutlet UIImageView * pictureImageView;

@property (nonatomic,strong)NSDictionary * infoDic;

@end
