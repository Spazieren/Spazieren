//
//  NSObject+WMRuntime.h
//
//  Created by will on 16/6/11.
//  Copyright © 2016年 up7042. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (WMRuntime)

/// 使用字典数组创建当前类对象的数组
///
/// @param array 字典数组
///
/// @return 当前类对象的数组
+ (NSArray *)wm_objectsWithArray:(NSArray *)array;

/// 返回当前类的属性数组
///
/// @return 属性数组
+ (NSArray *)wm_propertiesList;

/// 返回当前类的成员变量数组
///
/// @return 成员变量数组
+ (NSArray *)wm_ivarsList;

@end
