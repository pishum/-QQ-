//
//  ViewController.m
//  QQ音乐项目
//
//  Created by a on 31/3/16.
//  Copyright © 2016年 wtt. All rights reserved.
//
#import <Masonry.h>
#import "ViewController.h"
#import "WTMusic.h"
#import "NSObject+Model.h"
#import "WTPlayerManager.h"
#import "WTLyricLabel.h"
#import "WTLineLyric.h"
#import "WTLyricView.h"
#import "WTLyricSlider.h"
#import <MediaPlayer/MediaPlayer.h>

static NSTimeInterval const kUpdateMusicProgressInterval = 0.05;

@interface ViewController ()<WTPlayerManagerDelegate,WTLyricViewDelegate>

#pragma mark - 横屏

@property (weak, nonatomic) IBOutlet WTLyricLabel *hLyricLabel;

@property (weak, nonatomic) IBOutlet UIImageView *hCenterImageView;

#pragma mark -竖屏


@property (weak, nonatomic) IBOutlet UIView *vCenterView;

@property (weak, nonatomic) IBOutlet WTLyricView *LyricView;

@property (weak, nonatomic) IBOutlet UILabel *albumLabel;

@property (weak, nonatomic) IBOutlet WTLyricLabel *vLyricLabel;

@property (weak, nonatomic) IBOutlet UILabel *singerLabel;

@property (weak, nonatomic) IBOutlet UIImageView *vCenterImageView;

#pragma  mark -通用

@property (weak, nonatomic) IBOutlet UIImageView *bgView;

@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UISlider *musicSlider;

@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *durationLabel;


#pragma mark - 私有属性
@property (nonatomic,strong) NSArray <WTMusic *> *musics;
@property (nonatomic,assign) NSInteger currentMusicIndex;

@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) WTPlayerManager *playerManager;

@end






@implementation ViewController

- (void)viewDidLoad {
     [super viewDidLoad];
     self.playerManager=[WTPlayerManager sharedPlayerManager];
     self.playerManager.delegate=self;
     self.LyricView.delegate=self;
     
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lyricSliderplayNotification:) name:WTLyricSliderPlayNotification object:nil];
     
     [self addBlurEffect];
     [self changeMusic];
     
}

-(void)viewWillLayoutSubviews
{
     [super viewWillLayoutSubviews];
     self.vCenterImageView.layer.cornerRadius=self.vCenterImageView.bounds.size.width *0.5;
     self.vCenterImageView.layer.masksToBounds=YES;
     
}



- (IBAction)play:(id)sender {
     
     if (!self.playBtn.selected) {
          [self.playerManager play];
   
     }else
     {
          [self.playerManager pause];
     }
     
     self.playBtn.selected=!self.playBtn.selected;
}

- (IBAction)preView {
     
     if (self.currentMusicIndex==0) {
          self.currentMusicIndex=self.musics.count-1;
     }else
     {
          self.currentMusicIndex--;
     }
    
     [self changeMusic];
     [self.playerManager play];
     self.playBtn.selected=!self.playBtn.selected;
}

- (IBAction)next:(id)sender {
     if (self.currentMusicIndex==self.musics.count-1) {
          
          self.currentMusicIndex=0;
     }else
     {
          self.currentMusicIndex++;
     }
    
     
     [self changeMusic];
     [self.playerManager play];
     self.playBtn.selected=!self.playBtn.selected;
}

- (IBAction)changeCurrentTimer:(id)sender {
     self.playerManager.currentTime=self.musicSlider.value*self.playerManager.duration;
}



-(void) addBlurEffect
{
     
     UINavigationBar *navBar=[[UINavigationBar alloc] init];
     navBar.barStyle=UIBarStyleBlack;
     
     [self.bgView addSubview:navBar];
     
     [navBar mas_makeConstraints:^(MASConstraintMaker *make) {
          
          make.edges.equalTo(self.bgView);
     }];
     
}

-(void) changeMusic
{
     
     WTMusic *music=self.musics[self.currentMusicIndex];
     self.vLyricLabel.text=music.name;
     self.hLyricLabel.text=music.name;
     self.title=music.name;
     self.singerLabel.text=music.singer;
     
     UIImage *img=[UIImage imageNamed:music.image];
     self.bgView.image=img;
     self.vCenterImageView.image=img;
     self.hCenterImageView.image=img;
     
     self.albumLabel.text=music.album;
     
     [self.playerManager prepareToPlayWithMusic:music];
     
      self.LyricView.lyrics=self.playerManager.lineLyrics;
       self.durationLabel.text=[self stringFromTime:self.playerManager.duration];
    
      self.playBtn.selected=NO;
}

-(NSString *)stringFromTime:(NSTimeInterval)time
{
     int minute=time/60;
     int scound=(int)time%60;
     return [NSString stringWithFormat:@"%02d:%02d",minute,scound];
}

