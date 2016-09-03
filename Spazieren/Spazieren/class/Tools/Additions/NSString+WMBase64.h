//
//  NSString+WMBase64.h
//
//  Created by will on 16/6/7.
//  Copyright © 2016年 up7042. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (WMBase64)

/// 对当前字符串进行 BASE 64 编码，并且返回结果
- (NSString *)wm_base64Encode;

/// 对当前字符串进行 BASE 64 解码，并且返回结果
- (NSString *)wm_base64Decode;

@end
