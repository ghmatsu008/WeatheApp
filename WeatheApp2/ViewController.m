//
//  ViewController.m
//  WeatheApp2
//
//  Created by 松尾 慎治 on 2016/04/01.
//  Copyright © 2016年 sample. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "FMDatabase.h"

@interface ViewController ()
@property NSDictionary *data;
@property NSString *da;
@property NSString *img;
@property NSArray *dataValues;
@property NSString *date;
@property NSString *tk;
@property NSString *iconURL;
@property NSDictionary *area;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    int today = 0;
    int tomorrow = 1;
    int dayAfterTomorrow = 2;
    
    //アクセス
    NSString *URL = @"http://weather.livedoor.com/forecast/webservice/json/v1?";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    DbController *dc = [[DbController alloc]init];
    //    DbController *dc2 = [[DbController alloc]init];
    NSDictionary *area = @{@"city": @"130010"};
    NSArray  *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dir = [paths objectAtIndex:0];
    NSString *db_path  = [dir stringByAppendingPathComponent:@"/Weather.db"];
    //    NSLog(@"%@", db_path );
    
    FMDatabase *db = [FMDatabase databaseWithPath:db_path];
    // テーブルを作成
    NSString *sql = @"CREATE TABLE IF NOT EXISTS weather2(id INTEGER PRIMARY KEY AUTOINCREMENT,date TEXT,tenki TEXT,icon TEXT);";
    [db open];
    // SQLを実行
    
    [db executeUpdate:sql];
    
    [manager GET:URL parameters:area success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
        NSLog(@"ーーーJSON 取得ーーー");
        
        self.data = responseObject;
        //                    self.titel.text = [self.data valueForKeyPath:@"title"];
        //日付を取得
        NSArray *dates = [self.data valueForKeyPath:@"forecasts.date"];
        self.datela.text = [dates objectAtIndex:tomorrow];
        //天気を取得
        NSArray *telops = [self.data valueForKeyPath:@"forecasts.telop"];
        //                    self.datel.text = [telops objectAtIndex:1];
        
        NSArray *imageNames = [self.data valueForKeyPath:@"forecasts.image.url"];
        //                     self.img = [imageNames objectAtIndex:0];
        NSURL *imageURL = [NSURL URLWithString:[imageNames objectAtIndex:tomorrow]];
        //             NSData *dat = [NSData dataWithContentsOfURL:imageURL];
        //                    self.image.image = [UIImage imageWithData:dat];
        
        self.text.text = [self.data valueForKeyPath:@"description.text"];
        //        NSLog(@"%@",[self.data valueForKeyPath:@"description.text"]);
        
        NSArray *dataValues = @[[self.data valueForKeyPath:@"title"]
                                ,[telops objectAtIndex:tomorrow]
                                ,imageURL];
        
        //DBにデータをInsert
            [dc insertTable:dataValues];
            //DBからデータを取得
        [db close];
    }
         failure:^(NSURLSessionDataTask *task, NSError *error) {
             UIAlertController *actionSheet = [UIAlertController
                                               alertControllerWithTitle:@"オフラインです。"
                                               message:@"インターネットに接続してください。"
                                               preferredStyle:UIAlertControllerStyleActionSheet];
             UIAlertAction *cancel = [UIAlertAction
                                      actionWithTitle:@"OK"
                                      style:UIAlertActionStyleCancel
                                      handler:^(UIAlertAction *action){
                                      }];
             
             
             NSLog(@"ーーー失敗ーーー");
             NSLog(@"error---%@",error);
             [actionSheet addAction:cancel];
             [self presentViewController:actionSheet animated:YES completion:nil];
         }];
    
    //通信が終わるまで待機
    //    int count = 0;
    //    while (!Finish) {
    //        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
    //        count ++;
    //        NSLog(@"%d",count);
    //    }
    
    //    テーブルからデータ取得
    //    self.dataValues = [dc2 selectTable];
    NSArray *values = [dc selectTable];
    int cnt = (int)[values count];
//    NSLog(@"cnt===%d",cnt);
    
    DbController *va = values[cnt-1];
    
    //    NSLog(@"---　%@ ---",[NSString stringWithFormat:@"%@",va.ydate ]);
    //    self.titel.text = [self.data valueForKeyPath:@"title"]; //場所
    self.titel.text = va.ydate;
    self.datel.text = va.tenki; //天気
    NSURL *url = [NSURL URLWithString:va.iconURL];  //icon
    NSData *da = [NSData dataWithContentsOfURL:url];
    self.image.image = [UIImage imageWithData:da];
    
    //    self.text.text = [self.data valueForKeyPath:@"description.text"]; //概要
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
