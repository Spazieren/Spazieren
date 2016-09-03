//
//  NSString+WMBase64.m
//
//  Created by will on 16/6/7.
//  Copyright © 2016年 up7042. All rights reserved.
//

#import "NSString+WMBase64.h"

@implementation NSString (WMBase64)

- (NSString *)wm_base64Encode {
    
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    return [data base64EncodedStringWithOptions:0];
}

- (NSString *)wm_base64Decode {
    
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:0];
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
