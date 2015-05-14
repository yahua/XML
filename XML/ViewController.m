//
//  ViewController.m
//  XML
//
//  Created by 王时温 on 14-12-26.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "ViewController.h"
#import "GDataXMLNode.h"
#import "BookCityNet.h"
#import "YHFtpFileModel.h"
#import "NSDate+DateFunctions.h"
#import "FtpUploadNetWork.h"

@interface ViewController ()

@property (nonatomic, strong) FtpUploadNetWork *network;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(100, 100, 140, 50);
    [button setTitle:@"生成书籍排行榜信息" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(makeBooksInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    
//    [NSThread detachNewThreadSelector: @selector(newThreadProcess)
//                            toTarget: self
//                          withObject: nil];
}


- (void)makeBooksInfo {
    
    [BookCityNet getBookImgInfoWithSuccess:^(NSData *data) {
        
        GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithData:data error:nil];
        GDataXMLElement *xmlEle = [xmlDoc rootElement];
        NSArray *childArray = [xmlEle children];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        for (GDataXMLElement *element in childArray) {
            NSArray *bookPropertyArray = [element children];
            GDataXMLElement *bookelement = [bookPropertyArray firstObject];
            GDataXMLElement *bookImgelement = [bookPropertyArray lastObject];
            [dic setObject:[bookImgelement stringValue] forKey:[bookelement stringValue]];
        }
        
        [BookCityNet getBookTopWithSuccess:^(NSArray *array) {
            
            // 创建一个根标签
            GDataXMLElement *rootElement = [GDataXMLNode elementWithName:@"booktop"];
            for (YHFtpFileModel *model in array) {
                GDataXMLElement *bookElement = [GDataXMLNode elementWithName:@"book"];
                GDataXMLElement *nameElement = [GDataXMLNode elementWithName:@"bookName" stringValue:model.fileName];
                GDataXMLElement *imgNameElement = [GDataXMLNode elementWithName:@"bookImgName" stringValue:[dic objectForKey:model.fileName]];
                GDataXMLElement *urlElement = [GDataXMLNode elementWithName:@"bookUrl" stringValue:[NSString stringWithFormat:@"book/%@.txt", model.fileName]];
                GDataXMLElement *sizeElement = [GDataXMLNode elementWithName:@"bookSize" stringValue:model.fileSizeStr];
                GDataXMLElement *dateElement = [GDataXMLNode elementWithName:@"bookDate" stringValue:[model.fileDate formatAsISODate]];
                
                [bookElement addChild:nameElement];
                [bookElement addChild:imgNameElement];
                [bookElement addChild:urlElement];
                [bookElement addChild:sizeElement];
                [bookElement addChild:dateElement];
                
                [rootElement addChild:bookElement];
            }
            // 生成xml文件内容
            GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithRootElement:rootElement];
            NSData *data = [xmlDoc XMLData];
            NSString *xmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@", xmlString);
            
            self.network = [[FtpUploadNetWork alloc] init];
            //[self.network send:data];
            [BookCityNet postBookTopInfo:data Success:^(NSArray *array) {
                
            } failuer:^(NSString *msg) {
                
            }];
            
        } failuer:^(NSString *msg) {
            
        }];
        
    } failuer:nil];
}

-(void)test_file{
    
    // 获取程序Documents目录路径
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    
    
    NSMutableString * path = [[NSMutableString alloc]initWithString:documentsDirectory];
    
    [path appendString:@"/fuck.txt"];
    
    NSString *temp = @"我现在要告诉我那你哈哈哈len 是不是Dang";
    
    NSInteger i = [[temp dataUsingEncoding:NSUTF8StringEncoding] length];
    
    
    
    NSMutableData * data = [[NSMutableData alloc]init];
    
    [data appendBytes:&i length:sizeof(i)];
    
    [data appendData:[temp dataUsingEncoding:NSUTF8StringEncoding]];
    

    [data writeToFile:path atomically:YES];
    
    

    NSInteger fuck = 0;
    
    NSString * fff ;
    
    NSData * reader = [NSData dataWithContentsOfFile:path];
    
    [reader getBytes:&fuck length:sizeof(fuck)];
    
    
    
    fff = [[NSString alloc] initWithData:[reader subdataWithRange:NSMakeRange(sizeof(fuck) , fuck)]
           
                                encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@" , fff);
    
}


- (void)newThreadProcess

{
    @autoreleasepool {
        
        ////获得当前thread的Runloop
        
        NSRunLoop* myRunLoop = [NSRunLoop currentRunLoop];
        
        
        
        //设置Run loop observer的运行环境
        
        CFRunLoopObserverContext context = {0,(__bridge void *)(self),NULL,NULL,NULL};
        
        //创建Run loop observer对象
        
        //第一个参数用于分配observer对象的内存
        
        //第二个参数用以设置observer所要关注的事件，详见回调函数myRunLoopObserver中注释
        
        //第三个参数用于标识该observer是在第一次进入runloop时执行还是每次进入run loop处理时均执行
        
        //第四个参数用于设置该observer的优先级
        
        //第五个参数用于设置该observer的回调函数
        
        //第六个参数用于设置该observer的运行环境
        
        CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault,kCFRunLoopAllActivities, YES, 0, nil, &context);
        
        if(observer)
            
        {
            //将Cocoa的NSRunLoop类型转换成CoreFoundation的CFRunLoopRef类型
            
            CFRunLoopRef cfRunLoop = [myRunLoop getCFRunLoop];

            //将新建的observer加入到当前thread的runloop
            
            CFRunLoopAddObserver(cfRunLoop, observer, kCFRunLoopDefaultMode);
            
        }

        //
        
        [NSTimer scheduledTimerWithTimeInterval: 0.025
                                        target: self
                                      selector:@selector(timerProcess)
                                      userInfo: nil
                                       repeats: YES];
        

        do{
            
            //启动当前thread的loop直到所指定的时间到达，在loop运行时，runloop会处理所有来自与该run loop联系的inputsource的数据
            
            //对于本例与当前run loop联系的inputsource只有一个Timer类型的source。
            
            //该Timer每隔1秒发送触发事件给runloop，run loop检测到该事件时会调用相应的处理方法。
            
            
            
            //由于在run loop添加了observer且设置observer对所有的runloop行为都感兴趣。
            
            //当调用runUnitDate方法时，observer检测到runloop启动并进入循环，observer会调用其回调函数，第二个参数所传递的行为是kCFRunLoopEntry。
            
            //observer检测到runloop的其它行为并调用回调函数的操作与上面的描述相类似。 
            
            [myRunLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:5.0]];
            
            //当run loop的运行时间到达时，会退出当前的runloop。observer同样会检测到runloop的退出行为并调用其回调函数，第二个参数所传递的行为是kCFRunLoopExit。
            
            //loopCount--;
            
        }while (1);
        
    }
}




- (void)timerProcess{

    NSLog(@"In timerProcess count .");
}

@end
