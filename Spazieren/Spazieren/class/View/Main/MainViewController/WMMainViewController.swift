//
//  WMMainViewController.swift
//  微马
//
//  Created by will on 16/9/2.
//  Copyright © 2016年 微马科技控股有限公司. All rights reserved.
//

import UIKit
import SVProgressHUD


class WMMainViewController: UITabBarController {
    //定时器
    private var timer:Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupchildViewControllers()
        //setupRunButton()

       
    }
    //  运行时机制访问到
    //MARK:---run按钮监听方法----
    /*@objc private func composeStataus(){
        print("撰写按钮")
        //FIXME:0 判断是否登录
        //1.实例化视图
        let v = WBComposeTypeView.composeTypeView()
        
        //显示视图  注意 闭包的 循环引用
        v.show { [weak v](clsName) in
            print(clsName)
            //展现撰写控制器
            guard  let clsName = clsName,
                cls = NSClassFromString(Bundle.main().namespace + "." + clsName) as? UIViewController.Type else{
                    // 没有上面的    就直接 返回  微博home
                    v?.removeFromSuperview()
                    return
            }
            let vc = cls.init()
            let nav = UINavigationController(rootViewController: vc)
            
            self.present(nav, animated: true, completion: {
                v?.removeFromSuperview()
            })
            
        }

    
    
    
    //MARK:run 按钮的懒加载----
    //FIXME:按钮图片 需要抓
    private lazy var runButton:UIButton = UIButton.wm_imageButton("tabbar_compose_icon_add", backgroundImageName: "tabbar_compose_button")
   */
}

extension WMMainViewController{
    //添加按钮
   /*
 private func setupRunButton(){
        tabBar.addSubview(runButton)
    
    // Run 按钮的位置确定
    
    let count = CGFloat(childViewControllers.count)
    let w = tabBar.bounds.width/count
    
     runButton.frame = tabBar.bounds.insetBy(dx: 2*w, dy: 0)
    print(runButton.bounds.width)
    //MARK:---按钮的监听----
    runButton.addTarget(self, action: #selector(runStataus), for: UIControlEvents.touchUpInside)
    }
 */
    
    //MARK:---设置子控制器
    
    
    /*private func setupChildViewControllers(){
        //获取沙盒路径
        
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let jsonPath = (docDir as NSString).appendingPathComponent("main.json")
        //加载data
        var data = NSData(contentsOfFile: jsonPath)
        // 判断data  是否有内容 没有 就表示 本地沙盒没有文件
        if  data == nil {
            //从bundle加载data
            let path = Bundle.main().pathForResource("main.json", ofType: nil)
            data = NSData(contentsOfFile: path!)
        }
        
        // 走到此处表示 data 一定有数据
        guard let array = try? JSONSerialization.jsonObject(with:data! as NSData as Data, options: []) as? [[String:AnyObject]]
            else{
                return
        }
        
        var arrayM = [UIViewController]()
        
        for dict in array!{
            arrayM.append(controller(dict))
        }
        
        viewControllers = arrayM
    }
    
*/

    
}
