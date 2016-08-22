//
//  PageView.m
//  TPZhihuDailyPurify
//
//  Created by 蓝山工作室 on 16/8/17.
//  Copyright © 2016年 蓝山工作室. All rights reserved.
//

#import "PageViewController.h"
#import "NetHelper.h"
#import "Header.h"
#import "HomeViewController.h"
#import "NewsInfo.h"
#import "UIViewController+MMDrawerController.h"
#import "DetailNewsViewController.h"

@interface PageViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIImageView *image1;
@property (nonatomic,strong) UIImageView *image2;
@property (nonatomic,strong) UIImageView *image3;
@property (nonatomic,strong) UIImageView *image4;
@property (nonatomic,strong) UIImageView *image5;
@property (nonatomic,strong) UIImageView *image_1;
@property (nonatomic,strong) UIImageView *image_5;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,assign)int currentPage;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,copy)NSMutableArray *topNews;
@property (nonatomic,strong)NSTimer *myTimer;
@property (nonatomic,strong) UIButton *clickButton;

@end

@implementation PageViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, kScreenWidth, kPageViewHeight);
    [self showViews];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    [self removeTimer];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self addTimer];
}


- (void)showViews
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *url = @"news/latest";
        _topNews = [NSMutableArray array];
        [NetHelper getRequrstWithURL:url parameters:nil success:^(id responseObject) {
            
            NSArray *topStorys = responseObject[@"top_stories"];
            
            for (NSDictionary *dic in topStorys) {
                NewsInfo *topNews = [[NewsInfo alloc]init];
                NSString *imageStr = dic[@"image"];
                NSString *title = dic[@"title"];
                NSString *newsId = dic[@"id"];
                NSData *data = [self getDataFromUrlStr:imageStr];
                UIImage *image = [UIImage imageWithData:data];
                
                topNews.image = image;
                topNews.newsId = newsId;
                topNews.title = title;
                [_topNews addObject:topNews];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self addScrollView];
                [self addImageViews];
                [self addPageControl];
                [self addTitleLabel];
                [self addMenuButton];
            });
            
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];

    });
}

-(void)addMenuButton
{
    HomeViewController *homevc = [[HomeViewController alloc]init];
    UIButton *menuButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 20, 30, 30)];
    [menuButton setImage:[UIImage imageNamed:@"MenuButton"] forState:UIControlStateNormal];
    [menuButton setImage:[UIImage imageNamed:@"MenuButton_Highlight"] forState:UIControlStateHighlighted];
    [menuButton addTarget:homevc action:@selector(showLeftView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:menuButton];
}

-(void)showLeftView
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}


-(void)addScrollView
{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kPageViewHeight)];
    _scrollView.contentSize = CGSizeMake(kScreenWidth * 7, kPageViewHeight);
    
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentOffset = CGPointMake(kScreenWidth, 0);

    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scrollTaped)];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setNumberOfTouchesRequired:1];
    [_scrollView addGestureRecognizer:recognizer];
    
    
    [self.view addSubview:_scrollView];
    self.scrollView.delegate = self;
}

-(void)addImageViews
{

    _image1 = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kPageViewHeight)];
    _image2 = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth * 2, 0, kScreenWidth, kPageViewHeight)];
    _image3 = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth * 3, 0, kScreenWidth, kPageViewHeight)];
    _image4 = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth * 4, 0, kScreenWidth, kPageViewHeight)];
    _image5 = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth * 5, 0, kScreenWidth, kPageViewHeight)];
    _image_1 = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth * 6, 0, kScreenWidth, kPageViewHeight)];
    _image_5 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kPageViewHeight)];
    
    NewsInfo *topNews0 = _topNews[0];
    NewsInfo *topNews1 = _topNews[1];
    NewsInfo *topNews2 = _topNews[2];
    NewsInfo *topNews3 = _topNews[3];
    NewsInfo *topNews4 = _topNews[4];
    _image1.image = topNews0.image;
    _image2.image = topNews1.image;
    _image3.image = topNews2.image;
    _image4.image = topNews3.image;
    _image5.image = topNews4.image;
    _image_1.image = topNews0.image;
    _image_5.image = topNews4.image;
    
    [_scrollView addSubview:_image1];
    [_scrollView addSubview:_image2];
    [_scrollView addSubview:_image3];
    [_scrollView addSubview:_image4];
    [_scrollView addSubview:_image5];
    [_scrollView addSubview:_image_1];
    [_scrollView addSubview:_image_5];
}




-(void)scrollTaped
{
    DetailNewsViewController *detailVC = [[DetailNewsViewController alloc]init];
    [detailVC getRow:_currentPage andNewsArray:_topNews];
    detailVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:detailVC animated:YES completion:nil];
}

-(void)addPageControl
{
    _pageControl = [[UIPageControl alloc]init];
    _pageControl.numberOfPages = 5;
    CGSize size = [_pageControl sizeForNumberOfPages:5];
    
    _pageControl.bounds = CGRectMake(0, 0, size.width, size.height);
    _pageControl.center = CGPointMake(kScreenWidth/2, kPageViewHeight-8);
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    _currentPage = 0;
    [self.view addSubview:_pageControl];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    _currentPage = _scrollView.contentOffset.x/kScreenWidth - 1;
    if (_currentPage < 0) {
        _currentPage = 4;
        _scrollView.contentOffset = CGPointMake(kScreenWidth * 5, 0);
    }else if (_currentPage > 4)
    {
        _currentPage = 0;
        _scrollView.contentOffset = CGPointMake(kScreenWidth, 0);
    }
    _pageControl.currentPage = _currentPage;
    
    NewsInfo *news = [[NewsInfo alloc]init];
    news = _topNews[_currentPage];
    
    _titleLabel.text = news.title;
}

-(void)addTitleLabel
{
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, kPageViewHeight - 60, kScreenWidth - 10, 55)];
    _titleLabel.font = [UIFont systemFontOfSize:18];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.numberOfLines = 2;
    
    NewsInfo *news = _topNews[0];
    _titleLabel.text = news.title;
    [self.view addSubview:_titleLabel];
}

-(void)addTimer
{
     _myTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(rollingPicture) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop]addTimer:_myTimer forMode:NSRunLoopCommonModes];
}

-(void)removeTimer
{
    [_myTimer invalidate];
    _myTimer = nil;
}

-(void)rollingPicture
{
    NewsInfo *news = [[NewsInfo alloc]init];
    CGPoint currentOffset = CGPointZero;
    
    _currentPage += 1;
    currentOffset.x = (_currentPage + 1) * kScreenWidth;
    _scrollView.contentOffset = currentOffset;
    news = _topNews[_currentPage];
    _titleLabel.text = news.title;
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addTimer];
}

-(NSData *)getDataFromUrlStr:(NSString *)urlStr
{
    NSURL *url = [NSURL URLWithString:urlStr];
    NSData *data = [NSData dataWithContentsOfURL:url];
    return data;
}


@end
