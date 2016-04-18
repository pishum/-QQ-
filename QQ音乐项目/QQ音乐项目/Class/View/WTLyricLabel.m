//
//  WTLyricLabel.m
//  QQ音乐项目
//
//  Created by a on 1/4/16.
//  Copyright © 2016年 wtt. All rights reserved.
//

#import "WTLyricLabel.h"

@implementation WTLyricLabel

-(void)drawRect:(CGRect)rect
{
     [super drawRect:rect];
     rect.size.width*=self.progress;
     
     [[UIColor greenColor] set];
     
     
     UIRectFillUsingBlendMode(rect, kCGBlendModeSourceIn);
     
}

-(void)setProgress:(CGFloat)progress
{
     _progress=progress;
     
     [self setNeedsDisplay];
}





@end
