//
//
//
//
//

import UIKit
import SVProgressHUD

class WMMainViewController: UITabBarController {
    //定时器
    private var timer:Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildControllers()
        setupComposeButton()
        setupTimer()
        // 设置新特性视图
        setupNewfeaturesViews()
        //设置代理
        delegate = self
        //注册通知
        NotificationCenter.default().addObserver(self, selector: #selector(userLogin), name: WMUserShouldLoginNotification, object: nil)
    }
    
    
    //MARK:---销毁时钟 十分重要
    
    // 销毁时钟
    deinit{
        timer?.invalidate()
        // 注销通知
        NotificationCenter.default().removeObserver(self)
    }
    
    
    //使用代码设置支持的屏幕模式  在需要的时候  单独处理  屏幕支持模式
    // 在该处设置后   当前的控制器  以及子控制器 都 会 支持 该设置
    // 如果播放视频  一般 播放视频 是通过 modal  展现的   转场
    //比在 工程 处点击 设置 要好很多  更细
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .portrait
    }
    //MARK:-- 用户登录通知处理
    @objc private func userLogin(_ n:Notification){
        //FIXME
        print("用户登录通知\(n)")
        var when = DispatchTime.now()
        
        
        
        // 判断n.object 是否有值 如果有值 提示用户登录
        
        
        if n.object != nil{
            //设置指示器的渐变样式
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.gradient)
            SVProgressHUD.showInfo(withStatus: "用户登录一超时，请重新登录")
            // 此时跳转 还是停不住
            // 修改延时时间
            when = DispatchTime.now() + 2
        }
        DispatchQueue.main.after(when: when) {
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.clear)
            let nav = UINavigationController(rootViewController: WMOAuthViewController())
            self.present(nav, animated: true, completion: nil)
            
        }
        
        
    }
    
    
    
    
    // 加private  会报错
    //@objc 能够保证方法私有  能够保证仅在当前对象访问
    // @objc  保证该方法 在 运行时  通过 oc 的方式去访问   保证安全(仅在当前对象被访问)  又能通过 oc 的消息机制 访问到
    // private  修饰的  好比在.m 文件中  外界不能调用   不加 就好像在.h 文件中 外界都能访问  @objc private  私有 而且 可以通过oc的
    //  运行时机制访问到
    //MARK:---撰写按钮监听方法----
    @objc private func composeStataus(){
        print("撰写按钮")
        //FIXME:0 判断是否登录
        //1.实例化视图
        let v = WMRunTypeView.runTypeView()
        
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
        //
        
        //    //测试modal 屏幕方向旋转
        //    let vc = UIViewController()
        //    vc.view.backgroundColor = UIColor.cz_random()
        //    let nav = UINavigationController(rootViewController: vc)
        //    present(nav, animated: true, completion: nil)
        
        
    }
    //MARK:---按钮的懒加载----
    
    private lazy var composeButton:UIButton = UIButton.wm_imageButton("tabbar_compose_icon_add", backgroundImageName: "tabbar_compose_button")
    
    
}



//MARK:---新特性视图
extension WMMainViewController{
    
    
    
    
    // 设置新特性视图
    private func  setupNewfeaturesViews(){
        // 判断是否登录
        if !WMNetworkManager.shared.userLogon{
            //未登陆 就 直接返回  啥也不干
            print("BUG在哪呢 ")
            
        let v = WMWelComeView.welcomeView()
            view.addSubview(v)
        }else{
            
            if isNewVersion{
                let v = WMNewFeatureView.newFeatureView()
                view.addSubview(v)
            }

            
        }
        
        }
    // extension 可以 有 计算型属性  不会 占用存储空间  版本号  是增长的
    //  主版本号：大的修改  使用者 也需要大的适应  7.3.1  8.0.1
    //次版本号7.2 7.3   某些函数 和方法的  小的变化  程序员能够适应
    //  修订版本号：  框架 或者  程序 内部  bug 的 修复  不会 对程序员 造成任何的影响
    //构造函数：给属性分配空间
    private var  isNewVersion:Bool{
        //取当前的版本号
        //print(NSBundle.mainBundle().infoDictionary)
        let currentVersion = Bundle.main().infoDictionary?["CFBundleShortVersionString"] as? String ?? " "
        
        
        //取保存在'Document'(Itunes 备份) 目录中的之前的版本号   最理想 是保存在 偏好设置里面
        let path = ("version" as NSString).wm_appendDocumentDir()
        let sanBoxVersion = (try? String(contentsOfFile: path!)) ?? ""
        
        //将当前版本号 保存在沙盒
        _ = try? currentVersion.write(toFile: path!, atomically: true, encoding: String.Encoding.utf8)
        
        // 返回两个版本号 是否一致
        
        
        
        
        return currentVersion != sanBoxVersion
    }
    
    
    
}









