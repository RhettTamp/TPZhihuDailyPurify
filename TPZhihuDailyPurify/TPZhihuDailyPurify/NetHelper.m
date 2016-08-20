//
//  NetHelper.m
//  TPZhihuDailyPurify
//
//  Created by 蓝山工作室 on 16/8/15.
//  Copyright © 2016年 蓝山工作室. All rights reserved.
//

#import "NetHelper.h"
#import "AFNetworking/AFNetworking.h"

static NSString * const kBaseUrl = @"http://news-at.zhihu.com/api/4/";

@implementation NetHelper

+(void)getRequrstWithURL:(NSString *)URLString parameters:(id)parameters success:(success)success failure:(failure)failure
{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
