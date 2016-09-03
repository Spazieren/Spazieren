//
//  AppDelegate.swift
//  微马
//
//  Created by will on 16/9/2.
//  Copyright © 2016年 微马科技控股有限公司. All rights reserved.
//

import UIKit
import UIKit
//import USerNotifications  ios 10  消息处理
import SVProgressHUD
import AFNetworking


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //向微信注册
        //FIXME:
        WXApi.registerApp("appid")
        
        
        return true
    }
    //
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        return WXApi.handleOpen(url, delegate: self)
    }
    
    //
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return WXApi.handleOpen(url, delegate: self)
    }
    
}

// 遵守微信协议
extension AppDelegate:WXApiDelegate{
    func onReq(_ req: BaseReq!) {
        <#code#>
    }
    
    
    
        
}
    
    
    
    
