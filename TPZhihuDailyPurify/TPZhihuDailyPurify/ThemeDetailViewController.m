//
//  ThemeDetailViewController.m
//  TPZhihuDailyPurify
//
//  Created by 蓝山工作室 on 16/8/20.
//  Copyright © 2016年 蓝山工作室. All rights reserved.
//

#import "ThemeDetailViewController.h"
#import "NewsInfo.h"
#import "NetHelper.h"
#import "Header.h"
#import "NewsTableViewCell.h"
#import "DetailNewsViewController.h"
@interface ThemeDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)NSString *themeId;
@property (nonatomic,strong)NSString *themeName;
@property (nonatomic,strong)NSString *thumbnail;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,copy)NSMutableArray *stories;

@end

@implementation ThemeDetailViewController
{
    int second1,second2;//,nowTime;
    long ms1,ms2;
    CGFloat timeInterval;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addGestureRecognizer];
    [self addToolBar];
    
    
    NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
    nowTime = [[defaults objectForKey:@"nowTime"] intValue];
    
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self showStories];
}

-(void)addTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, kScreenWidth, kScreenHeith - 50) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

-(void)showStories
{
    _stories = [NSMutableArray array];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NetHelper getRequrstWithURL:[NSString stringWithFormat:@"theme/%@",_themeId] parameters:nil success:^(id responseObject) {
            NSArray *stories = responseObject[@"stories"];
            for (NSDictionary *dic in stories) {
                NewsInfo *news = [[NewsInfo alloc]init];
                NSString *imageStr = dic[@"images"][0];
                NSURL *url = [NSURL URLWithString:imageStr];
                NSData *data = [NSData dataWithContentsOfURL:url];
                UIImage *image = [UIImage imageWithData:data];
                news.image = image;
                NSString *title = dic[@"title"];
                NSString *newsId = dic[@"id"];
                news.newsId = newsId;
                news.title = title;
                [_stories addObject:news];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self addTableView];
            });
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    });
}


-(void)addGestureRecognizer
{
    UIPanGestureRecognizer *panRcognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:panRcognizer];
}

-(void)pan:(UIPanGestureRecognizer *)gr
{
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss:SSSS"];
    if (gr.state == UIGestureRecognizerStateBegan) {
        NSString *time = [formatter stringFromDate:[NSDate date]];
        NSString *secondStr = [time substringWithRange:NSMakeRange(17, 2)];
        NSString *msStr = [time substringFromIndex:20];
        second1 = [secondStr intValue];
        ms1 = [msStr longLongValue];
        
        }
    if (gr.state == UIGestureRecognizerStateEnded) {
        NSString *time = [formatter stringFromDate:[NSDate date]];
        NSString *secondStr = [time substringWithRange:NSMakeRange(17, 2)];
        NSString *msStr = [time substringFromIndex:20];
        
        second2 = [secondStr intValue];
        ms2 = [msStr longLongValue];
        int second = second2 - second1;
        long all = second * 10000 + (ms2 - ms1);
        timeInterval = all / 10000.0;
        CGFloat distance = [gr translationInView:self.view].x;
        
        if (distance > 80 && timeInterval < 0.5) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    
    
}

-(void)addToolBar
{
    UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    toolbar.backgroundColor = [UIColor colorWithRed:139.0/250 green:125.0/250 blue:123.0/250 alpha:1];
    NSURL *url = [NSURL URLWithString:_thumbnail];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    [toolbar setBackgroundImage:image forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, 30, 40)];
    [backButton setImage:[UIImage imageNamed:@"Back_White"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backClicked) forControlEvents:UIControlEventTouchUpInside];
    [toolbar addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 50)];
    titleLabel.center = CGPointMake(kScreenWidth/2, 30);
    titleLabel.text = _themeName;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:18];
    [toolbar addSubview:titleLabel];
    [self.view addSubview:toolbar];
}

-(void)backClicked
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)getThemeId:(NSString *)themeId andName:(NSString *)name andThumbnail:(NSString *)thumbnail
{
    _themeId = themeId;
    _themeName = name;
    _thumbnail = thumbnail;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _stories.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[NewsTableViewCell alloc]init];
    }
    NewsInfo *news = [[NewsInfo alloc]init];
    news = _stories[indexPath.row];
    
    cell.title.text = news.title;
    cell.image.image = news.image;
    if (nowTime == nighttime) {
        cell.title.textColor = [UIColor whiteColor];
        _tableView.backgroundColor = [UIColor colorWithRed:54.0/250 green:54.0/250 blue:54.0/250 alpha:1];
    }else{
        cell.title.textColor = [UIColor blackColor];
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NewsInfo *news = [[NewsInfo alloc]init];
    news = _stories[indexPath.row];
    DetailNewsViewController *detailVC = [[DetailNewsViewController alloc]init];
    detailVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [detailVC getRow:indexPath.row andNewsArray:_stories];
    [self presentViewController:detailVC animated:YES completion:nil];
}


@end
