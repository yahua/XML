//
//  FtpUploadNetWork.h
//  XML
//
//  Created by 王时温 on 14-12-27.
//  Copyright (c) 2014年 王时温. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    
    kSendBufferSize = 32768//上传的缓冲区大小，可以设置
};

@interface FtpUploadNetWork : NSObject

- (void)send:(NSData *)data;

@end