-(void)playerManager:(WTPlayerManager *)playerManager didUpdateProgressWithInterval:(NSTimeInterval)interval
{
     self.currentTimeLabel.text=[self stringFromTime:self.playerManager.currentTime];
     
     self.musicSlider.value=self.playerManager.currentTime/self.playerManager.duration;
     
     self.vCenterImageView.transform=CGAffineTransformRotate(self.vCenterImageView.transform, M_PI_4*kUpdateMusicProgressInterval*0.05);
     
}

-(void)playerManager:(WTPlayerManager *)playerManager didUpdateLyricProgress:(CGFloat)progress withLyric:(WTLineLyric *)lineLyric atIndex:(NSInteger)index
{
     self.hLyricLabel.text=lineLyric.content;
     
     self.vLyricLabel.text=lineLyric.content;
     
     self.hLyricLabel.progress=progress;
     self.vLyricLabel.progress=progress;
     
     //给歌词视图设置当前播放的索引
     self.LyricView.currentLyricIndex=index;
     self.LyricView.progress=progress;
     
     [self updateLockScreen:lineLyric];
     
}

-(void) updateLockScreen:(WTLineLyric *)lineLyric
{
     WTMusic *music=self.musics[self.currentMusicIndex];
     
     MPNowPlayingInfoCenter *defailtCenter=[MPNowPlayingInfoCenter defaultCenter];
     
     UIImage *image=[UIImage imageNamed:music.image];
     image=[self imageForLockScreenBgImage:image lyriccontent:lineLyric.content];
     MPMediaItemArtwork *artwork=[[MPMediaItemArtwork alloc]initWithImage:image];
     defailtCenter.nowPlayingInfo=@{
                                    MPMediaItemPropertyAlbumTitle:music.album,
                                    MPMediaItemPropertyArtist:music.singer,
                                    MPMediaItemPropertyArtwork:artwork,
                                    MPMediaItemPropertyPlaybackDuration:@(self.playerManager.duration),
                                    MPMediaItemPropertyTitle:music.name,
                                    MPNowPlayingInfoPropertyElapsedPlaybackTime:@(self.playerManager.currentTime)
                                    
                                    };
}

-(void)remoteControlReceivedWithEvent:(UIEvent *)event
{
     switch (event.subtype) {
          case UIEventSubtypeRemoteControlPlay:
          case UIEventSubtypeRemoteControlPause:
               [self play:nil];
               
               break;
          case UIEventSubtypeRemoteControlNextTrack:
               [self next:nil];
               break;
          case UIEventSubtypeRemoteControlPreviousTrack:
               [self preView];
               break;
          default:
               break;
     }
   
}



-(UIImage *)imageForLockScreenBgImage:(UIImage *)bgImage lyriccontent:(NSString *)content
{
     UIImage *lyricBgImage=[UIImage imageNamed:@"lock_lyric_mask"];
     CGFloat imageW=[UIScreen mainScreen].bounds.size.width*0.8;
     UIGraphicsBeginImageContext(CGSizeMake(imageW, imageW));
     [bgImage drawInRect:CGRectMake(0, 0, imageW, imageW)];
     
     CGFloat lyricHeight=40;
     CGFloat lyricY=imageW-lyricHeight;
     CGRect lyricRect=CGRectMake(0, lyricY, imageW, lyricHeight);
     [lyricBgImage drawInRect:lyricRect];
     [[UIColor whiteColor] set];
     
     [content drawInRect:lyricRect withFont:[UIFont systemFontOfSize:18] lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
     UIImage *lyricImage=UIGraphicsGetImageFromCurrentImageContext();
     
     UIGraphicsEndImageContext();
     
     return lyricImage;
     
}






/// 当没有错误结束的时候，自动播放下一曲
- (void) playerManager:(WTPlayerManager *)playerManager didFinishedWithFlag:(BOOL)isSuccess {
     if (isSuccess) {
          //      下一曲
          [self next:nil];
     }
}


#pragma mark -LyricView代理方法
-(void)lyricView:(WTLyricView *)lyricView hScrollViewDidChangeProgress:(CGFloat)progress
{
     self.vCenterView.alpha=1-progress;
     
     
}

-(void) lyricSliderplayNotification:(NSNotification *)notification
{
     WTLyricSlider *lyricSlider=notification.object;
     
     self.playerManager.currentTime=lyricSlider.beginTime;
}




-(void)stopUpdateMusicProgress
{
     [self.timer invalidate];
     
     self.timer=nil;
}





//懒加载
-(NSArray <WTMusic *> *)musics{
     
     if (_musics==nil) {
          _musics=[WTMusic objectArrayWithPlistName:@"mlist"];
     }
     return _musics;
}



@end








