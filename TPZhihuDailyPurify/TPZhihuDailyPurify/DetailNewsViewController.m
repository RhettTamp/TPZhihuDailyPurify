//
//  DetailNewsViewController.m
//  TPZhihuDailyPurify
//
//  Created by 蓝山工作室 on 16/8/19.
//  Copyright © 2016年 蓝山工作室. All rights reserved.
//

#import "DetailNewsViewController.h"
#import "Header.h"
#import "NetHelper.h"
#import "HomeViewController.h"
#import "NewsInfo.h"

@interface DetailNewsViewController ()<UIWebViewDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,assign) NSInteger selectedRow;
@property (nonatomic,strong) UIImageView *HeadImage;
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,copy) NSArray *newsArray;
@property (nonatomic,assign) int comments;
@property (nonatomic,assign) int popularity;
@property (nonatomic,strong) UIButton *backButton;
@property (nonatomic,strong) UIButton *nextButton;
@property (nonatomic,strong) UIButton *agreeButton;
@property (nonatomic,strong) UILabel *agreeLabe;
@property (nonatomic,strong) UIButton *shareButton;
@property (nonatomic,strong) UIButton *commentButton;
@property (nonatomic,strong) UILabel *commentLabel;
@property (nonatomic,copy) NSArray *topNews;
@property (nonatomic,strong) UILabel *TopWarnLabel;
@property (nonatomic,strong) UILabel *bottomWarnLabel;

@end

@implementation DetailNewsViewController
{
    int second1,second2;
    long ms1,ms2;
    CGFloat timeInterval;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeTheme:) name:@"change" object:nil];
    
    UIPanGestureRecognizer *panRcognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:panRcognizer];
    _webView.delegate = self;
    
}

//-(void)dealloc
//{
//    [[NSNotificationCenter defaultCenter]removeObserver:self];
//}

//-(void)changeTheme:(NSNotification *)sender
//{
//    nowTime = [sender.userInfo[@"nowTime"] intValue];
//    if (nowTime == nighttime) {
//        _webView.backgroundColor = [UIColor colorWithRed:54.0/250 green:54.0/250 blue:54.0/250 alpha:1];
//    }else{
//        _webView.backgroundColor = [UIColor whiteColor];
//    }
//    
//}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self addWebView];
    [self loadNews];
    [self addHeadImage];
    
}


-(void)addHeadImage
{
    _HeadImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, -80, kScreenWidth, 300)];
    [_webView.scrollView addSubview:_HeadImage];
    
    _TopWarnLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    _TopWarnLabel.center = CGPointMake(kScreenWidth/2, 20);
    _TopWarnLabel.text = @"载入上一篇";
    _TopWarnLabel.textColor = [UIColor grayColor];
    _TopWarnLabel.font = [UIFont systemFontOfSize:15];
    _TopWarnLabel.textAlignment = NSTextAlignmentCenter;
    _TopWarnLabel.hidden = YES;
    
    _bottomWarnLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    _bottomWarnLabel.center = CGPointMake(kScreenWidth/2, kScreenHeith - 50 - 40);
    _bottomWarnLabel.text = @"载入下一篇";
    _bottomWarnLabel.textColor = [UIColor grayColor];
    _bottomWarnLabel.font = [UIFont systemFontOfSize:15];
    _bottomWarnLabel.textAlignment = NSTextAlignmentCenter;
    _bottomWarnLabel.hidden = YES;
    [_webView addSubview:_TopWarnLabel];
    [_webView addSubview:_bottomWarnLabel];
}

-(void)addWebView
{
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, kScreenHeith - 70)];
    _webView.scrollView.delegate = self;
    [self.view addSubview:_webView];
    
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
        CGFloat distance = [gr translationInView:_webView].x;
        if (distance > 80 && timeInterval < 0.5) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    
    
}


