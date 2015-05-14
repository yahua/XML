//
//  BookCityNet.m
//  YHMobileReader
//
//  Created by 王时温 on 14-12-11.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import "BookCityNet.h"
#import "BookNetManager.h"
#import "YHFtpLogic.h"

@implementation BookCityNet

+ (YHFtpRequestOperation *)getBookTopWithSuccess:(void(^)(NSArray *array))sucessBlock
                                         failuer:(void(^)(NSString *msg))failBlock {
    
    NSString *urlString = @"book/";
    YHFtpRequestOperation *operation = [[BookNetManager sharedInstance] get:urlString success:^(id data) {
        if (sucessBlock) {
            NSArray *array = [YHFtpLogic parserFileModelWithData:data];
            sucessBlock(array);
        }
    } failuer:^(NSError *msg) {
        if (failBlock) {
            failBlock(@"网络获取失败");
        }
    }];
    
    return operation;
}

+ (YHFtpRequestOperation *)getBookImgInfoWithSuccess:(void(^)(NSData *data))sucessBlock
                                             failuer:(void(^)(NSString *msg))failBlock {
    
    NSString *urlString = @"booksInfo/imgInfo.xml";
    YHFtpRequestOperation *operation = [[BookNetManager sharedInstance] get:urlString success:^(id data) {
        if (sucessBlock) {
            sucessBlock(data);
        }
    } failuer:^(NSError *msg) {
        if (failBlock) {
            failBlock(@"网络获取失败");
        }
    }];
    
    return operation;
}

+ (YHFtpRequestOperation *)postBookTopInfo:(NSData *)data
                                   Success:(void(^)(NSArray *array))sucessBlock
                                   failuer:(void(^)(NSString *msg))failBlock {
    NSString *urlString = @"booksInfo";
    YHFtpRequestOperation *operation = [[BookNetManager sharedInstance] post:urlString data:data success:^(id data) {
        
        NSLog(@"1111");
    } failuer:^(NSError *msg) {
        NSLog(@"111");
    }];
    
    return operation;
    
}

+ (NSString *)getImageUrl:(NSString *)imageName {
    
    NSString *urlString = [NSString stringWithFormat:@"img/%@.png", imageName];
    urlString = [NSString stringWithFormat:@"%@%@", kFtpBaseUrl, urlString];
    return urlString;
}

@end
