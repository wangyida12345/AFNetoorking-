//
//  BCEBasePost.m
//  BCE
//
//  Created by malong on 14-7-6.
//  Copyright (c) 2014年 sanxian. All rights reserved.
//

#import "AFNRequestManager.h"

#import "AppDelegate.h"

#import "AFSessionManagerClient.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFSessionManagerClient.h"
#import "JSONKit.h"




#define BASEURL   @"http://api.breadtrip.com/"

@implementation AFNRequestManager


- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    return self;
}

#pragma mark -- get method

+ (void)checkNetWorkStatus{
    
    /**
     *  AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     *  AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
     *  AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G
     *  AFNetworkReachabilityStatusReachableViaWiFi = 2,   // 局域网络Wifi
     */
    // 如果要检测网络状态的变化, 必须要用检测管理器的单例startMoitoring
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if(status == AFNetworkReachabilityStatusNotReachable){
            
            NSLog(@"网络连接已断开，请检查您的网络！");
            
            return ;
        }
    }];
}

+ (void)getInfoWithSubUrl:(NSString *)subUrl
               parameters:(NSDictionary *)Parameters
                    block:(void (^)(NSDictionary * resultDic, NSError *error))block{
    

    [[self class] checkNetWorkStatus];
    
    
    NSLog(@"url = %@",[NSString stringWithFormat:@"%@%@",BASEURL,subUrl]);
    NSLog(@"parameter = %@",Parameters);
    
    [[AFSessionManagerClient sharedClient] GET:[NSString stringWithFormat:@"%@%@",BASEURL,subUrl] parameters:Parameters success:^(NSURLSessionDataTask * __unused task, id JSON) {

        NSDictionary * resultDic = (NSDictionary *)JSON;
        NSLog(@"resultDic = %@",resultDic);
        
        if (block && resultDic) {
            block(resultDic,nil);
        }
        
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        
        NSLog(@"error = %@",error.description);
        if (block) {
            block(nil,error);
        }
        
    }];
    
}


+ (NSURLSessionDataTask *)globalTimelinePostsWithBlock:(void (^)(NSArray *posts, NSError *error))block {
    
    [[self class] checkNetWorkStatus];

    return [[AFSessionManagerClient sharedClient] GET:@"stream/0/posts/stream/global" parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSLog(@"json = %@",JSON);
        
        if (block) {
            block(JSON,nil);
        }
        
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }

    }];
}

#pragma mark -- post method

+ (void)postWithParameters:(NSDictionary *)Parameters
                    subUrl:(NSString *)suburl
                     block:(void (^)(NSDictionary *resultDic, NSError *error))block{
    
    [[self class] checkNetWorkStatus];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain", nil];

    
 

    NSLog(@"urlstring = %@",[NSString stringWithFormat:@"%@%@",BASEURL,suburl]);
    NSLog(@"parameter = %@",Parameters);
    

    [manager POST:[NSString stringWithFormat:@"%@%@",BASEURL,suburl] parameters:Parameters
          success:^(AFHTTPRequestOperation *operation,id responseObject) {
              
              NSDictionary * resultDic = [[[NSString alloc]initWithData:operation.responseData encoding:NSUTF8StringEncoding] objectFromJSONString];
              
              NSLog(@"resultDic = %@",resultDic);
              
              if (block && resultDic) {
                  
                  if (block && resultDic) {
                      block(resultDic,nil);
                  }
              }
              

    }failure:^(AFHTTPRequestOperation *operation,NSError *error) {
              NSLog(@"error = %@",error.description);
              if (block) {
                  block(nil,error);
              }
    }];

}

+ (void)postWithParameters:(NSDictionary *)Parameters
                    subUrl:(NSString *)suburl
                imageDatas:(NSArray *)imageDatas
                     names:(NSArray *)names
                     video:(NSData *)video
                     block:(void (^)(NSDictionary *resultDic, NSError *error))block{
    
    [[self class] checkNetWorkStatus];

    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain", nil];

    NSLog(@"Parameters = %@",Parameters);
    [manager POST:[NSString stringWithFormat:@"%@%@",BASEURL,suburl]
       parameters:Parameters
constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    
    for (int i = 0; i<imageDatas.count; i++) {
        [formData appendPartWithFileData:[imageDatas objectAtIndex:i]
                                    name:[names objectAtIndex:i]
                                fileName:[NSString stringWithFormat:@"%@.jpg",[names objectAtIndex:i]]
                                mimeType:@"image/jpeg"];
        
    }
    
 
    if (video) {
        [formData appendPartWithFileData:video
                                    name:@"video"
                                fileName:[NSString stringWithFormat:@"%@.mp4",@"video"]
                                mimeType:@"video/mp4"];
    }
    
    
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * resultDic = [[[NSString alloc]initWithData:operation.responseData encoding:NSUTF8StringEncoding] objectFromJSONString];
        
        NSLog(@"operation.request.URL = %@\nresultDic = %@",operation.request.URL,resultDic);
        
        if (block && resultDic) {
            block(resultDic,nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
        NSLog(@"error = %@",error.description);
        if (block) {
            block(nil,error);
        }
        
    }];


}
+ (void)getInfoWithSubUrl:(NSString*)subUrl
                    block:(void (^)(NSDictionary * resultDic, NSError *error))block{
    
    [[self class]checkNetWorkStatus];
    
    NSURLRequest * request = [[NSURLRequest alloc]initWithURL:
                              [NSURL URLWithString:
                               [NSString stringWithFormat:@"%@%@",BASEURL,subUrl]]];
    
    NSLog(@"response.url = %@",[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASEURL,subUrl]]);
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         NSLog(@"data = %@",data);
//         NSLog(@"response.string = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);

        NSLog(@"response.string = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        NSDictionary * resultDic = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] objectFromJSONString];
        
        if (block && resultDic) {
            block(resultDic,nil);
        }
         
    }];
    
}

#pragma mark 取消网络请求

+ (void)cancelRequest{
    
    NSLog(@"cancelRequest");
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.operationQueue cancelAllOperations];
    
}


@end
