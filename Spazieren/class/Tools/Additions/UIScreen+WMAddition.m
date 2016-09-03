//
//  UIScreen+WMAddition.m
//
//  Created by will on 16/5/17.
//  Copyright © 2016年 up7042. All rights reserved.
//

#import "UIScreen+WMAddition.h"

@implementation UIScreen (WMAddition)

+ (CGFloat)wm_screenWidth {
    return [UIScreen mainScreen].bounds.size.width;
}

+ (CGFloat)wm_screenHeight {
    return [UIScreen mainScreen].bounds.size.height;
}

+ (CGFloat)wm_scale {
    return [UIScreen mainScreen].scale;
}

@end
