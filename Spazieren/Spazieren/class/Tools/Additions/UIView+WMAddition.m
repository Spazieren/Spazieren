//
//  UIView+WMAddition.m
//
//  Created by will on 16/5/11.
//  Copyright © 2016年 up7042. All rights reserved.
//

#import "UIView+WMAddition.h"

@implementation UIView (WMAddition)

- (UIImage *)wm_snapshotImage {

    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0);
    
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return result;
}

@end
