//
//  WTMusic.h
//  QQ音乐项目
//
//  Created by a on 1/4/16.
//  Copyright © 2016年 wtt. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
     HMMusicTypeLocal,
     HMMusicTypeRemote
} HMMusicType;

@interface WTMusic : NSObject

@property (nonatomic, copy) NSString *image;///<图片
@property (nonatomic, copy) NSString *lrc;///<歌词文件
@property (nonatomic, copy) NSString *mp3;///<音乐文件
@property (nonatomic, copy) NSString *name;///<歌曲的名称
@property (nonatomic, copy) NSString *singer;
@property (nonatomic, copy) NSString *album;///<专辑
@property (nonatomic, assign) HMMusicType type;

@end
