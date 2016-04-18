//
//  WTMusic.h
//  QQ音乐项目
//
//  Created by a on 1/4/16.
//  Copyright © 2016年 wtt. All rights reserved.

#import "WTFormattor.h"

@implementation WTFormattor

+ (NSString *) stringFromTime:(NSTimeInterval) time {
    int minute = time / 60;
    int scound = (int)time % 60;
    return [NSString stringWithFormat:@"%02d:%02d",minute,scound];
}


@end
