//
//  UserInfo.h
//  TPZhihuDailyPurify
//
//  Created by 蓝山工作室 on 16/9/12.
//  Copyright © 2016年 蓝山工作室. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsInfo.h"


@interface UserInfo : NSObject

@property (nonatomic,strong)NSMutableArray *stored;
@property (nonatomic,assign) BOOL timeStates;
+(instancetype)defaltInfoManager;
-(void)staoreNews:(NewsInfo *)news;
-(void)changeStates;


@end
