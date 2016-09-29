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
#import "PageViewController.h"
@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSMutableArray *latestNews;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIView *headView;
@property (nonatomic,strong)PageViewController *pagevc;
//@property (nonatomic,strong)UserInfo *userInfoManager;
@property (nonatomic,strong) UIActivityIndicatorView *activity;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _activity = [[UIActivityIndicatorView alloc]initWithFrame:CGRectZero];
    _activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    _activity.center = CGPointMake(kScreenWidth/2, kScreenHeith/2);
    [_activity startAnimating];
    [self.view addSubview:_activity];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.frame = CGRectMake(0, kPageViewHeight, kScreenWidth, kScreenHeith - kPageViewHeight);
    _pagevc = [[PageViewController alloc]init];
    [self addChildViewController:_pagevc];
    [self.view addSubview:_pagevc.view];
    self.latestNews = [NSMutableArray array];
    [self getNews];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeTheme:) name:@"change" object:nil];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


-(void)changeTheme:(NSNotification *)sender
{
    if ([UserInfo defaltInfoManager].timeStates == nightTime) {
        _tableView.backgroundColor = [UIColor colorWithRed:54.0/250 green:54.0/250 blue:54.0/250 alpha:1];
        NSArray *cells = [self.tableView visibleCells];
        for (NewsTableViewCell *cell in cells) {
            cell.title.textColor = [UIColor whiteColor];
        }
        _headView.backgroundColor = [UIColor colorWithRed:105.0/250 green:105.0/250 blue:105.0/250 alpha:1];
        
    }else{
        _tableView.backgroundColor = [UIColor whiteColor];
        NSArray *cells = [self.tableView visibleCells];
        for (NewsTableViewCell *cell in cells) {
            cell.title.textColor = [UIColor blackColor];
        }
        _headView.backgroundColor = [UIColor colorWithRed:0 green:154.0/250 blue:205.0/250 alpha:1];
    }

}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[NewsTableViewCell alloc]init];
    }
    NewsInfo *news = [[NewsInfo alloc]init];
    news = _latestNews[indexPath.row];
    cell.title.text = news.title;
    cell.image.image = news.image;
    if ([UserInfo defaltInfoManager].timeStates == nightTime) {
        cell.title.textColor = [UIColor whiteColor];
    }else{
        cell.title.textColor = [UIColor blackColor];
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _latestNews.count;
}


-(void)getNews
{
        [NetHelper getRequrstWithURL:@"news/latest" parameters:nil success:^(id responseObject) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                NSLog(@"%@",[NSThread currentThread]);
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
                    NSLog(@"%@",news.title);
                    [self.latestNews addObject:news];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kPageViewHeight, kScreenWidth, kScreenHeith - kPageViewHeight) style:UITableViewStylePlain];
                    _tableView.delegate = self;
                    _tableView.dataSource = self;
                    
                    if ([UserInfo defaltInfoManager].timeStates == nightTime) {
                        _tableView.backgroundColor = [UIColor colorWithRed:54.0/250 green:54.0/250 blue:54.0/250 alpha:1];
                        
                    }else{
                        _tableView.backgroundColor = [UIColor whiteColor];
                    }
                    [self.view addSubview:_tableView];
                });
                
            });
            
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            [self.activity stopAnimating];
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
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    //backView.backgroundColor = [UIColor clearColor];
    _headView.backgroundColor = [UIColor colorWithRed:0 green:154.0/250 blue:205.0/250 alpha:1];
    UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 25)];
    headLabel.center = CGPointMake(kScreenWidth/2, 15);
    NSString *year = [news.date substringToIndex:4];
    NSString *month = [news.date substringWithRange:NSMakeRange(4, 2)];
    NSString *day = [news.date substringFromIndex:6];
    NSString *date = [NSString stringWithFormat:@"%@年%@月%@日",year,month,day];
    headLabel.text = date;
    headLabel.textColor = [UIColor whiteColor];
    headLabel.textAlignment = NSTextAlignmentCenter;
    [_headView addSubview:headLabel];
    if ([UserInfo defaltInfoManager].timeStates == nightTime) {
        _headView.backgroundColor = [UIColor colorWithRed:105.0/250 green:105.0/250 blue:105.0/250 alpha:1];
        
    }else{
        _headView.backgroundColor = [UIColor colorWithRed:0 green:154.0/250 blue:205.0/250 alpha:1];
    }
    return _headView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetailNewsViewController *detalVC = [[DetailNewsViewController alloc]init];
    [detalVC getRow:indexPath.row andNewsArray:_latestNews];
    detalVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:detalVC animated:YES completion:nil];
    
}


@end
