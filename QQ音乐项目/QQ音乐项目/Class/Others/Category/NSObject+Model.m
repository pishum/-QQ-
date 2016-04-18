//
//  NSObject+Model.m
//  预习04-菜谱
//
//  Created by 传智.小飞燕 on 15/12/1.
//  Copyright © 2015年 itcast. All rights reserved.
//

#import "NSObject+Model.h"
#import <objc/runtime.h>

@implementation NSObject (Model)

+ (instancetype)objectWithDictioanary:(NSDictionary *)dict
{
    id obj = [[self alloc] init];
    [obj setValuesForKeysWithDictionary:dict];
    return obj;
}

/// 字典数组转模型数组
+ (NSMutableArray *) objectArrayWithDictArray:(NSArray *) dictArray{
    //  字典数组转模型数组
    NSMutableArray *arrayM = [NSMutableArray array];
    
    for (NSDictionary *dict in dictArray) {
        id obj = [self objectWithDictioanary:dict];
        [arrayM addObject:obj];
    }
    
    return arrayM;
}


+ (NSMutableArray *)objectArrayWithPlistName:(NSString *)plistName
{
//  获取路径
    NSString *filePath = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
//  把plist转换为数组
    NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
    
//  字典数组转模型数组
    return [self objectArrayWithDictArray:array];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{

//    NSLog(@"%@----%@",key,value);
}


//
//- (NSArray *) propertys {
//    unsigned int count = 0;
////获取属性的列表(这个指向属性列表的指针,注意使用完毕后必须使用free函数进行释放)
//    objc_property_t *propertyList =  class_copyPropertyList([self class], &count);
////  属性数组
//    NSMutableArray *propertyArray = [NSMutableArray array];
//    
//// 遍历属性数组
//    for(int i=0;i<count;i++)
//    {
//        //取出每一个属性
//        objc_property_t property = propertyList[i];
//        //获取每一个属性的变量名
//        const char* propertyName = property_getName(property);
//        
//        NSString *proName = [[NSString alloc] initWithCString:propertyName encoding:NSUTF8StringEncoding];
//        
//        [propertyArray addObject:proName];
//    }
//    //c语言的函数，所以要去手动的去释放内存
//    free(propertyList);
//    
//    return propertyArray.copy;
//}
//
//
//- (NSString *)description{
////    NSLog(@"%@",[self propertys]);
//    return [self dictionaryWithValuesForKeys:[self propertys]].description;
//}


@end
