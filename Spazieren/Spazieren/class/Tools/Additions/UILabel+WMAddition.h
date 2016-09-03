//
//  UILabel+WMAddition.h
//
//  Created by will on 16/4/21.
//  Copyright © 2016年 up7042. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (WMAddition)

/// 创建文本标签
///
/// @param text     文本
/// @param fontSize 字体大小
/// @param color    颜色
///
/// @return UILabel
+ (instancetype)wm_labelWithText:(NSString *)text fontSize:(CGFloat)fontSize color:(UIColor *)color;

@end
