//
//  LatestNews.h
//  TPZhihuDailyPurify
//
//  Created by 蓝山工作室 on 16/8/19.
//  Copyright © 2016年 蓝山工作室. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NewsInfo : NSObject

@property (nonatomic,strong)UIImage *image;
@property (nonatomic,strong)NSString *newsId;
@property (nonatomic,strong)NSString *date;
@property (nonatomic,strong)NSString *title;

@end
