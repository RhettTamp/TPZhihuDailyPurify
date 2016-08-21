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

@interface DetailNewsViewController ()

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

@end

@implementation DetailNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self addWebView];
    [self loadNews];
    [self addHeadImage];

}


-(void)addHeadImage
{
    _HeadImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 220)];
    
    [self.view insertSubview:_HeadImage aboveSubview:_webView];
}

-(void)addWebView
{
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, kScreenHeith - 70)];
    
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiped)];
    [_webView addGestureRecognizer:recognizer];
    [self.view addSubview:_webView];

}

-(void)swiped
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
        NewsInfo *news = _newsArray[_selectedRow];
        NSString *newsId = news.newsId;
        [self getExtraImfomation:newsId];
        [NetHelper getRequrstWithURL:[NSString stringWithFormat:@"news/%@",newsId] parameters:nil success:^(id responseObject) {
            
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
            
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
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


@end
