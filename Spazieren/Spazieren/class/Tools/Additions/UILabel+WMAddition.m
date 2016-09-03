//
//  UILabel+WMAddition.m
//
//  Created by will on 16/4/21.
//  Copyright © 2016年 up7042. All rights reserved.
//

#import "UILabel+WMAddition.h"

@implementation UILabel (WMAddition)

+ (instancetype)wm_labelWithText:(NSString *)text fontSize:(CGFloat)fontSize color:(UIColor *)color {
    UILabel *label = [[self alloc] init];
    
    label.text = text;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = color;
    label.numberOfLines = 0;
    
    [label sizeToFit];
    
    return label;
}

@end
