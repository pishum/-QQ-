//
//  WTLyricView.m
//  QQ音乐项目
//
//  Created by a on 2/4/16.
//  Copyright © 2016年 wtt. All rights reserved.
//
#import <Masonry.h>
#import "WTLyricView.h"
#import "WTLyricLabel.h"
#import "WTLyricSlider.h"

@interface WTLyricView ()<UIScrollViewDelegate>

@property (nonatomic,weak) UIScrollView *hScrollView;

@property (nonatomic,weak) UIScrollView *vScrollView;

@property (nonatomic,weak) WTLyricSlider  *lyricSlider;

@property (nonatomic,strong) NSMutableArray *lyricLabels;

@end

@implementation WTLyricView

-(instancetype)initWithFrame:(CGRect)frame
{
     if (self=[super initWithFrame:frame]) {
          [self setupUI];
     }
     return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
     if (self=[super initWithCoder:aDecoder]) {
          [self setupUI];
     }
     return self;
}

-(void)setupUI
{
     self.lyricLabels=[NSMutableArray array];
     UIScrollView *hScrollView=[[UIScrollView alloc]init];
     [self addSubview:hScrollView];
     self.hScrollView=hScrollView;
     
     UIScrollView *vScrollView=[[UIScrollView alloc]init];
     [hScrollView addSubview:vScrollView];
     self.vScrollView=vScrollView;
     
     WTLyricSlider  *lyricSlider=[WTLyricSlider lyricSlider];
     [self addSubview:lyricSlider];
     self.lyricSlider=lyricSlider;
     lyricSlider.backgroundColor=[UIColor clearColor];
     
     [hScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
          make.edges.equalTo(self);
     }];
     hScrollView.backgroundColor=[UIColor clearColor];
     
     CGFloat screenW=[UIScreen mainScreen].bounds.size.width;
     
     [vScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
          make.width.mas_equalTo(screenW);
          make.left.equalTo(hScrollView).offset(screenW);
          make.top.height.equalTo(self);
     }];
     
     [lyricSlider mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.right.centerY.equalTo(self);
     }];
     
     vScrollView.backgroundColor=[UIColor clearColor];
     
     hScrollView.contentSize=CGSizeMake(2*screenW, 0);
     hScrollView.showsHorizontalScrollIndicator=NO;
     hScrollView.pagingEnabled=YES;
     hScrollView.bounces=NO;
     hScrollView.delegate=self;
     
     lyricSlider.hidden=YES;
     vScrollView.delegate=self;
     
}

-(void)layoutSubviews
{
     [super layoutSubviews];
     CGFloat offset=(self.bounds.size.height-self.rowHeight)*0.5;
     self.vScrollView.contentInset=UIEdgeInsetsMake(offset, 0, offset, 0);
     self.vScrollView.contentOffset=CGPointMake(0, -offset);
     
}
-(void)setLyrics:(NSArray<WTLineLyric *> *)lyrics
{
     [self.vScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
     [self.lyricLabels removeAllObjects];
     _lyrics=lyrics;
     self.vScrollView.contentSize=CGSizeMake(0, self.rowHeight*lyrics.count);
     
     [lyrics enumerateObjectsUsingBlock:^(WTLineLyric * _Nonnull lineLyric, NSUInteger idx, BOOL * _Nonnull stop) {
          WTLyricLabel *lineLabel=[[WTLyricLabel alloc]init];
          [self.vScrollView addSubview:lineLabel];
          [self.lyricLabels addObject:lineLabel];
          [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
               make.top.equalTo(self.vScrollView).offset(self.rowHeight*idx);
               make.centerX.equalTo(self.vScrollView);
               make.height.mas_equalTo(self.rowHeight);
          }];
          lineLabel.text=lineLyric.content;
          lineLabel.textAlignment=NSTextAlignmentCenter;
          lineLabel.textColor=[UIColor whiteColor];
     }];
     
}

-(void)setCurrentLyricIndex:(NSInteger)currentLyricIndex
{
     if (_currentLyricIndex==currentLyricIndex) {
          return;
     }
     WTLyricLabel *preLyricLabel=self.lyricLabels[_currentLyricIndex];
     preLyricLabel.font=[UIFont systemFontOfSize:17];
     preLyricLabel.progress=0;
     _currentLyricIndex=currentLyricIndex;
     WTLyricLabel *lyricLabel=self.lyricLabels[currentLyricIndex];
     lyricLabel.font=[UIFont systemFontOfSize:20];
     [self scrollToIndex:currentLyricIndex];
}


-(void)setProgress:(CGFloat)progress
{
     _progress=progress;
     WTLyricLabel *lyricLabel=self.lyricLabels[self.currentLyricIndex];
     lyricLabel.progress=progress;
     
}

-(void)scrollToIndex:(NSInteger)index
{
     if (self.vScrollView.isDragging) {
          return;
     }
     
     CGFloat offsetY=self.rowHeight*index-self.vScrollView.contentInset.top;
     
     [self.vScrollView setContentOffset:CGPointMake(0, offsetY) animated:YES];
     
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
     if (scrollView==self.vScrollView) {
          self.lyricSlider.hidden=NO;
     }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
     if (scrollView==self.vScrollView) {
          
          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               if (!self.vScrollView.isDragging) {
                    self.lyricSlider.hidden=YES;
               }
          });
          
          
          
     }
    
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
     if (self.hScrollView==scrollView) {
          // 计算滚动进度
          CGFloat progress  = scrollView.contentOffset.x / scrollView.bounds.size.width;
          if ([self.delegate respondsToSelector:@selector(lyricView:hScrollViewDidChangeProgress:)]) {
               [self.delegate lyricView:self hScrollViewDidChangeProgress:progress];
          }
     }else
     {
          NSInteger index=(self.vScrollView.contentOffset.y+self.vScrollView.contentInset.top)/self.rowHeight;
          if (index<0||index>self.lyrics.count-1) {
               return;
          }
          
          NSTimeInterval beginTime=self.lyrics[index].beginTime;
          self.lyricSlider.beginTime=beginTime;
     }
}


-(CGFloat)rowHeight
{
     if (_rowHeight==0) {
          return 44;
     }
     return _rowHeight;
}


@end