-(void)addBottomView
{
    
    UIFont *font = [UIFont fontWithName:@"CourierNewPS-BoldMT" size:11];
    NSInteger insert = (kScreenWidth - 20 - 60 * 5)/4;
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeith - 50, kScreenWidth, 50)];
    _backButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 60, 50)];
    [_backButton setImage:[UIImage imageNamed:@"News_Navigation_Arrow"] forState:UIControlStateNormal];
    [_backButton setImage:[UIImage imageNamed:@"News_Navigation_Arrow_Highlight"] forState:UIControlStateHighlighted];
    [_backButton addTarget:self action:@selector(backClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    _nextButton = [[UIButton alloc]initWithFrame:CGRectMake(10 + 60 +insert, 0, 60, 50)];
    [_nextButton setImage:[UIImage imageNamed:@"News_Navigation_Next"] forState:UIControlStateNormal];
    [_nextButton setImage:[UIImage imageNamed:@"News_Navigation_Next_Highlight"] forState:UIControlStateHighlighted];
    [_nextButton addTarget:self action:@selector(nextClicked) forControlEvents:UIControlEventTouchUpInside];
    
    _agreeButton = [[UIButton alloc]initWithFrame:CGRectMake(10 + 60 * 2 + insert * 2, 0, 60, 50)];
    [_agreeButton setImage:[UIImage imageNamed:@"News_Navigation_Vote"] forState:UIControlStateNormal];
    [_agreeButton setImage:[UIImage imageNamed:@"News_Navigation_Voted"] forState:UIControlStateHighlighted];
    _agreeButton.tag = 0;
    [_agreeButton addTarget:self action:@selector(agreeClicked:) forControlEvents:UIControlEventTouchUpInside];
    _agreeLabe = [[UILabel alloc]initWithFrame:CGRectMake(16, 4, 40, 32)];
    _agreeLabe.textColor = [UIColor colorWithRed:139.0/250 green:137.0/250 blue:137.0/250 alpha:1];
    
    
    _agreeLabe.textAlignment = NSTextAlignmentRight;
    _agreeLabe.font = font;
    _agreeLabe.adjustsFontSizeToFitWidth = YES;
    _agreeLabe.text = [NSString stringWithFormat:@"%d",_popularity];
    [_agreeButton addSubview:_agreeLabe];
    
    _shareButton = [[UIButton alloc]initWithFrame:CGRectMake(10 + 60 * 3 + insert * 3, 0, 60, 50)];
    [_shareButton setImage:[UIImage imageNamed:@"News_Navigation_Share"] forState:UIControlStateNormal];
    [_shareButton setImage:[UIImage imageNamed:@"News_Navigation_Share_Highlight"] forState:UIControlStateHighlighted];
    [_shareButton addTarget:self action:@selector(shareClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    _commentButton = [[UIButton alloc]initWithFrame:CGRectMake(10 + 60 * 4 + insert * 4, 0, 60, 50)];
    [_commentButton setImage:[UIImage imageNamed:@"News_Navigation_Comment"] forState:UIControlStateNormal];
    [_commentButton setImage:[UIImage imageNamed:@"News_Navigation_Comment_Highlight"] forState:UIControlStateHighlighted];
    [_commentButton addTarget:self action:@selector(commentClicked) forControlEvents:UIControlEventTouchUpInside];
    _commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(22, 4, 35, 25)];
    _commentLabel.textAlignment = NSTextAlignmentCenter;
    _commentLabel.textColor = [UIColor whiteColor];
    _commentLabel.font = font;
    _commentLabel.text = [NSString stringWithFormat:@"%d",_comments];
    [_commentButton addSubview:_commentLabel];
    
    [_bottomView addSubview:_shareButton];
    [_bottomView addSubview:_commentButton];
    [_bottomView addSubview:_nextButton];
    [_bottomView addSubview:_agreeButton];
    [_bottomView addSubview:_backButton];
    [self.view addSubview:_bottomView];
}

-(void)reviseBottomView
{
    _agreeLabe.text = [NSString stringWithFormat:@"%d",_popularity];
    _commentLabel.text = [NSString stringWithFormat:@"%d",_comments];
}


-(void)backClicked
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)nextClicked
{
    
    if (_selectedRow < _newsArray.count - 1) {
        _TopWarnLabel.text = @"载入上一篇";
        _selectedRow += 1;
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rect = CGRectMake(0, -kScreenHeith, kScreenWidth, kScreenHeith);
            self.view.frame = rect;
            self.view.window.backgroundColor = [UIColor whiteColor];
        } completion:^(BOOL finished) {
            self.view.frame = kScreenFram;
            [self loadNews];
        }];
        
    }
    
}



