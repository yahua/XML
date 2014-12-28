//
//  FtpUploadNetWork.m
//  XML
//
//  Created by 王时温 on 14-12-27.
//  Copyright (c) 2014年 王时温. All rights reserved.
//

#import "FtpUploadNetWork.h"
#include <CFNetwork/CFNetwork.h>

@interface FtpUploadNetWork () <
NSStreamDelegate>


@property (nonatomic, assign, readonly ) BOOL              isSending;
@property (nonatomic, strong) NSOutputStream *  networkStream;
@property (nonatomic, strong) NSInputStream *   fileStream;
@property (nonatomic, assign, readonly ) uint8_t *         buffer;
@property (nonatomic, assign, readwrite) size_t            bufferOffset;
@property (nonatomic, assign, readwrite) size_t            bufferLimit;

@end

@implementation FtpUploadNetWork
{
    uint8_t                     _buffer[kSendBufferSize];
}

- (uint8_t *)buffer
{
    return self->_buffer;
}

- (void)send:(NSData *)data {

    NSURL *url;//ftp服务器地址
    NSString *filePath = @"booksInfo.xml";

    //获得输入
    url = [NSURL URLWithString:@"ftp://192.168.1.106/booksInfo"];

    //添加后缀（文件名称）
    url = CFBridgingRelease(
                            CFURLCreateCopyAppendingPathComponent(NULL, (__bridge CFURLRef) url, (__bridge CFStringRef) [filePath lastPathComponent], false)
                            );
    //读取文件，转化为输入流
    self.fileStream = [NSInputStream inputStreamWithData:data];
    [self.fileStream open];

    //为url开启CFFTPStream输出流
    self.networkStream = CFBridgingRelease(CFWriteStreamCreateWithFTPURL(NULL, (__bridge CFURLRef) url));

    
    
//    //设置ftp账号密码
//   
    [self.networkStream setProperty:@"yahua" forKey:(id)kCFStreamPropertyFTPUserName];
    [self.networkStream setProperty:@"Y123" forKey:(id)kCFStreamPropertyFTPPassword];
//
    
    
    //设置networkStream流的代理，任何关于networkStream的事件发生都会调用代理方法
    self.networkStream.delegate = self;

    //设置runloop

    [self.networkStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];

    [self.networkStream open];

}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    //aStream 即为设置为代理的networkStream

    switch (eventCode) {
            
        case NSStreamEventOpenCompleted: {
            
            NSLog(@"NSStreamEventOpenCompleted");
            
        } break;
            
        case NSStreamEventHasBytesAvailable: {
            
            NSLog(@"NSStreamEventHasBytesAvailable");
            
            assert(NO);     // 在上传的时候不会调用
            
        } break;
            
        case NSStreamEventHasSpaceAvailable: {
            
            NSLog(@"NSStreamEventHasSpaceAvailable");
            
            NSLog(@"bufferOffset is %zd",self.bufferOffset);
            
            NSLog(@"bufferLimit is %zu",self.bufferLimit);
            
            if (self.bufferOffset == self.bufferLimit) {
                
                NSInteger   bytesRead;
                
                bytesRead = [self.fileStream read:self.buffer maxLength:kSendBufferSize];
                
                if (bytesRead == -1) {
                    
                    //读取文件错误
                    
                    [self _stopSendWithStatus:@"读取文件错误"];
                    
                } else if (bytesRead == 0) {
                    
                    //文件读取完成 上传完成
                    
                    [self _stopSendWithStatus:nil];
                    
                } else {
                    
                    self.bufferOffset = 0;
                    
                    self.bufferLimit  = bytesRead;
                    
                }

            }

            if (self.bufferOffset != self.bufferLimit) {
                
                //写入数据
                
                NSInteger bytesWritten;//bytesWritten为成功写入的数据
                
                bytesWritten = [self.networkStream write:&self.buffer[self.bufferOffset]
                                
                                               maxLength:self.bufferLimit - self.bufferOffset];
                
                assert(bytesWritten != 0);
                
                if (bytesWritten == -1) {
                    
                    [self _stopSendWithStatus:@"网络写入错误"];
                    
                } else {
                    
                    self.bufferOffset += bytesWritten;
                    
                }
                
            }
            
        } break;
            
        case NSStreamEventErrorOccurred: {
            
            [self _stopSendWithStatus:@"Stream打开错误"];
            
            assert(NO); 
            
        } break;
            
        case NSStreamEventEndEncountered: {
            
            // 忽略
            
        } break;
            
        default: {
            
            assert(NO);
            
        } break;
            
    }
}


- (void)_stopSendWithStatus:(NSString *)statusString
{
    
    if (self.networkStream != nil) {
        
        [self.networkStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        
        self.networkStream.delegate = nil;
        
        [self.networkStream close];
        
        self.networkStream = nil;
    }
    
    if (self.fileStream != nil) {
        
        [self.fileStream close];
        
        self.fileStream = nil;
        
    }
    
    [self sendDidStopWithStatus:statusString];
}

- (void)sendDidStopWithStatus:(NSString *)statusString
{
    if (statusString == nil) {
        statusString = @"Put succeeded";
    }
    NSLog(@"%@", statusString);
}

@end
