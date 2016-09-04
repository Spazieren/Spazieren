//
//  WMOAuthViewController.swift
//  Spazieren
//
//  Created by will on 16/9/3.
//  Copyright © 2016年 weimakejikonggu. All rights reserved.
//

import UIKit
import  SVProgressHUD
class WMOAuthViewController: UIViewController {
    private lazy var webView = UIWebView()
    override func loadView() {
        view = webView
        view.backgroundColor = UIColor.blue()
        // 设置webview  中的 scrollview 的  可滚动属性为 false
        // 新浪微博  服务器返回  的授权页面 默认就是手机全屏
        webView.scrollView.isScrollEnabled = false
        
        
        // 设置代理
        webView.delegate = self
        
        title = "Login WeiBo"
        //back
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "back", target: self, action: #selector(close), isBack: true)
        //autofill
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "autofill", target: self, action: #selector(autofill))
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //加载授权页面
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(WMAppKey)&redirect_uri=\(WMRedirectURl)"
        guard  let url = URL(string: urlString)else{
            return
        }
        
        let  request = URLRequest(url: url)
        webView.loadRequest(request)
        
    }
    
    
    //MARK:---close func
    @objc func close(){
        dismiss(animated: true, completion: nil)
        SVProgressHUD.dismiss()
    }
    
    //MARK:---autofill
    @objc func autofill(){
        //准备js  让 webview  执行
        let js = "document.getElementById('userId').value = '827078810@qq.com';" + "document.getElementById('passwd').value = '13972387577a';"
        //让webview执行js
        webView.stringByEvaluatingJavaScript(from: js)
        
    }
    
}
//MARK:---分类   让类遵守协议
extension WMOAuthViewController:UIWebViewDelegate{
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if request.url?.absoluteString?.hasPrefix(WMRedirectURl) == false {
            return true
            // 加载没有 该前缀的 请求
            
        }
        // 处理 有该前缀的  请求
        
        print("加载请求_____\(request.url?.absoluteString)")
        print("加载请求 ------------\(request.url?.query)")
        //判断该url 的 query  是否有code＝
        if request.url?.query?.hasPrefix("code=") == false{
            print("取消授权")
            close()
            return false
        }
        //处理符合条件的url   从query  拿出    取出 授权码
        
        let code = request.url?.query?.substring(from: "code=".endIndex) ?? ""
        //使用授权码 换取ACcesstoken
        WMNetworkManager.shared.loadAccessToken(code) { (isSuccess) in
            if !isSuccess{
                SVProgressHUD.showInfo(withStatus: "网络请求失败")
            }else{
                // SVProgressHUD.showInfoWithStatus("网络请求成功")
                // 跳转页面
                // 发送通知 不关心有没有 观察
                NotificationCenter.default().post(name: Notification.Name(rawValue: WMUserLoginSuccessedNotification), object: nil)
                
                
                // 关闭窗口
                self.close()
                
                
            }
            
        }
        
        print("获取授权码\(code)")
        
        
        // 该方法是将要加载 url  如果 获取到授权码 还是 别加载哪个百度的页面了
        return false
    }
    //MARK:---加载时显示小菊花   加载结束  菊花miss  UI
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    
}