-(void)shareClicked
{
    
}


-(void)commentClicked
{
    
}

-(void)agreeClicked:(UIButton *)sender
{
    if (sender.tag == 0) {
        [sender setImage:[UIImage imageNamed:@"News_Navigation_Voted"] forState:UIControlStateNormal];
        _popularity += 1;
        sender.tag = 1;
    }else{
        [sender setImage:[UIImage imageNamed:@"News_Navigation_Vote"] forState:UIControlStateNormal];
        _popularity -= 1;
        sender.tag = 0;
    }
    
}






-(void)getRow:(NSInteger)row andNewsArray:(NSArray *)array{
    _newsArray = array;
    _selectedRow = row;
}

-(void)loadNews
{
    if (_selectedRow < _newsArray.count) {
       // dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NewsInfo *news = _newsArray[_selectedRow];
            NSString *newsId = news.newsId;
            [self getExtraImfomation:newsId];
            [NetHelper getRequrstWithURL:[NSString stringWithFormat:@"news/%@",newsId] parameters:nil success:^(id responseObject) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSArray *css = responseObject[@"css"];
                    NSString *webUrl = css[0];
                    NSString *body = responseObject[@"body"];
                    NSString *htmlStr = [NSString stringWithFormat:@"<html><head><link rel=\"stylesheet\" href=%@></head><body>%@</body></html>",webUrl,body];
                    NSString *imageStr = responseObject[@"image"];
                    NSURL *url = [NSURL URLWithString:imageStr];
                    NSData *data = [NSData dataWithContentsOfURL:url];
                    UIImage *image = [UIImage imageWithData:data];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_webView loadHTMLString:htmlStr baseURL:nil];
                        _HeadImage.image = image;
                        if (_bottomView == nil) {
                            [self addBottomView];
                        }else{
                            [self reviseBottomView];
                        }
                        
                    });
                });
                
                
            } failure:^(NSError *error) {
                NSLog(@"%@",error);
            }];
       // });
    }
}

-(void)getExtraImfomation:(NSString *)newsId
{
    [NetHelper getRequrstWithURL:[NSString stringWithFormat:@"story-extra/%@",newsId] parameters:nil success:^(id responseObject) {
        _comments = [responseObject[@"comments"] intValue];
        _popularity = [responseObject[@"popularity"] intValue];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat __block contentOffheight = _webView.scrollView.contentOffset.y;
    if (contentOffheight <= -60) {
        _TopWarnLabel.hidden = NO;
    }else{
        _TopWarnLabel.hidden = YES;
    }
    if (contentOffheight + _webView.frame.size.height >= _webView.scrollView.contentSize.height + 50) {
        _bottomWarnLabel.hidden = NO;
    }else{
        _bottomWarnLabel.hidden = YES;
    }
}


-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat contentOffheight = _webView.scrollView.contentOffset.y;
    if (contentOffheight <= 80) {
        if (_selectedRow > 0) {
            _selectedRow -= 1;
            _TopWarnLabel.text = @"载入上一篇";
            [UIView animateWithDuration:0.3 animations:^{
                CGRect rect = CGRectMake(0, kScreenHeith, kScreenWidth, kScreenHeith);
                self.view.frame = rect;
                self.view.window.backgroundColor = [UIColor whiteColor];
            } completion:^(BOOL finished) {
                self.view.frame = kScreenFram;
                [self loadNews];
            }];
        }else{
            _TopWarnLabel.text = @"已经是第一篇";
        }
    }
    if (contentOffheight + _webView.frame.size.height >= _webView.scrollView.contentSize.height + 80) {
        if (_selectedRow < _newsArray.count) {
            _TopWarnLabel.text = @"载入上一篇";
            _selectedRow += 1;
            [UIView animateWithDuration:0.3 animations:^{
                CGRect rect = CGRectMake(0, -kScreenHeith, kScreenWidth, kScreenHeith);
                self.view.frame = rect;
                self.view.window.backgroundColor = [UIColor whiteColor];
            } completion:^(BOOL finished) {
                self.view.frame = kScreenFram;
                [self loadNews];
            }];
            
        }

    }
}


@end
