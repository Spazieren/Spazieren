//
//  NSString+WMPath.h
//
//  Created by will on 16/6/10.
//  Copyright © 2016年 up7042. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (WMPath)

/// 给当前文件追加文档路径
- (NSString *)wm_appendDocumentDir;

/// 给当前文件追加缓存路径
- (NSString *)wm_appendCacheDir;

/// 给当前文件追加临时路径
- (NSString *)wm_appendTempDir;

@end
