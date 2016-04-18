//
//  NSObject+Model.h
//  预习04-菜谱
//
//  Created by 传智.小飞燕 on 15/12/1.
//  Copyright © 2015年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Model)

/**
 *   单层字典转模型
 */
+ (instancetype) objectWithDictioanary:(NSDictionary *) dict;

/**
 *  把plist转数组
 */
+ (NSMutableArray *) objectArrayWithPlistName:(NSString *) plistName;

/// 字典数组转模型数组
+ (NSMutableArray *) objectArrayWithDictArray:(NSArray *) dictArray;

@end
