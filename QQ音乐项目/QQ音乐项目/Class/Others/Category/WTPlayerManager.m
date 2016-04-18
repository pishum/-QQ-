//
//  WTMusic.h
//  QQ音乐项目
//
//  Created by a on 1/4/16.
//  Copyright © 2016年 wtt. All rights reserved.
//

#import "WTPlayerManager.h"
#import <AVFoundation/AVFoundation.h>
#import "WTLyricParser.h"
#import "WTLineLyric.h"
static NSTimeInterval const kUpdateMusicProgressInterval = 0.005;

@interface WTPlayerManager ()<AVAudioPlayerDelegate>

/// 播放器
@property (nonatomic, strong) AVAudioPlayer *player;

///定时器
@property (nonatomic, strong) NSTimer *timer;

/// 歌词数组
@property (nonatomic, strong) NSArray *lineLyrics;
@end


@implementation WTPlayerManager

+ (instancetype) sharedPlayerManager
{
    static WTPlayerManager *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}
-(instancetype) init
{
     if(self=[super init]){
          [self setting];
     }
     return self;
}
-(void)setting
{
     NSError *error=nil;
     [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
     if (error) {
          NSLog(@"注册播放类别失败:%@",error);
     }
     [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];

     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioSessionInterruptionNotifation:) name:AVAudioSessionInterruptionNotification object:nil];


}

-(void)audioSessionInterruptionNotifation:(NSNotification *)notification
{
     AVAudioSessionInterruptionType type=[notification.userInfo[AVAudioSessionInterruptionTypeKey] intValue];
     if (type==AVAudioSessionInterruptionTypeBegan) {
          [self pause];
     }else if (type==AVAudioSessionInterruptionTypeEnded)
     {
          [self play];
     }else{
          NSLog(@"意外情况发生");
     }
}



- (void) prepareToPlayWithMusic:(WTMusic *) music {
    
     //  解析歌词+(NSArray *) linelyricsWithLyricFileName:(NSString *)fileName
     self.lineLyrics = [WTLyricParser linelyricsWithLyricFileName:music.lrc];
     
     NSURL *URL = [[NSBundle mainBundle] URLForResource:music.mp3 withExtension:nil];
     NSError *error = nil;
     self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:URL error:&error];
     if (error) {
          NSLog(@"音乐播放器创建失败：%@",error);
          return;
     }
     
     //  准备播放
    
     self.player.delegate=self;
      [self.player prepareToPlay];
}

- (void)play {
     //  每次播放的时候注册播放类型
     NSError *error = nil;
     [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
     if (error) {
          NSLog(@"注册播放类别失败:%@",error);
     }
     
    [self.player play];
     
     
     [self startUpdateMusicProgress];
     
  
     
}

- (void)pause {
    [self.player pause];
   [self stopUpdateMusicProgress];
}


- (NSTimeInterval)currentTime {
    return self.player.currentTime;
}

- (void)setCurrentTime:(NSTimeInterval)currentTime {
    self.player.currentTime = currentTime;
}

- (NSTimeInterval)duration {
    return self.player.duration;
}

#pragma mark - 进度更新相关的
- (void) updateMusicProgress {
     
     //  判断
     if([self.delegate respondsToSelector:
         @selector(playerManager:didUpdateProgressWithInterval:)]){
          
          [self.delegate playerManager:self
         didUpdateProgressWithInterval:kUpdateMusicProgressInterval];
          //      更新歌词进度
          [self updateLyricProgress];
     }
     
}
/// 更新歌词进度
- (void) updateLyricProgress {
     
     //  找出当前播放的第几句歌词
     //  self.player.currentTime 当前播放时间
     //  每一句歌词开始时间
     //  当前歌词播放时间 <= self.player.currentTime < 下一句歌词开始时间
     //  1. 第一种方法遍历所有歌词，找出这一句。
     //    __block HMLineLyric *currentLineLyric = nil;
     //    [self.lineLyrics enumerateObjectsUsingBlock:^(HMLineLyric *lineLyric, NSUInteger idx, BOOL * _Nonnull stop) {
     //        if (self.lineLyrics.count - 1 == idx) {
     //            currentLineLyric = lineLyric;
     //            *stop = YES;
     //        }
     //        HMLineLyric *nextLyric = self.lineLyrics[idx + 1];
     //        if (lineLyric.beginTime <= self.currentTime && nextLyric.beginTime > self.currentTime) {
     //            currentLineLyric = lineLyric;
     //            *stop = YES;
     //        }
     //    }];
     //    NSLog(@"%lf",currentLineLyric.beginTime);
     //  2. 第二种遍历方式
     NSInteger nextLyricIndex = 0;
     for (NSInteger i = 0; i < self.lineLyrics.count; ++i) {
          WTLineLyric *lyric = self.lineLyrics[i];
          //      第一次找到大于当前播放时间的那句歌词就是下一句歌词（因为歌词是升序排列的）
          if (lyric.beginTime > self.currentTime) {
               nextLyricIndex = i;
               break;
          }
     }
     
     // 如果没有找到下一句的歌词，那么当前的歌词就是最后一句
     //  歌词进度
     CGFloat lyricProgress = 0;
     //  当前的歌词
     WTLineLyric *currentLyric = nil;
     //  当前的索引
     NSInteger currentIndex = 0;
     
     if (nextLyricIndex == 0) {
          currentIndex = self.lineLyrics.count-1;
          currentLyric = self.lineLyrics[currentIndex];
          lyricProgress = (self.currentTime - currentLyric.beginTime) / (self.duration - currentLyric.beginTime);
     }else{
          //    NSLog(@"%zd",nextLyricIndex);
          currentIndex = nextLyricIndex-1;
          WTLineLyric *nextLyric = self.lineLyrics[nextLyricIndex];
          currentLyric = self.lineLyrics[nextLyricIndex-1];
          //  计算歌曲播放的进度
          //    (我当前播放时间-当前的开始时间) / (下一句歌词的开始时间-当前歌词的开始时间)
          lyricProgress = (self.currentTime - currentLyric.beginTime) / (nextLyric.beginTime - currentLyric.beginTime);
     }
     //  回调
     if ([self.delegate respondsToSelector:@selector(playerManager:didUpdateLyricProgress:withLyric:atIndex:)]) {
          [self.delegate playerManager:self didUpdateLyricProgress:lyricProgress withLyric:currentLyric atIndex:currentIndex];
     }
}



- (void) startUpdateMusicProgress {
     if (self.timer) {
          return;
     }
     self.timer = [NSTimer scheduledTimerWithTimeInterval:kUpdateMusicProgressInterval target:self selector:@selector(updateMusicProgress) userInfo:nil repeats:YES];
}

- (void) stopUpdateMusicProgress{
     
     [self.timer invalidate];
     self.timer = nil;
}



#pragma mark - 播放器的代理方法
/// 当播放结束的时候调用
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
     
     if ([self.delegate respondsToSelector:@selector(playerManager:didFinishedWithFlag:)]) {
          [self.delegate playerManager:self didFinishedWithFlag:flag];
     }
     
}





@end
