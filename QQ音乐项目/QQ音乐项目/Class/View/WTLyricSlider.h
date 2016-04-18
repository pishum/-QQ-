//
//  WTLyricSlider.h
//  QQ音乐项目
//
//  Created by a on 2/4/16.
//  Copyright © 2016年 wtt. All rights reserved.
//

#import <UIKit/UIKit.h>
#define WTLyricSliderPlayNotification @"WTLyricSliderPlayNotification"

@interface WTLyricSlider : UIView

+(instancetype) lyricSlider;

@property (nonatomic,assign) NSTimeInterval beginTime;

@end
