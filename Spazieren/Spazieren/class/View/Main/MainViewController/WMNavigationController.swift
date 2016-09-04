//
//  WBNavigationController.swift
//  传智微博
//
//  Created by will on 8/15/16.
//  Copyright © 2016 connected. All rights reserved.
//

import UIKit

class WMNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // 隐藏默认的navigationbar
        navigationBar.isHidden = true

    }
    //MARK:---重写push 方法    该类的  所有 push  都会调用 此方法 ----

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        //如果不是栈底控制器  才需要隐藏  根控制器不需要处理
        
        if childViewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        
        if let vc = viewController as? WMBaseViewController{
             var title = "back"
            if childViewControllers.count == 1 {
                
                title = childViewControllers.first?.title ?? "back"
            }
            //vc  是  即将要push 出来的 controller
            vc.navItem.leftBarButtonItem = UIBarButtonItem(title: title, target: self, action: #selector(popToParent),isBack:true)
        }
        
        super.pushViewController(viewController, animated: true)
        
    }
    // pop 方法
    @objc private func popToParent(){
        popViewController(animated: true)
    }

}
