//
//  UIViewController+wmAddition.m
//
//  Created by will on 16/5/18.
//  Copyright © 2016年 up7042. All rights reserved.
//

#import "UIViewController+WMAddition.h"

@implementation UIViewController (WMAddition)

- (void)wm_addChildController:(UIViewController *)childController intoView:(UIView *)view  {
    
    [self addChildViewController:childController];
    
    [view addSubview:childController.view];
    
    [childController didMoveToParentViewController:self];
}

@end
