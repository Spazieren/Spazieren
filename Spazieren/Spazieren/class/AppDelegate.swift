//
//  AppDelegate.swift
//
//  Created by will on 8/15/16.
//  Copyright © 2016 connected. All rights reserved.
//

import UIKit
//import USerNotifications  ios 10  消息处理
import SVProgressHUD
import AFNetworking
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        setupAdditions()
        
        
        
        window = UIWindow()
        window?.backgroundColor = UIColor.blue()
        window?.rootViewController = WMMainViewController()
        window?.makeKeyAndVisible()
        // 加载 远程json
        loadAppInfo()
        return true
    }
    
    
}

//MARK:---设置程序额外信息
extension AppDelegate{
    private func setupAdditions(){
        // 设置 SVProgressHUD 最小解除时间
        SVProgressHUD.setMinimumDismissTimeInterval(1)
        //设置网络加载指示器
        AFNetworkActivityIndicatorManager.shared().isEnabled = true
        //设置用户授权显示通知
        
        // 取得用户授权  显示 通知（上方的提示条  声音  appiconbadgenumber）
        let notifySetting = UIUserNotificationSettings(types: [.alert,.badge,.sound], categories: nil)
        UIApplication.shared().registerUserNotificationSettings(notifySetting)
        
        
    }
}









//MARK:---从服务器加载APP信息
extension AppDelegate{
    //MARK:---从服务器下载app 信息  方法
    
    private func loadAppInfo(){
        //模拟异步
        
        DispatchQueue.global(attributes: DispatchQueue.GlobalAttributes(rawValue: UInt64(0))).async {
            //url
            let url = Bundle.main().urlForResource("main.json", withExtension: nil)
            //data
            let data = try? Data(contentsOf: url!)
            //保存路径  写入磁盘
            let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let jsonPath = (docDir as NSString).appendingPathComponent("main.json")
            // 写入沙盒  等待程序下一次 开启时使用
            _ = try? data?.write(to: URL(fileURLWithPath: jsonPath), options: [.dataWritingAtomic])
            print("应用程序加载完成\(jsonPath)")
            
        }
        
        
    }
}


