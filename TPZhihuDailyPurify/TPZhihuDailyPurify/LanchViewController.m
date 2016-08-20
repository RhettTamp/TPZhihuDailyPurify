//
//  LanchViewController.m
//  TPZhihuDailyPurify
//
//  Created by 蓝山工作室 on 16/8/15.
//  Copyright © 2016年 蓝山工作室. All rights reserved.
//

#import "LanchViewController.h"
#import "Header.h"
#import "NetHelper.h"
#import "HomeViewController.h"
#import "PageViewController.h"
#import "MenuViewController.h"

#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"

@interface LanchViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *lanchVIew;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong)MMDrawerController *drawerVC;
@end

@implementation LanchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self showImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showImage
{
    CGFloat scale = [UIScreen mainScreen].scale;
    NSInteger imageWidth = kScreenWidth * scale;
    NSInteger imageHeight = kScreenHeith * scale;
    
    [NetHelper getRequrstWithURL:[NSString stringWithFormat:@"start-image/%ld*%ld",(long)imageWidth,(long)imageHeight] parameters:nil success:^(id responseObject) {
        NSString *imageURL = responseObject[@"img"];
        NSString *title = responseObject[@"text"];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
            _imageView.image = image;
            _titleLabel.text = title;
            [UIView animateWithDuration:5.0f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                _lanchVIew.alpha = 0.f;
                _imageView.transform = CGAffineTransformMakeScale(1.08, 1.08);
            } completion:^(BOOL finished) {
                HomeViewController *homeVC = [[HomeViewController alloc]init];
                MenuViewController *menuVC = [[MenuViewController alloc]init];
                _drawerVC = [[MMDrawerController alloc]initWithCenterViewController:homeVC leftDrawerViewController:menuVC];
                _drawerVC.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
                _drawerVC.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;
                _drawerVC.maximumLeftDrawerWidth = 200;
                self.view.window.rootViewController = _drawerVC;
            }];
        });
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
