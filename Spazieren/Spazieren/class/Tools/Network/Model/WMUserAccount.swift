//
//  WMUserAccount.swift
//  Spazieren
//
//  Created by will on 16/9/3.
//  Copyright © 2016年 weimakejikonggu. All rights reserved.
//


import UIKit
import YYModel

private let accountFile :NSString = "useraccount.json"

class WMUserAccount: NSObject {
    var access_token:String?
    var uid :String?
    var expires_in:TimeInterval = 0{
        didSet{
            expiresDate = Date(timeIntervalSinceNow: expires_in)
        }
    }
    //access_token 过期日
    var expiresDate :Date?
    //用户昵称
    var screen_name:String?
    // 用户 头像（大）地址：180 *180
    var avatar_large :String?
    
    
    
    
    
    
    override var description: String{
        return yy_modelDescription()
    }
    // 重写父类的init方法
    
    override init() {
        super.init()
        
        //从磁盘加载  保存的文件  useraccount.json
        guard let path = accountFile.wm_appendDocumentDir(),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
            let dict = try? JSONSerialization.jsonObject(with: data as Data, options: []) as? [String:AnyObject]
            else{
                return
        }
        //使用保存在沙盒中的字典设置   登录的属性   登陆一次 下次 进来就 直接进入  home
        // 使用沙盒中的useraccount.json  给打开的用户设置属性 决定时加载 登录 还是直接到home
        
        yy_modelSet(with: dict ?? [:])
        
        //  token  过期处理   expires_date  和 当前日期的 比较
        //expiresDate = NSDate(timeIntervalSinceNow: -3600*24*3)
        //print(expiresDate)
        
        if expiresDate?.compare(Date()) != .orderedDescending{
            print("out of date")
            //清空token  uid
            access_token = nil
            uid = nil
            //删除  useraccount.json文件
            //path 为 当初 保存 useraccount.json 时的  路径
            _ = try? FileManager.default().removeItem(atPath: path)
            
        }else{
            print("available")
        }
        
    }
    
    
    //save
    func  saveAccount(){
        var dict = (self.yy_modelToJSONObject() as? [String:AnyObject]) ?? [:]
        dict.removeValue(forKey: "expires_in")
        guard  let data = try?  JSONSerialization.data(withJSONObject: dict, options: []),
            filePath = accountFile.wm_appendDocumentDir()else{
                return
        }
        
        
        (data as NSData).write(toFile: filePath, atomically: true)
        print("ok \(filePath)")
        
    }
    
    
}
