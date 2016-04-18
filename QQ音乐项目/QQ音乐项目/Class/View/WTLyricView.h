//
//  WTLyricView.h
//  QQ音乐项目
//
//  Created by a on 2/4/16.
//  Copyright © 2016年 wtt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTLineLyric.h"
@class WTLyricView;

@protocol WTLyricViewDelegate <NSObject>

@optional
-(void)lyricView:(WTLyricView *) lyricView hScrollViewDidChangeProgress:(CGFloat)progress;

@end


@interface WTLyricView : UIView

@property (nonatomic,strong) NSArray <WTLineLyric *>* lyrics;
@property (nonatomic,assign) CGFloat rowHeight;

@property (nonatomic,assign) NSInteger currentLyricIndex;
@property (nonatomic,assign) CGFloat progress;


@property (nonatomic,weak) id<WTLyricViewDelegate> delegate;
@end




















