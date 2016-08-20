//
//  NewsTableViewCell.m
//  TPZhihuDailyPurify
//
//  Created by 蓝山工作室 on 16/8/19.
//  Copyright © 2016年 蓝山工作室. All rights reserved.
//

#import "NewsTableViewCell.h"
#import "Header.h"
@implementation NewsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, kScreenWidth, 90);
        _title = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, kScreenWidth - 100, 80)];
        _title.font = [UIFont systemFontOfSize:15];
        _title.numberOfLines = 2;
        _title.textAlignment = NSTextAlignmentJustified;
        _image = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth - 70, 15, 60, 55)];
        [self addSubview:_title];
        [self addSubview:_image];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
