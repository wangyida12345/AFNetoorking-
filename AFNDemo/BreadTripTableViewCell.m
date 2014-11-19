//
//  BreadTripTableViewCell.m
//  AFNDemo
//  小武
//  Created by malong on 14/11/15.
//  Copyright (c) 2014年 malong. All rights reserved.
//

#import "BreadTripTableViewCell.h"
#import "UIKit+AFNetworking.h"
#import "AFNRequestManager.h"


@implementation BreadTripTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.iconButton.layer.cornerRadius = 10.0;
    self.iconButton.clipsToBounds = YES;
    self.iconButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.iconButton.layer.borderWidth = 1.0;
    [_progressView addObserver:self forKeyPath:@"progress" options:NSKeyValueObservingOptionNew |NSKeyValueObservingOptionOld  context:0];
    [self.iconButton addTarget:self action:@selector(clicked) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)dealloc{
    [_progressView removeObserver:self forKeyPath:@"progress"];
}


- (void)clicked{
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:self.titleLabel.text message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    [alert show];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setInfoDic:(NSDictionary *)infoDic{
    _infoDic = infoDic;
    if (infoDic) {
        if ( [[[infoDic valueForKey:@"poi"] valueForKey:@"name"] isKindOfClass:[NSString class]]) {
            self.titleLabel.text = [[infoDic valueForKey:@"poi"] valueForKey:@"name"];
        }else
        {

            self.titleLabel.text = nil;
        }
        //在设置图片前先将图片清空
        [self.iconButton setImage:nil forState:UIControlStateNormal];
        self.pictureImageView.image = nil;
        
        [self.iconButton setImageForState:UIControlStateNormal
                                  withURL:[NSURL URLWithString:[(NSString *)[[infoDic valueForKey:@"user"] valueForKey:@"avatar_s"] stringByReplacingOccurrencesOfString:@"-avatar.s" withString:@""]]
                         placeholderImage:nil];
        
        [self.pictureImageView setImageWithURL:[NSURL URLWithString:[(NSString *)[infoDic valueForKey:@"photo_w640"] stringByReplacingOccurrencesOfString:@"imageView/1/w/640/h/480/q/85" withString:@""]]
                              placeholderImage:nil];
        
        [self.progressView setProgressWithDownloadProgressOfOperation:self.pictureImageView.af_imageRequestOperation animated:NO];
        
        [self setNeedsDisplay];

    }
}

//KVO监测进度条状态

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context{
    
    if (self.progressView.progress<1.0) {
        
        self.progressView.hidden = NO;
        
    }else{
        
        self.progressView.hidden = YES;
        
    }
    
}

@end
