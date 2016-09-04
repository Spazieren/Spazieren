//
//
//
//
//

import UIKit

class WMNewFeatureView: UIView {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var enterButton: UIButton!
    
    @IBOutlet weak var pageControl: UIPageControl!
   
    @IBAction func entersStatus() {
        //点击按钮  进入 微博 隐藏  整个新特性 view
        //FIXME:---实现登录界面
        loginorwelcome()
        // removeFromSuperview()
    }
    
    class func newFeatureView() ->WMNewFeatureView{
        
        let nib = UINib(nibName: "WMNewFeatureView", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0]as! WMNewFeatureView
        // 从 xib  加载的视图  默认是  600 ＊600 的
        v.frame = UIScreen.main().bounds
        return v
    }
    //awakefromnib
    override func awakeFromNib() {
        // 如果使用自动布局的界面  从xib  加载 的 默认大小事 600 ＊600
        let count = 4
        let rect = UIScreen.main().bounds
        for i in 0..<4{
            let imageName = "new_feature_\(i+1)"
            let iv = UIImageView(image: UIImage(named: imageName))
            // 设置大小
            iv.frame = rect.offsetBy(dx: CGFloat(i) * rect.width, dy: 0)
            scrollView.addSubview(iv)
            
        }
        // 指定scrollview 的属性
        scrollView.contentSize = CGSize(width: CGFloat(count + 1)*rect.width, height: rect.height)
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        //代理监听  手势
        scrollView.delegate = self
        
        
        // 隐藏按钮
        enterButton.isHidden = true
       
        //pageControl.isUserInteractionEnabled = false
    }
}

//MARK:---代理实现
extension WMNewFeatureView:UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 滚动到最后一个屏幕  让视图删除
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        //判断是否事最后一页
        if page == scrollView.subviews.count{
            print("欢迎进入微博")
            //scrollView.removeFromSuperview()
              // 如果是倒数第二页  显示按钮
            loginorwelcome()
            
        }
        enterButton.isHidden = (page != scrollView.subviews.count - 1)
        
    }
    
    //处理scrollview 的滚动
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 一旦滚动 隐藏按钮
        enterButton.isHidden = true
        //计算当前的偏移量
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width + 0.5)
        // 先除 后加  比如 滚了 120  bounds 是50  当前偏移是3
        // 设置分页
        pageControl.currentPage = page
        // 分页控件的隐藏
        pageControl.isHidden = (page == scrollView.subviews.count)  //最后一页 隐藏  pagecontrol
        
        
    }
    
    
    private func loginorwelcome(){
        
        if WMNetworkManager.shared.userLogon {
            let v = WMWelComeView.welcomeView()
            self.addSubview(v)
            scrollView.removeFromSuperview()
        }else{
            let v = WMVisitorView.visitorView()
            self.addSubview(v)
            scrollView.removeFromSuperview()
        }

    }
    
    
    
    
}



