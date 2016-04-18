//
//  WTMusic.h
//  QQ音乐项目
//
//  Created by a on 1/4/16.
//  Copyright © 2016年 wtt. All rights reserved.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WTMusic.h"

@class WTPlayerManager;
@class WTLineLyric;

@protocol WTPlayerManagerDelegate <NSObject>

@optional
- (void) playerManager:(WTPlayerManager *) playerManager
didUpdateProgressWithInterval:(NSTimeInterval) interval;
/// 当更新歌词进度的时候调用
///
/// @param playerManager 播放管理器
/// @param lineLyric     当前的这一句歌词
/// @param index          当前的这一句歌词的索引
- (void) playerManager:(WTPlayerManager *) playerManager
didUpdateLyricProgress:(CGFloat) progress withLyric:(WTLineLyric *) lineLyric atIndex:(NSInteger) index;

/// 播放结束回调
- (void)  playerManager:(WTPlayerManager *) playerManager didFinishedWithFlag:(BOOL) isSuccess;


@end



@interface WTPlayerManager : NSObject

@property (nonatomic, weak) id<WTPlayerManagerDelegate> delegate;
@property (nonatomic, strong,readonly) NSArray *lineLyrics;
@property (nonatomic, assign) NSTimeInterval currentTime;
@property (nonatomic, assign,readonly) NSTimeInterval duration;

+ (instancetype) sharedPlayerManager;

/// 准备播放
- (void) prepareToPlayWithMusic:(WTMusic *) music;

- (void) play;

- (void) pause;

@end
