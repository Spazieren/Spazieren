//
//  UIScreen+WMAddition.h
//
//  Created by will on 16/5/17.
//  Copyright © 2016年 up7042. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScreen (WMAddition)

/// 屏幕宽度
+ (CGFloat)wm_screenWidth;
/// 屏幕高度
+ (CGFloat)wm_screenHeight;
/// 分辨率
+ (CGFloat)wm_scale;

@end
