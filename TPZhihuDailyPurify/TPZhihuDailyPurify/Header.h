//
//  Header.h
//  TPZhihuDailyPurify
//
//  Created by 蓝山工作室 on 16/8/15.
//  Copyright © 2016年 蓝山工作室. All rights reserved.
//

#ifndef Header_h
#define Header_h

#define kScreenFram [UIScreen mainScreen].bounds
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeith [UIScreen mainScreen].bounds.size.height
#define kPageViewHeight 200
//int nowTime;
static NSString * const cellID = @"cellID";
typedef NS_ENUM(NSInteger, states) {
    daytime = 0,
    nighttime = 1,
};
static int nowTime;
#endif /* Header_h */