//MARK:---UITabBarControllerDelegate

//MARK:---解决 加号按钮 和 底部 tabbar之间 容错点 可能会导致的  穿帮问题

extension WMMainViewController:UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        print("将要切换到\(viewController)")
        // 判断  控制器在 数组中的索引
        let idx = (childViewControllers as NSArray).index(of: viewController)
        if selectedIndex == 0 && idx == selectedIndex{
            print("点击首页")
            let nav  = childViewControllers[0] as! UINavigationController
            let vc =  nav.childViewControllers[0] as! WMHomeViewController
            // 滚动到顶部
            vc.tableview?.setContentOffset(CGPoint(x:0,y:-64), animated: false)
            //刷新表格
            // 设置延迟  点击 首页按钮后  返回顶部  然后返回到顶部  加载数据
            DispatchQueue.main.after(when: DispatchTime.now() + 3, execute: {
                vc.loaddata()
            })
            
            //MARK:清除 tabbar 的 badgevalue(String)   清除 app 的 badgenumber (INT)
            self.tabBar.items?[0].badgeValue = nil // 设置成"" 回显示一个大胖圆点
            UIApplication.shared().applicationIconBadgeNumber = 0
        }
        
        // 判断 目标控制器 是否是 UIViewController的   是就不跳转  不是就表示是 navigationcontroller  就跳转
        return   !viewController.isMember(of: UIViewController.self)
        
    }
    
}








// 与timer 有关的方法
extension WMMainViewController{
    private func setupTimer(){
        timer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    //时钟触发方法
    @objc private  func updateTimer(){
        
        if !WMNetworkManager.shared.userLogon{
            return
        }
        print(#function)
        // 5秒调用一次 显示有几条未读 只是检查  有几条未读  并没有刷新数据    然后以此设置  tabbar  数字
        WMNetworkManager.shared.unreadCount { (count) in
            print("有\(count)条新数据")
            // 设置tabbaritem 的badgeValue   number   显示 有几条未读
            self.tabBar.items?[0].badgeValue =  count > 0 ? "\(count)" : nil
            
            // 设置APP 的badgeNumber   从IOS 8 开始就需要授权   才能显示 app 的 iconbadgenumber   ios 10 之后授权方式变了
            
            UIApplication.shared().applicationIconBadgeNumber = count
            
        }
        
        
    }
    
}

//

extension WMMainViewController{
    
    
    
    private func setupComposeButton(){
        tabBar.addSubview(composeButton)
        
        //MARK:---撰写按钮的位置确定----
        
        let count = CGFloat(childViewControllers.count)
        let w = tabBar.bounds.width/count
        
        composeButton.frame = tabBar.bounds.insetBy(dx: 2*w, dy: 0)
        print(composeButton.bounds.width)
        //MARK:---按钮的监听----
        composeButton.addTarget(self, action: #selector(composeStataus), for: UIControlEvents.touchUpInside)
        
        
    }
    //MARK:---设置子控制器
    
    
    
    private func setupChildControllers(){
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
    
    
    
    private func controller(_ dict:[String:AnyObject]) -> UIViewController{
        
        guard let clsName = dict["clsName"] as? String,
            title = dict["title"] as? String,
            imageName = dict["imageName"] as? String,
            cls = NSClassFromString(Bundle.main().namespace + "." + clsName) as? WMBaseViewController.Type,
            visitorDict = dict["visitorInfo"] as?[String:String]
            else{
                return UIViewController()
        }
        
        let vc = cls.init()
        vc.title = title
        //设置控制器的 访客信息字典
        
        vc.visitorInfoDictionary = visitorDict
        vc.tabBarItem.image = UIImage(named: "tabbar_" + imageName)
        vc.tabBarItem.selectedImage = UIImage(named:"tabbar_" + imageName + "_selected" )?.withRenderingMode(.alwaysOriginal)
        vc.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.orange()], for: UIControlState.highlighted)
        // 系统默认是 12 号字    修改字体 要在 normal  下   高亮状态设置 字体 无效
        // 设置高亮状态 的字体  无效  而且  高亮状态下 设置的  选中颜色 也无效
        vc.tabBarItem.setTitleTextAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 12)], for: UIControlState.init(rawValue: 0))
        
        //实例化导航控制器的时候   会调用 push 方法将 rootvc  压栈
        let nav = WMNavigationController(rootViewController:vc)
        
        return nav
    }
    
    
    
    
    
}





