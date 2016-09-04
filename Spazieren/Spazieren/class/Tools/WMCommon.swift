//
//  WeiBoCommon.swift
//  传智微博
//
//  Created by will on 8/19/16.
//  Copyright © 2016 connected. All rights reserved.
//

import Foundation
import UIKit



//MARK:---应用程序信息
let WMAppKey = "3654781674"
let WMAPPSecret = "34f6e2685e6afe973cf1e12e90647d17"
let WMRedirectURl = "http://baidu.com"

//MARK:---全局通知定义
// 用户需要通知
let  WMUserShouldLoginNotification = "WMUserShouldLoginNotification"
let  WMUserLoginSuccessedNotification = "WMUserLoginSuccessedNotification"

//MARK:微博配图视图常量
// 配图视图外侧的间距
let WMStatusPictureViewOutterMargin = CGFloat(12)
let  WMStatusPictureViewInnerMargin = CGFloat(3)
    // 1.计算配图视图宽度
let WMStatusPictureViewWidth = UIScreen.wm_screenWidth() - 2 * WMStatusPictureViewOutterMargin
    //计算每个默认Item 的 宽度
let WMStatusPicturesItemWidth =  (WMStatusPictureViewWidth - 2 * WMStatusPictureViewInnerMargin)/3
   
