//
//  UserInfo.m
//  TPZhihuDailyPurify
//
//  Created by 蓝山工作室 on 16/9/12.
//  Copyright © 2016年 蓝山工作室. All rights reserved.
//

#import "UserInfo.h"
#import "header.h"
@interface UserInfo ()

@end

@implementation UserInfo
static UserInfo *defaltInfoManager = nil;
+(instancetype)defaltInfoManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaltInfoManager = [[UserInfo alloc]init];
        defaltInfoManager.stored = [NSMutableArray alloc];
        defaltInfoManager.timeStates = dayTime;
    });
    return defaltInfoManager;
}

//-(instancetype)init
//{
//    if (defaltInfoManager) {
//        return defaltInfoManager;
//    }
//    else{
//        [UserInfo defaltInfoManager];
//        return defaltInfoManager;
//    }
//}

//+(instancetype)allocWithZone:(struct _NSZone *)zone
//{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        defaltInfoManager = [super allocWithZone:zone];
//    });
//    return defaltInfoManager;
//}

-(void)staoreNews:(NewsInfo *)news
{
    [self.stored addObject:news];
}

-(void)changeStates
{
    self.timeStates = -self.timeStates;
}



@end
