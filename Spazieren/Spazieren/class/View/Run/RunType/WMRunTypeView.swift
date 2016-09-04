//
//  
//
//
//

import UIKit
import pop
//撰写微博类型视图
class WMRunTypeView: UIView {
    // scrollview
    @IBOutlet weak var scrollView: UIScrollView!
    //关闭按钮  约束
    @IBOutlet weak var closeButtonCenterXCons: NSLayoutConstraint!
    // 返回按钮  约束
    // @IBOutlet weak var returnButtonCenterXCons: NSLayoutConstraint!
    
    @IBOutlet weak var closeButton: UIButton!
    
    // 返回按钮 本身
    @IBOutlet weak var returnButton: UIButton!
    //  leading
    @IBOutlet weak var closeButtonLeadingToSuperView: NSLayoutConstraint!
    // 分割线
    @IBOutlet weak var separateLine: UIImageView!
    
    //按钮数据数组
    private let buttonsInfo = [["imageName":"tabbar_Run_idea","title":"文字","clsName":"WMRunViewController"],
                               ["imageName":"tabbar_Run_photo","title":"照片／视频"],
                               ["imageName":"tabbar_Run_weibo","title":"长微博"],
                               ["imageName":"tabbar_Run_lbs","title":"签到"],
                               ["imageName":"tabbar_Run_review","title":"点评"],
                               ["imageName":"tabbar_Run_more","title":"更多","actionName":"clickMore"],
                               ["imageName":"tabbar_Run_friend","title":"好友圈"],
                               ["imageName":"tabbar_Run_wbcamera","title":"微博相机"],
                               ["imageName":"tabbar_Run_music","title":"音乐"],
                               ["imageName":"tabbar_Run_shooting","title":"拍摄"]]
    
    
    
    
    //完成回调
    private var completionBlock:((clsName:String?)->())?
    
    
     // MARK:实例化方法
    //  注意点
    class func runTypeView() ->WMRunTypeView{
        let nib = UINib(nibName: "WMRunTypeView", bundle: nil)
        // 从 xib加载完成视图  就会调用 awakeFromnib   而在awakfromnib
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! WMRunTypeView
        // XIB   加载 出来的  默认 是  600 ＊600  还需要设置frame/bounds  确定位置
        
        v.frame = UIScreen.main().bounds
        //  里面含有 一些操作
        v.setupUI()
        
        return v
        
    }
    
    
    
    
    
    //###以下代码可以删除
    
    override init(frame: CGRect) {
        //
        super.init(frame: UIScreen.main().bounds)
        backgroundColor = UIColor.wm_random()
    }
    //支持xib sb
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    //###
    
    //显示当前视图
    //oc 中的 block  如果当前的方法  不能执行   通常使用 属性纪录  在需要的时候 执行
    
    func show(completion:(clsName:String?)->()){
        
        //0. 记录闭包
        completionBlock = completion
        
        //1. 将当前 视图 添加到 Main 上  但是现在  不知道    所以我们拿到 根视图控制器  此处 是 tabBarcontroller
        guard  let  vc = UIApplication.shared().keyWindow?.rootViewController else{
            return
        }
        
        // 添加视图
        vc.view.addSubview(self)
        // 开始动画
        showCurrentView()
        
        
        
    }
    
    //
    
    @objc func  clickButton(selectedButton:WMRunTypeButton){
        print("点我了\(selectedButton)")
        // 判断当前 显示的 视图
        let page = Int(scrollView.contentOffset.x/scrollView.bounds.width)
        let v = scrollView.subviews[page]
        // 遍历 当前视图的 子视图   选中的 方法  没选中的 缩小
        for (i,btn) in v.subviews.enumerated(){
            //MARK:1.缩放动画
            let scaleAnim:POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewScaleXY)
            
            // x,y 在系统中使用 CGPoint 表示 ，如果要转换成 id 需要使用 'NSValue'  包装
            
            let scale = (selectedButton == btn) ? 1/0.618 : 0.618
            scaleAnim.toValue = NSValue(cgPoint: CGPoint(x: scale, y: scale))

            scaleAnim.duration = 0.5
            btn.pop_add(scaleAnim, forKey: nil)
            
            // MARK:2.渐变动画
            let alphaAinm :POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
            alphaAinm.toValue = 0.2
            alphaAinm.duration = 0.5
            btn.pop_add(alphaAinm, forKey: nil)
            // MARK:3.监听 动画完成  然后 modal
            
            if i == 0{
                alphaAinm.completionBlock = {_,_ in
                    //回调
                print("回调展现控制器")
                    self.completionBlock?(clsName:selectedButton.clsName)
                    
                    
                    
                }
            }
        }
        
        
        
        
        
        
        
    }
    
    //MARK:更多按钮点击
    @objc private func clickMore(){
        print("点击更多")
        // 将scrollView  滚动到 第二页
        let offset = CGPoint(x: scrollView.bounds.width, y: 0)
        scrollView.setContentOffset(offset, animated: true)
        //  处理底部按钮
        //把返回按钮显示
        returnButton.isHidden = false
        separateLine.isHidden = false
        //
        let margin = scrollView.bounds.width/4
        
        //returnButtonCenterXCons.constant -= margin
        //  把 关闭 按钮   右移动
        
        closeButtonLeadingToSuperView.constant += margin * 2
        self.layoutIfNeeded()
        }
    
    // MARK:返回按钮的点击
    // 点击更多   图片的 反操作
    @IBAction func clickReturn() {
        scrollView.setContentOffset(CGPoint(x:0,y:0), animated: true)
        returnButton.isHidden = true
        separateLine.isHidden = true
        closeButtonLeadingToSuperView.constant -= scrollView.bounds.width/2
        self.layoutIfNeeded()
        
        
        
    }
    
    

    // 点击 X   关闭视图
    @IBAction func close() {
        hideButton()
        
//        
//    DispatchQueue.main.after(when: DispatchTime.now() + 0.25) {
//         self.removeFromSuperview()
//        }
        

    }
    
    
    
}
// MARK:动画方法扩展

