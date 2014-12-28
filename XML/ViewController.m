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
            [self.network send:data];
            
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

@end
