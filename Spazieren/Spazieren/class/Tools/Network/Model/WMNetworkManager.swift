//
//  WMNetworkManager.swift
//  Spazieren
//
//  Created by will on 16/9/3.
//  Copyright © 2016年 weimakejikonggu. All rights reserved.
//

import UIKit
import  AFNetworking
//swift 的枚举支持任意数据类型 oc 只支持整数
enum WMHTTPMethod {
    case get
    case post
    
}

class WMNetworkManager:AFHTTPSessionManager{
    //单例 内存中 初始化后 独一份  不可更改  初始化后变为只读
    static let shared:WMNetworkManager = {
        let instance = WMNetworkManager()
        // 设置 响应反序列化 支持的类型
        instance.responseSerializer.acceptableContentTypes?.insert("text/plain")
        return instance
    }()
    
    //懒加载属性
    lazy var userAccount = WMUserAccount()
    
    
    var userLogon:Bool{
        return   userAccount.access_token != nil
    }
    
    //MARK:---专门负责拼接token 的网络请求的方法
    func tokenRequest(_ method:WMHTTPMethod = .get,URLString:String,params:[String:AnyObject]?,completion:(json:AnyObject?,isSuccess:Bool)->()){
        
        //处理token
        // 判断参数字典 是否存在  如果为nil  则需要 新建一个字典
        // 程序 在运行 是  token  一般不会为nil  手动 改代码可以做到
        guard let token =  userAccount.access_token  else {
            //FIXME  发送通知  提示 用户登录
            print("没有token,需要登录")
            NotificationCenter.default().post(name: Notification.Name(rawValue: WMUserShouldLoginNotification), object: nil)
            
            completion(json: nil, isSuccess: false)
            
            return
        }
        
        var params = params
        if params == nil{
            // 实例化
            params = [String:AnyObject]()
        }
        
        // 设置字典参数   代码载此处  字典一定有值  可抢劫包
        params!["access_token"] = token
        
        
        
        //   调用发起真正的网络请求的 方法
        request(method, URLString: URLString, params: params, completion: completion)
    }
    
    
    
    //MARK:---一个方法 封装post get
    // 1级封装
    
    func request(_ method:WMHTTPMethod = .get,URLString:String,params:[String:AnyObject]?,completion:(json:AnyObject?,isSuccess:Bool)->()){
        
        
        let success = {(task:URLSessionDataTask,json:AnyObject?)->() in
            completion(json: json, isSuccess: true)
            
        }
        
        //对于没有 通过审核的   程序    c程序呦访问限制  有的时候  403 就是被限制了  ，或者 改密码了
        let failure = {(task:URLSessionDataTask?,error:NSError)-> () in
            
            // 处理403  状况
            if (task?.response as? HTTPURLResponse)?.statusCode == 403{
                print("您的账号过期了，请重新登录")
                //FIXME  发送通知 本方法  不知道被谁调用  谁接收到通知  谁处理
                NotificationCenter.default().post(name: Notification.Name(rawValue: WMUserShouldLoginNotification), object: "badtoken")
                
                
            }
            print("网络错误\(error)")
            completion(json: nil, isSuccess: false)
            
        }
        
        
        if method == .get{
            get(URLString, parameters: params, progress: nil, success: success, failure: failure)
        }else{
            post(URLString, parameters: params, progress: nil, success: success, failure: failure)
        }
    }
    
}



