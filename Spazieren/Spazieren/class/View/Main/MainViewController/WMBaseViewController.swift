
import UIKit
//oc  不支持多继承  不能 怎么解决   通过遵守协议  
//swift遵守协议 的写法  更像是  多继承
//extension  1.中不能定义属性
//           2.不能重写父类的方法   重写父类方法 是 子类的职责   扩展(extension)是对 当前类的扩展
//class WMBaseViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{

class WMBaseViewController: UIViewController {
//    // 用户登录标记
//    var userLogon = true
    //访客视图信息字典
    var visitorInfoDictionary:[String:String]?
    
    
    //没有登陆就不创建  不冷用懒加载
    var tableview :UITableView?
    ///刷新空間
    var refreshControl:EVRefreshControl?
    //MARK:---自定义导航条----
    //定义上啦刷新判断标记
    var isPullup = false

    lazy var navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.wm_screenWidth(), height: 64))
    //自定义导航条目
    lazy var navItem = UINavigationItem()
    
    //MARK:---viewdidload----

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        WMNetworkManager.shared.userLogon ? loaddata(): ()
        // 注册 登录成功后 发送的通知
        NotificationCenter.default().addObserver(self, selector: #selector(loginSuccess), name: WMUserLoginSuccessedNotification, object: nil)
        
        
    }
    deinit{
        //注销通知
        NotificationCenter.default().removeObserver(self)
    }
    

    //MARK:---重写title的  didSet----

    override var title: String?{
        didSet {
            navItem.title = title
        }
    }
    //加载数据  具体实现由子类  实现 
    func loaddata(){
        // 如果子类不实现任何   则关闭刷新空间
        refreshControl?.endRefreshing()
    
    }
    }
//MARK:---添加坚挺方法
extension WMBaseViewController{
    
    // 登录成功处理
    @objc private func loginSuccess(_ n:Notification){
        print("登录成功\(n)")
        //清除导航栏  左右侧的  item
//        navItem.leftBarButtonItem = nil
//        navItem.rightBarButtonItem = nil
        // 更新ui
        // 将访客视图 更新为 表格视图
        //需要重新 设置view
        // view = nil  会调用 loadview 后再调用viewdidload  
        view.removeFromSuperview()
        // 注销通知  重新 执行viewdidload  会 再次注册通知   避免通知被重复注册
        NotificationCenter.default().removeObserver(self)
        
        
        
    }
    
    
    
    
    @objc private func loginin(){
        print("login")
        // 发送通知 
        NotificationCenter.default().post(name: Notification.Name(rawValue: WMUserShouldLoginNotification), object: nil)
    
    }
    
    
    @objc private func register(){
        print("register")
    }
    
    
    
    
}
















//MARK:---分类1设置界面----
extension WMBaseViewController{
    //去掉private   子类就可以访问该方法了  可以重写
   
    // 不让外界  调用  子类不能访问 private
   private func setupUI(){
    view.backgroundColor = UIColor.white()
        // 取消自动缩进  如果隐藏 导航欄 會縮進20個點
        // 如果  是true  再設置 tableview 的 時候   上面會空出一個 導航欄的  高度
        //MARK:---很重要

        automaticallyAdjustsScrollViewInsets = false
    
        setupNavigationBar()
    WMNetworkManager.shared.userLogon ? setupTableView() : setupvisitorView()
 
        

    }
    //MARK:---设置表格视图----
    
    
    //子类重写 该方法  子类 不关心 登陆前的操作
     func setupTableView(){
        tableview = UITableView(frame: view.bounds, style: .plain)
        tableview?.separatorColor = UIColor.wm_random()
       
        //view.addSubview(tableview!)  这种  会覆盖上面的ui
        //指定ui 在 那个层次上
        view.insertSubview(tableview!, belowSubview: navigationBar)
        //设置数据源 法方法  让子类直接实现 源 和方法lan
       tableview?.delegate = self
       tableview?.dataSource = self
        //MARK:  設置內容縮進
        
        tableview?.contentInset = UIEdgeInsets(top: navigationBar.bounds.height, left: 0, bottom: tabBarController?.tabBar.bounds.height ?? 49, right: 0)
        
        //修改指示器的缩紧
        //强行解包  是为了拿到一个必有得值
        
        
        //MARK:重点
        tableview?.scrollIndicatorInsets = (tableview!.contentInset)
       
        //MARK：設置刷新空間
        
        //1.实例化控件
        refreshControl = EVRefreshControl()
        // 添加到视图
           tableview?.addSubview(refreshControl!)
        //  添加监听方法
        // 此处调用的 方法LOADDATA 是子类的  因为  子类的 方法已经重写覆盖了父类的了 父类  只是负责提供方法的声明 
        refreshControl?.addTarget(self, action: #selector(loaddata), for: UIControlEvents.valueChanged)
    }
    //MARK:---访客视图

    private func setupvisitorView(){
        let visitorView = WMVisitorView.visitorView()
        //visitorView.backgroundColor = UIColor.WM_randomColor()
        
        view.insertSubview(visitorView, aboveSubview: navigationBar)
        print("访客视图 \(visitorView)")
        // 设置访客视图信息  传递
        //visitorView.visitorInfo = visitorInfoDictionary
        // 添加访客视图按钮的的  坚挺方法
        visitorView.weixin.addTarget(self, action: #selector(loginin), for: .touchUpInside)
        visitorView.weibo.addTarget(self, action: #selector(loginin), for: .touchUpInside)
//        //设置导航条的按钮
//        navItem.leftBarButtonItem = UIBarButtonItem(title: "register", style: .plain, target: self, action: #selector(register))
//        navItem.rightBarButtonItem = UIBarButtonItem(title: "login", style: .plain, target: self, action: #selector(loginin))
    }

    //MARK:--- 设置导航条----
    private func setupNavigationBar(){
    
    //--添加导航条
    view.addSubview(navigationBar)
    //  将item  设置给bar
    navigationBar.items = [navItem]
    //设置navbar 导航条整个背景的颜色
    navigationBar.barTintColor = UIColor.wm_color(withHex: 0xf6f6f6)
    //设置navbar 的字体颜色
    navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.darkGray()]
    // 设置系统按钮的  用barbutton(系统方法)  创建出来的button  的文字的渲染颜色
        navigationBar.tintColor = UIColor.orange()
    }
    
}
//MARK:---分类2----
extension  WMBaseViewController:UITableViewDataSource,UITableViewDelegate{
    
    //超父类只负责 提供方法  子类来实现  子类的数据源方法实现 不需要  super 调用父类的  因为父类的 没有操作
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 只是保证没有 语法错误   确定  模版
        return UITableViewCell()
    }
    // 实现  heightforrow atindexpath   方法  子类  才能  重写
    func  tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  10
    }
    
    
    //在将要显示最后一行的时候  做上啦刷新
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 判断是否是最后一 区域/行  是否是最大的indexPath.section 或者 是否是最大的 indexPath.row
        let row = (indexPath as NSIndexPath).row
        let section = (tableview?.numberOfSections)! - 1
//        print("section\(section)")
        if row < 0 || section < 0 {
            return
        }
        let count = tableview?.numberOfRows(inSection: section)
        // 如果是最后一行  并且 没有做上啦刷新
        //MARK:---上啦刷新
        

        if row == (count! - 1) && !isPullup {
            print("上拉刷新")
            //设置标记
            isPullup = true
            //开始刷新
            loaddata()
        }
    }
    
    
}










