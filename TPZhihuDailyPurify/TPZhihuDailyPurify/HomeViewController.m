//
//  HomeViewController.m
//  TPZhihuDailyPurify
//
//  Created by 蓝山工作室 on 16/8/15.
//  Copyright © 2016年 蓝山工作室. All rights reserved.
//

#import "HomeViewController.h"
#import "PageViewController.h"
#import "Header.h"
#import "NewsInfo.h"
#import "NetHelper.h"
#import "NewsTableViewCell.h"
#import "DetailNewsViewController.h"

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSMutableArray *latestNews;
@property (nonatomic,strong)UITableView *tableView;

@end
static NSString * const cellID = @"cellID";
@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.frame = CGRectMake(0, 200, kScreenWidth, kScreenHeith - 200);
    PageViewController *pagevc = [[PageViewController alloc]init];

    [self addChildViewController:pagevc];
    [self.view addSubview:pagevc.view];
    self.latestNews = [NSMutableArray array];
    [self getNews];
    
}




-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NewsTableViewCell *cell = [[NewsTableViewCell alloc]init];

    NewsInfo *news = [[NewsInfo alloc]init];
    news = _latestNews[indexPath.row];

    cell.title.text = news.title;
    cell.image.image = news.image;
    return cell;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _latestNews.count;
}


-(void)getNews
{
    
    [NetHelper getRequrstWithURL:@"news/latest" parameters:nil success:^(id responseObject) {
        
        
        NSArray *stories = responseObject[@"stories"];
        for (NSDictionary *dic in stories) {
            NewsInfo *news = [[NewsInfo alloc]init];
            
            news.date = responseObject[@"date"];
            
            NSArray *images = dic[@"images"];
            NSString *imageStr = images[0];
            
            NSURL *url = [[NSURL alloc]initWithString:imageStr];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *image = [UIImage imageWithData:data];
            
            NSString *newsId = dic[@"id"];
            NSString *title = dic[@"title"];
            news.image = image;
            news.newsId = newsId;
            news.title = title;
            [self.latestNews addObject:news];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{

            _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 200, kScreenWidth, kScreenHeith - 200) style:UITableViewStylePlain];
            _tableView.delegate = self;
            _tableView.dataSource = self;
            [self.view addSubview:_tableView];
        });
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NewsInfo *news = _latestNews[0];
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    backView.backgroundColor = [UIColor colorWithRed:0 green:154.0/250 blue:205.0/250 alpha:1];
    UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth - 90)/2, 2.5, 90, 25)];
    headLabel.text = news.date;
    headLabel.textColor = [UIColor whiteColor];
    headLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:headLabel];
    return backView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetailNewsViewController *detalVC = [[DetailNewsViewController alloc]init];
    [detalVC getRow:indexPath.row andNewsArray:_latestNews];
    detalVC.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    [self presentViewController:detalVC animated:YES completion:nil];
    
}

@end
