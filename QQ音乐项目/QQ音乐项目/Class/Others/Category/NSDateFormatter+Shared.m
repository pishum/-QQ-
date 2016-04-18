//
//  NSDateFormatter+Shared.m
//  08-QQ音乐
//
//  Created by shenzhenIOS on 16/3/31.
//  Copyright © 2016年 shenzhenIOS. All rights reserved.
//

#import "NSDateFormatter+Shared.h"

@implementation NSDateFormatter (Shared)

+ (instancetype) sharedDateFormatter{
    static NSDateFormatter *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

@end
