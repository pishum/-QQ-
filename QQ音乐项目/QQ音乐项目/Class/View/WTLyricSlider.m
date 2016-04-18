//
//  WTLyricSlider.m
//  QQ音乐项目
//
//  Created by a on 2/4/16.
//  Copyright © 2016年 wtt. All rights reserved.
//

#import "WTLyricSlider.h"
#import "WTFormattor.h"

@interface WTLyricSlider ()
@property (weak, nonatomic) IBOutlet UILabel *lyricLabel;


@end

@implementation WTLyricSlider

+(instancetype)lyricSlider
{
     return [[[NSBundle mainBundle] loadNibNamed:@"WTLyricSlider" owner:nil options:nil] lastObject];
     
}

-(void)setBeginTime:(NSTimeInterval)beginTime
{
     _beginTime=beginTime;
     
     self.lyricLabel.text=[WTFormattor stringFromTime:beginTime];
     
}

- (IBAction)play:(id)sender {
     
     [[NSNotificationCenter defaultCenter] postNotificationName:WTLyricSliderPlayNotification object:self];
}





@end















