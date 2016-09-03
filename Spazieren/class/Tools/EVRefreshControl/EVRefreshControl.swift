//
//  EVRefreshControl.swift
//  微马
//




import UIKit

// 刷新控件  状态切换的临界点
private let EVRefreshOffset:CGFloat = 70


//-Normal:普通状态 什么都不做
//-Pulling  超过零界点  如果放手 刷新
//- WillRefresh 用户超过零界点 并且放手
enum EVRefreshState{
    case normal
    case pulling
    case willRefresh
}
/// 刷新控件
// 负责  刷新  相关的  业务逻辑   到多少 做什么 怎么做   什么时候 做   显示 是 RefreshView来   实现
class EVRefreshControl: UIControl {
    //MARK:- 属性
    // 滚动视图的 父视图   下拉刷新控件适用于   UItableView/uiCollectionView   共同的 唯一 (单继承嘛)父类 UIScrollView
    //public class UITableView : UIScrollView, NSCoding {
    //public class UICollectionView : UIScrollView {
    //public class UIScrollView : UIView, NSCoding, UIRefreshControlHosting {
    //UIView  继承自 UIRespond  并遵守 多项协议
    private weak var  scrollView:UIScrollView?
    // 刷新视图
    private lazy var  refreshView:EVRefreshView = EVRefreshView.refreshView()
    
    
    

    
    //构造函数
    init(){
        super.init(frame: CGRect())
        setupUI()
    }
    
    
    
    
    
