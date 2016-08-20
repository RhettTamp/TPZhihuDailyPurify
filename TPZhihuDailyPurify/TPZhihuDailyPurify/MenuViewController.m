//
//  MenuViewController.m
//  TPZhihuDailyPurify
//
//  Created by 蓝山工作室 on 16/8/18.
//  Copyright © 2016年 蓝山工作室. All rights reserved.
//

#import "MenuViewController.h"
#import "Header.h"
@interface MenuViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UIView *topView;
@property (nonatomic,strong)UIView *holdView;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,copy)NSArray *cells;
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
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    
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
    
    
    _cells = [NSArray array];
    _cells = @[@"日常心理学",@"用户推荐日报",@"电影日报",@"不许无聊",@"设计日报",@"大公司日报",@"财经日报",@"互联网安全",@"开始游戏",@"音乐日报",@"动漫日报",@"体育日报"];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 90, 200, kScreenHeith - 150) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor colorWithRed:74.0/250 green:112.0/250 blue:119.0/250 alpha:1];
    [_tableView setSeparatorColor:[UIColor clearColor]];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
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
    
    [self.view addSubview:_topView];
    [self.view addSubview:_tableView];
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
    return _cells.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const cellID = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    cell.backgroundColor = [UIColor colorWithRed:74.0/250 green:112.0/250 blue:119.0/250 alpha:1];
    cell.textLabel.textColor = [UIColor colorWithRed:207.0/250 green:207.0/250 blue:207.0/250 alpha:1];
    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.0/250 green:104.0/250 blue:139.0/250 alpha:1];
    if (indexPath.section == 1) {
        cell.textLabel.text = _cells[indexPath.row];
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

@end
