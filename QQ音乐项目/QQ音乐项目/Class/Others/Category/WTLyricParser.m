//
//  WTLyricParser.m
//  QQ音乐项目
//
//  Created by a on 1/4/16.
//  Copyright © 2016年 wtt. All rights reserved.
//

#import "WTLyricParser.h"
#import "NSDateFormatter+Shared.h"
#import "WTLineLyric.h"

@implementation WTLyricParser

+(NSArray *) linelyricsWithLyricFileName:(NSString *)fileName
{
     NSString *filePath=[[NSBundle mainBundle] pathForResource:fileName ofType:nil];
     NSError *error=nil;
     NSString *lyricStr=[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
     if (error) {
          NSLog(@"读取歌词失败%@",error);
          return nil;
     }
     NSArray *lineLyricStrs=[lyricStr componentsSeparatedByString:@"\n"];
     NSString *pattern=@"\\[\\d{2}:\\d{2}.\\d{2}\\]";
     NSRegularExpression *regularExpression=[NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
     if (error) {
          NSLog(@"创建正则表达式失败:%@",error);
          return nil;
     }
     NSMutableArray *lineLyrics=[NSMutableArray array];
     NSDateFormatter *dataFormatter=[NSDateFormatter sharedDateFormatter];
     dataFormatter.dateFormat=@"[mm:ss.SS]";
     NSDate *initDate=[dataFormatter dateFromString:@"[00:00.00]"];
     
     for (NSString *lineLyricStr in lineLyricStrs) {
          NSArray<NSTextCheckingResult *>*results=[regularExpression matchesInString:lineLyricStr options:0 range:NSMakeRange(0, lineLyricStr.length)];
          NSRange lastRange=[results lastObject].range;
          NSString *content=[lineLyricStr substringFromIndex:lastRange.location +lastRange.length];
          
          for (NSTextCheckingResult *result in results) {
               NSString *timeStr=[lineLyricStr substringWithRange:result.range];
               NSDate *beginDate=[dataFormatter dateFromString:timeStr];
               NSTimeInterval beginTime=[beginDate timeIntervalSinceDate:initDate];
               
               WTLineLyric *lineLyric=[[WTLineLyric alloc]init];
               lineLyric.beginTime=beginTime;
               lineLyric.content=content;
               
               [lineLyrics addObject:lineLyric];
          }
     }
     
     NSSortDescriptor *sortDesc=[NSSortDescriptor sortDescriptorWithKey:@"beginTime" ascending:YES];
     [lineLyrics sortUsingDescriptors:@[sortDesc]];
     
     
     return lineLyrics;
}


@end



