    //  用xib  需要用的
    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        //  如果希望  也可以使用xib  开发 就如下
        super.init(coder: aDecoder)
        setupUI()
        
    }
    
    /**
    willmove addsubview方法会调用
     －当添加到父视图的时候  newSuperView 是 父视图
    －当父视图被移除  newSuperView  是 nil
    
    
    */
    //MARK:拿到将要移动过去的父控件
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        print(newSuperview)
        //记录父视图
        guard let sv = newSuperview as? UIScrollView else {
            return
        }
        // 记录父视图
        scrollView = sv
        
        // KVO监听 父视图的 contentoffset
        
        //KVO  要监听的对象  负责添加 监听者
        
        // 通常 只监听  某一个对象的 某几个属性  如果监听的属性太对  方法会很乱  KVO  是属于观察者模式
        // 只监听对象的重要属性  银行 监听  资金的变化  而其他的 不重要 
        // 观察者模式 在不需要的时候 都需要释放
        //通知中心：如果不释放  不会崩掉  但是会有内存泄漏   
        //         如果多次注册  释放不够  再进来的时候  还存在了几次注册 就会发几次通知
        //KVO：不释放  直接崩溃
        
        scrollView?.addObserver(self, forKeyPath: "contentOffset", options: [], context: nil)
        
        }
    
    
    //MARK:重写 removeFromSuperview   移除 KVO的 监听
    //
    //  本视图 从父视图上移除
    // 提示： 所有的下拉刷新框架  都是 监听 父视图的 contentOffset
    //所有框架的 KVO 实现的思路 都是这样的
    override func removeFromSuperview() {
        // superView 还存在
        
        superview?.removeObserver(self, forKeyPath: "contentOffset")
        
        super.removeFromSuperview()
        //superview 不存在了
    }
    
    
    
    
    // 所有KVO    不管监听多少个对象 
    //会统一调用 这个方法

    override func observeValue(forKeyPath keyPath: String?, of object: AnyObject?, change: [NSKeyValueChangeKey : AnyObject]?, context: UnsafeMutablePointer<Void>?) {
        // contentoffset 的 y 值 和  contentInset 的 top  有关
        
        print("\(scrollView?.contentInset)")
        
        print("contenoffset     ^^^^^^^^^^^^^\(scrollView?.contentOffset)")
        print("bouds####################\(scrollView?.bounds)")
        
        //初始高度  是 0
        guard let sv = scrollView else{
            return
        }
        // 一个控件的 contentInset (是一个边缘内间距)  设置后 是不会变化的
        // public var contentInset: UIEdgeInsets(结构体)
        // default UIEdgeInsetsZero. add additional scroll area around content
       
        
        //contentoffset  是 控件的 位置变化到哪一个点了  描述  x  y 的 变化
        //public var contentOffset: CGPoint(结构体)
        // default CGPointZero

        
        let height = -(sv.contentInset.top + sv.contentOffset.y)
        
        //
        if height < 0 {
            return
        }
        
        // 根据高度设置 新控件的frame
        //  该控件 是  sv 的子视图  其 frame  是根据  sv  的frame 做为依据的 
        //  在sv  移动的时候 frame的值  本身并没有变  只是其bounds 的y  发生了变化  也就是 contentOffset的y值  ，  而 新视图 是 sv 的 子视图  其  frame  是参照 sv 的原点(在变化) 来定位的  而此时我们希望将新视图的y  定义在  sv 的 上方 也就是 也就是 y轴 的负方向上 取值  而 sv 的 -(contentinset.top' + contentOffset.y) 为新视图的 我们希望的高度  ，基于 新视图的frame  y值  在sv frame y值的 负方向的需求   所以其  y 值  取  - height  是完美的
        // 在拉动的时候  scrollView 的 bouds  的y  发生变化  值 和 scrollview 的 contentOffset 的y  一样，
        // frame  是以父控件的原点 为参考  bounds  以自己的原点为参考
        self.frame = CGRect(x: 0, y: -height, width: sv.bounds.width, height: height)
        
        // 根据条件  选择传递父视图高度
        if refreshView.refreshState != .willRefresh{
        refreshView.parentViewHeight = height
        }
        
        // 判断临界点
        if sv.isDragging{
            
            if height > EVRefreshOffset &&  (refreshView.refreshState == .normal){
                print("放手刷新")
                refreshView.refreshState = .pulling
            }else if height < EVRefreshOffset && (refreshView.refreshState == .pulling){
                print("再使劲")
                refreshView.refreshState = .normal
            }
            }else{
            //放手  判断 是否超过零界点
            if refreshView.refreshState == .pulling{
                print("准备开始刷新")
                
                //让整个刷心视图显示出来
                // 解决方法  修改 表格的 contentInset
                // 刷新结束之后  将状态修改为 .Normal 才能够 继续响应刷新

                beginRefreshing()
                // 发送 刷新消息的 事件
                sendActions(for: .valueChanged)
            }
            
            
        }
        
    }

    
    
    
    
    // 开始刷新
    func beginRefreshing(){
        print("开始刷心")
        // 判断父视图
        guard let sv = scrollView else{
            return
        }
        
        // 判断是否正在刷新  如果是 就返回 
        if refreshView.refreshState == .willRefresh{
            return
        }
        
        //设置刷心视图的 状态
        refreshView.refreshState = .willRefresh
       
        // 调整表格的间距
        var  inset  = sv.contentInset
        inset.top+=EVRefreshOffset
        sv.contentInset = inset
        // 如果在此执行  会 重复 发送
        //sendActions(for: .valueChanged)
        
        //设置刷心视图的 父视图的高度 
        refreshView.parentViewHeight = EVRefreshOffset

        
    }
    
    // 结束刷新
    func endRefreshing(){
        print("结束刷心")
        // 恢复刷新视图的状态
        guard let sv = scrollView else{
            return
        }
        
        // 判断 是否正在刷新   很重要  和 上面的  判断  配套  不然程序 执行 很快    会出bug 
        if refreshView.refreshState != .willRefresh {
        return
         }
        
        
        refreshView.refreshState = .normal
        // 恢复表格的 contentinset
        var inset = sv.contentInset
        inset.top -= EVRefreshOffset
        sv.contentInset = inset
        
        
        
    }
    
    
}


//MARK:扩展
extension EVRefreshControl{
    private func setupUI(){
        backgroundColor = superview?.backgroundColor
        // 设置超出边界   不显示  就隐藏进去了
        //  clipsToBounds = true
        // 添加刷新视图  从xib  加载出来  默认的 宽高是  xib 中的  但是 自动布局后 宽高 就没有了
        addSubview(refreshView)
        //  自动布局  设置xib文件的 自动布局 需要指定  宽高
        // 设置  转化 autoresizing  到  约束
        refreshView.translatesAutoresizingMaskIntoConstraints = false
        
        //  和父视图的 x 中心  一样
        addConstraint(NSLayoutConstraint(item: refreshView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        //和父视图的  底部 靠近
        addConstraint(NSLayoutConstraint(item: refreshView, attribute:.bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0))
       
        // 这个时候设置的 refreshView.bounds.width/height   还是 xib 中  它的 宽高 
        addConstraint(NSLayoutConstraint(item: refreshView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: refreshView.bounds.width))
        // 高
        addConstraint(NSLayoutConstraint(item: refreshView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: refreshView.bounds.height))
        
        
        
        

       
        
    }
    
    
    
    
    
}
