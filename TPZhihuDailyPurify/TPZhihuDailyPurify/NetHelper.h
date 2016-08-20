//
//  NetHelper.h
//  TPZhihuDailyPurify
//
//  Created by 蓝山工作室 on 16/8/15.
//  Copyright © 2016年 蓝山工作室. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetHelper : NSObject

typedef void (^success)(id responseObject);
typedef void (^failure)(NSError *error);

+ (void)getRequrstWithURL:(NSString *)URLString parameters:(id)parameters success:(success)success failure:(failure)failure;

@end
