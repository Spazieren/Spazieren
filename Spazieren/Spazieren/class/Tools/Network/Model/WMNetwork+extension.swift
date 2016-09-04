//
//  WMNetwork+extension.swift
//  Spazieren
//
//  Created by will on 16/9/3.
//  Copyright © 2016年 weimakejikonggu. All rights reserved.
//

import Foundation

//MARK:---/封装

extension WMNetworkManager{
    //MARK:---二级封装
    
    //二级封装
    func statusList(_ since_id:Int64 = 0,max_id:Int64 = 0,completion:(list:[[String:AnyObject]]?,isSuccess:Bool)->()){
        
        
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        let params = ["since_id":"\(since_id)","max_id":"\(max_id > 0 ? max_id - 1 : 0)"]
        // 将 int64  转为字符串  字符串  就可以转为anyobject 了  url 参数  最后也是一字符串拼接在 url 上
        //        let params = ["access_token":"2.00HGpdNGWfF2zDd11093c12cQhH6UE"]
        //swift INt  可以转换为 anyobject  但是 INt64 不可以  用 as  也不行
        tokenRequest(URLString: urlString, params: params) { (json, isSuccess) in
            let result = json?["statuses"] as?[[String:AnyObject]]
            completion(list: result, isSuccess: isSuccess)
        }
    }
    //MARK:---返回用户微博的未读数辆］
    
    func unreadCount(_ completion:(count:Int)->()){
        guard let uid = userAccount.uid else{
            return
        }
        let urlString = "https://rm.api.weibo.com/2/remind/unread_count.json"
        let params = ["uid":uid]
        tokenRequest(URLString: urlString, params:params) { (json, isSuccess) in
            
            let dict = json as?[String:AnyObject]
            let  count = dict?["status"] as?Int
            completion(count: count ?? 0)
            
        }
    }
}
//MARK:---用户信息 获取

extension WMNetworkManager{
    //当用户一登录  立即加载
    func loadUserInfo(_ completion:(dict:[String:AnyObject])->()){
        let urlString = "https://api.weibo.com/2/users/show.json"
        guard let uid = userAccount.uid else{
            return
        }
        let params = ["uid":uid]
        // 发起网络请求
        tokenRequest(URLString: urlString, params: params) { (json, isSuccess) in
            
            // 回调
            completion(dict: json as? [String:AnyObject] ?? [:])
        }
    }
}


//MARK:---网络授权相关的方法
extension WMNetworkManager{
    func loadAccessToken(_ code:String,completion:(isSuccess:Bool)->()){
        let urlString = "https://api.weibo.com/oauth2/access_token"
        let params = ["client_id":WMAppKey,
                      "client_secret":WMAPPSecret,
                      "grant_type":"authorization_code",
                      "code":code,
                      "redirect_uri":WMRedirectURl
        ]
        
        request(WMHTTPMethod.post, URLString: urlString, params: params) { (json, isSuccess) in
            
            // 使用 字典 给 userAccountde属性   此处 如果用  kvc   由于 字典中 有的键  userAccount   并没有    不会完美匹配  会崩掉
            
            self.userAccount.yy_modelSet(with: (json as? [String:AnyObject]) ?? [:])
            //1
            print(self.userAccount)
            
            // 加载当前用户信息
            self.loadUserInfo({ (dict) in
                
                // 使用 用户信息(users/show返回的)字典 设置用户账户信息(昵称 和头像)
                self.userAccount.yy_modelSet(with: dict)
                
                //保存到沙盒
                self.userAccount.saveAccount()
                //2
                print(self.userAccount)
                
                // 用户信息 加载完成  再完成回调  两个不同的网络请求
                completion(isSuccess: isSuccess)
                
                
                
            })
            
            
        }
    }
}







