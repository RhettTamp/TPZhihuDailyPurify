//
//  Header.h
//  TPZhihuDailyPurify
//
//  Created by 蓝山工作室 on 16/8/15.
//  Copyright © 2016年 蓝山工作室. All rights reserved.
//

#ifndef Header_h
#define Header_h
#import "UserInfo.h"
#define kScreenFram [UIScreen mainScreen].bounds
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeith [UIScreen mainScreen].bounds.size.height
#define kPageViewHeight 200
#define kNowTime [[NSUserDefaults standardUserDefaults]integerForKey:@"nowTime"]
#define dayTime YES
#define nightTime NO
static NSString * const cellID = @"cellID";
//typedef NS_ENUM(NSInteger, states) {
//    daytime = 0,
//    nighttime = 1,
//};
//static NSInteger nowTime;
#endif /* Header_h */
