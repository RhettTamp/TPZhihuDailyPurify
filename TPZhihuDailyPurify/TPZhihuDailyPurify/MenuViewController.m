//
//  MenuViewController.m
//  TPZhihuDailyPurify
//
//  Created by 蓝山工作室 on 16/8/18.
//  Copyright © 2016年 蓝山工作室. All rights reserved.
//

#import "MenuViewController.h"
#import "NetHelper.h"
#import "ThemesInfo.h"
#import "Header.h"
#import "UIViewController+MMDrawerController.h"
#import "ThemeDetailViewController.h"
@interface MenuViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UIView *topView;
@property (nonatomic,strong)UIView *holdView;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,copy)NSMutableArray *themes;
@property (nonatomic,strong)UIView *separatView;
@property (nonatomic,strong)UIButton *leftButton;
@property (nonatomic,strong)UIButton *rightButton;
@property (nonatomic,strong)UIButton *loginButton;
@property (nonatomic,strong)UIButton *collectButton;
@property (nonatomic,strong)UIButton *messageButton;
@property (nonatomic,strong)UIButton *settingButton;
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showThemes];
    [self addTopView];
    [self addBottomView];
}



-(void)addTopView
{
    _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 90)];
    _topView.backgroundColor = [UIColor colorWithRed:74.0/250 green:112.0/250 blue:119.0/250 alpha:1];
  
    _loginButton = [[UIButton alloc]initWithFrame:CGRectMake(30, 20, 50, 30)];
    [_loginButton setTitle:@"请登陆" forState:UIControlStateNormal];
    _loginButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    _collectButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 55, 30, 30)];
    [_collectButton setTitle:@"收藏" forState:UIControlStateNormal];
    _collectButton.titleLabel.font = [UIFont systemFontOfSize:13];
    
    _messageButton = [[UIButton alloc]initWithFrame:CGRectMake(85, 55, 30, 30)];
    [_messageButton setTitle:@"消息" forState:UIControlStateNormal];
    _messageButton.titleLabel.font = [UIFont systemFontOfSize:13];
    
    _settingButton = [[UIButton alloc]initWithFrame:CGRectMake(150, 55, 30, 30)];
    [_settingButton setTitle:@"设置" forState:UIControlStateNormal];
    _settingButton.titleLabel.font = [UIFont systemFontOfSize:13];
    
    [_topView addSubview:_loginButton];
    [_topView addSubview:_collectButton];
    [_topView addSubview:_messageButton];
    [_topView addSubview:_settingButton];
    
    _separatView = [[UIView alloc]initWithFrame:CGRectMake(0, 89, 200, 0.5)];
    _separatView.backgroundColor = [UIColor colorWithRed:54.0/250 green:54.0/250 blue:54.0/250 alpha:1];
    [_topView addSubview:_separatView];
    
    [self.view addSubview:_topView];
}

-(void)addBottomView
{
    _holdView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeith - 150, 200, 150)];
    _holdView.backgroundColor = [UIColor colorWithRed:74.0/250 green:112.0/250 blue:119.0/250 alpha:1];
    
    _leftButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 100, 40, 40)];
    [_leftButton setTitle:@"离线" forState:UIControlStateNormal];
    _leftButton.titleLabel.textColor = [UIColor colorWithRed:207.0/250 green:207.0/250 blue:207.0/250 alpha:1];
    
    _rightButton = [[UIButton alloc]initWithFrame:CGRectMake(200-20-40, 100, 40, 40)];
    [_rightButton setTitle:@"夜间" forState:UIControlStateNormal];
    _rightButton.titleLabel.textColor = [UIColor colorWithRed:207.0/250 green:207.0/250 blue:207.0/250 alpha:1];
    
    [_holdView addSubview:_leftButton];
    [_holdView addSubview:_rightButton];
    
    [self.view addSubview:_holdView];
}

-(void)addThemeTable
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 90, 200, kScreenHeith - 150) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor colorWithRed:74.0/250 green:112.0/250 blue:119.0/250 alpha:1];
    [_tableView setSeparatorColor:[UIColor clearColor]];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

-(void)showThemes
{
    _themes = [NSMutableArray array];
    [NetHelper getRequrstWithURL:@"themes" parameters:nil success:^(id responseObject) {
        
        NSArray *others = responseObject[@"others"];
        for (NSDictionary *dic in others) {
            NSString *themeId = dic[@"id"];
            NSString *themeName = dic[@"name"];
            NSString *thumbnail = dic[@"thumbnail"];
            ThemesInfo *theme = [[ThemesInfo alloc]init];
            theme.themeId = themeId;
            theme.themeName = themeName;
            theme.thumbnail = thumbnail;
            [_themes addObject:theme];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addThemeTable];
        });
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return _themes.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    
    ThemesInfo *theme = [[ThemesInfo alloc]init];
    theme = _themes[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    cell.backgroundColor = [UIColor colorWithRed:74.0/250 green:112.0/250 blue:119.0/250 alpha:1];
    cell.textLabel.textColor = [UIColor colorWithRed:207.0/250 green:207.0/250 blue:207.0/250 alpha:1];
    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.0/250 green:104.0/250 blue:139.0/250 alpha:1];
    if (indexPath.section == 1) {
        cell.textLabel.text = theme.themeName;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        cell.textLabel.text = @"首页";
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 0.5)];
        view.backgroundColor = [UIColor colorWithRed:54.0/250 green:54.0/250 blue:54.0/250 alpha:1];
        return view;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        ThemesInfo *theme = _themes[indexPath.row];
        ThemeDetailViewController *themeVC = [[ThemeDetailViewController alloc]init];
        themeVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [themeVC getThemeId:theme.themeId andName:theme.themeName andThumbnail:theme.thumbnail];
        [self presentViewController:themeVC animated:YES completion:nil];
    }
}





@end