private extension WMRunTypeView{
    // MARK:隐藏按钮的动画
    private func hideButton(){
        //根据 contentoffset  判断当前显示的 子视图
        let page = Int(scrollView.contentOffset.x/scrollView.bounds.width)
        let v = scrollView.subviews[page]
        //  遍历V中的  所有按钮   必须要有反序  和相面的 动画开始时间 相匹配        栈 先进后出  但是和这里无关  这里实在堆
        for (i,btn) in v.subviews.enumerated().reversed(){
            //创建动画
            let anim:POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            //
        anim.fromValue = btn.center.y
        anim.toValue = btn.center.y + 350
            // 设置时间
            anim.beginTime = CACurrentMediaTime() + CFTimeInterval(v.subviews.count - i)*0.025
            // 添加动画
            btn.layer.pop_add(anim, forKey: nil)
            //  监听 最后一个 按钮的  消失   也就是 第0个按钮  最先亚栈的 那一个
            if i == 0 {
                anim.completionBlock = {_,_ in
                    
                    self.hideCurrentView()
            }
            }
        }
        //隐藏当前的视图 －开始时间
        
    }
 
    
    // MARK:隐藏当前的视图 
    private  func hideCurrentView(){
        let anim:POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        anim.fromValue = 1
        anim.toValue = 0
        anim.duration = 0.25
        pop_add(anim, forKey: nil)
        anim.completionBlock = {_,_ in
        self.removeFromSuperview()
        
        }
    }
    
    
    
    
    
    
    
    // MARK:显示部分的动画
    // MARK: 显示Run模块  动画方法
    private func showCurrentView(){
        // 创建动画
        let anim:POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        //
        anim.fromValue = 0
        anim.toValue = 1
        anim.duration = 1
        // 添加到视图
        pop_add(anim, forKey: nil)
        
        //调用显示按钮的动画方法
        showButtons()
        

    }
  
    // MARK:弹力显示所有的按钮
    private func showButtons(){
        // 获取 scrollview的  第0个 子视图
        let v = scrollView.subviews[0]
        //  遍历 子视图中的 按钮
        for  (i,btn) in v.subviews.enumerated() {
            //创建 pop 动画
            let anim :POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
            //设置 动画属性
            anim.fromValue = btn.center.y + 350
            anim.toValue = btn.center.y
            // 弹力系数 0-20 越大 弹力越大 默认为4
            anim.springBounciness = 12
            // 弹力速度  0-20  默认是12   越大 速度越快
            anim.springSpeed = 12
            // 设置动画启动时间
            anim.beginTime = CACurrentMediaTime() + CFTimeInterval(i)*0.025
            // 添加动画
            btn.pop_add(anim, forKey: nil)
        }
        
        
    }
    
    
}

















////////// private  让extension 中所有的方法 都是私有的

//MARK:setupUI 扩展
private extension WMRunTypeView{
    // 设置ui
    func setupUI(){
        //  强行 更新 布局
        layoutIfNeeded()
        
        //向 scrollView 添加 视图
        let rect = scrollView.bounds
        let offsetWidth  = scrollView.bounds.width
        //
        for i in 0..<2{
            let v = UIView(frame: rect.offsetBy(dx: CGFloat(i)*offsetWidth, dy: 0))
            // 向视图添加按钮
            addButtons(v: v, idx: i*6)
            //将视图 添加到 scrollView
            scrollView.addSubview(v)

            }
        //设置 其它 条件 
        //  可以滚动的 内容
        scrollView.contentSize = CGSize(width: 2*rect.width, height: 0) // 此处 height 决定  垂直 滚动距离
        //设置水平  垂直 滚动条  不可用
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        // 禁止滚动
        scrollView.isScrollEnabled = false
        
        
        
        
        
        
}
    
    //MARK:向视图添加按钮
    
    func addButtons(v:UIView,idx:Int){
        let count = 6
        // 从idx 开始 添加 6个按钮
        for i in idx..<(idx + count){
            // 判断
            if  i >= buttonsInfo.count{
                break
            }
            // 从字典数组中获取 图象名称 和 title
            let dict =  buttonsInfo[i]
           
           guard let imageName = dict["imageName"],
                      title  = dict["title"] else {
                continue
            }
            
            let btn = WMRunTypeButton.runTypeButton(imageName: imageName, title: title)
            
            //添加到视图
            v.addSubview(btn)
            
            //MARK: 添加 更多按钮的   监听方法
            if let actionName = dict["actionName"]{
                btn.addTarget(self, action: Selector(actionName), for: .touchUpInside)
            }else{
                
                //FIXME:<#remaining#>
                btn.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
            }
            //  设置要展现的 类名   有酒设置 没有 就 不设置
            btn.clsName = dict["clsName"]
            
            
        }
        
        
        //  布局按钮  索引 和按钮  都可以拿到了
        // 准备常量
        let btnSize = CGSize(width: 100, height: 100)
        let margin = (v.bounds.width - 3*btnSize.width)/4
        for (i,btn) in v.subviews.enumerated(){
            let y:CGFloat = CGFloat(i/3)*(v.bounds.height - btnSize.height)
            let col = i % 3
            let x:CGFloat = CGFloat(col+1)*margin + CGFloat(col)*btnSize.width
            btn.frame = CGRect(x: x, y: y, width: btnSize.width, height: btnSize.height)
            
            
        }
        
        
        
        
        
    }
    
}





