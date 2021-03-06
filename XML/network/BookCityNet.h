//
//  BookCityNet.h
//  YHMobileReader
//
//  Created by 王时温 on 14-12-11.
//  Copyright (c) 2014年 压花. All rights reserved.
//

#import "YHFtpRequestOperation.h"

@interface BookCityNet : NSObject

+ (YHFtpRequestOperation *)getBookTopWithSuccess:(void(^)(NSArray *array))sucessBlock
                                         failuer:(void(^)(NSString *msg))failBlock;

+ (YHFtpRequestOperation *)getBookImgInfoWithSuccess:(void(^)(NSData *data))sucessBlock
                                             failuer:(void(^)(NSString *msg))failBlock;


+ (YHFtpRequestOperation *)postBookTopInfo:(NSData *)data
                                   Success:(void(^)(NSArray *array))sucessBlock
                                   failuer:(void(^)(NSString *msg))failBlock;

+ (NSString *)getImageUrl:(NSString *)imageName;


@end
