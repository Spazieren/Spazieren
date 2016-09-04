//
//  
//
//
//
//
import UIKit
import SDWebImage
// 欢迎视图
class WMWelComeView: UIView {
    
    @IBOutlet weak var iconView: UIImageView!
    
    @IBOutlet weak var tipLabel: UILabel!
    // iconview 的 宽度属性  常量值
    @IBOutlet weak var iconWidthCos: NSLayoutConstraint!
    
    @IBOutlet weak var bottomCos: NSLayoutConstraint!
    
    //  用xib  需要用的
    required init?(coder aDecoder: NSCoder) {
        //        fatalError("init(coder:) has not been implemented")
        //  如果希望  也可以使用xib  开发 就如下
        super.init(coder: aDecoder)
        
        
    }

    
    
    
    
    
    class func welcomeView() ->WMWelComeView{
        
        let nib = UINib(nibName: "WMWelComeView", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0]as! WMWelComeView
        // 从 xib  加载的视图  默认是  600 ＊600 的
        v.frame = UIScreen.main().bounds
        return v
    }
    
    // 自动布局系统 完成后 系统会自动调用 该方法 
    // 通常是对子视图  布局 进行修改
//    override func layoutSubviews() {
//        super.layoutSubviews()
//    }
//    
    
    
    
    //解档   刚从xib 文件中加载二进制文件  还没有  和代码连线 建立联系  千万不要在此方法中 处理ui  控件还是nil
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        print( ("initwithcode\(iconView)")
//        //nil
//    }
    //设置头像
    
    // 从 xib  加载完成(此时 frame bounds  都还么没有  ，只是二进制数据   相对的约束)   后调用
    // 在awakefromnib 使用自动布局  是没有效果的  只有相对的 约束  和一些常量值 没有确定的(都为0)   frame bounds
    override func awakeFromNib() {
        guard let urlString = WMNetworkManager.shared.userAccount.avatar_large,
        let url = URL(string:urlString) else {
        
        return
    }
        //设置图像  如果网络没有下载完成 就显示 占位图片
    iconView.sd_setImage(with: url, placeholderImage: UIImage(named: "avatar_default_big"))
        // 设置图片  圆角
        // iconView.layer.cornerRadius = iconView.bounds.width * 0.5
        //iconView.layer.cornerRadius = 42.5  // 可以达到效果
        iconView.layer.cornerRadius = iconWidthCos.constant*0.5
        iconView.layer.masksToBounds = true
        
    }
    
    
    
    override func didMoveToWindow() {
        //视图 是使用自动布局  来设置   根据 父视图的大小  是相对的  只是设置了约束  没有frame
        //当视图被加到窗口的时候  根据计算约束值  确定位置   更新控件的位置
        self.layoutIfNeeded()
        // 直接按照 当前的约束 更新控件的位置   执行之后  控件所在位置 就是在xib 中布局的位置
        ///  新的操作  产生新的控件约束    需要下面再次调用 self.layoutIfNeed
        bottomCos.constant = bounds.size.height - 200
        // 此处调整了  xib 中  位置 而  控件的位置  是一个相对的位置  需要依据加载斤窗口的父视图  或其它控件来相对确定   所以后面的动画  再调用 self.laoutIfNeed 的时候 以动画的方式将  之前的改变 重新布局在 父视图上面
        
        // 添加动画
        // 如果控件的约束 还没有 计算号 所有的约束 会一起动画（如果 在进入函数时没有 加上第一个self.layoutIfNeed的话）
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
            //更新约束
            //当有操作的时候  再次设置  控件的位置  再次使用self.layoutIfNeed  更新位置
            self.layoutIfNeeded()
            }) { (_) in
                
                UIView.animate(withDuration: 1.0, animations: {
                    self.tipLabel.alpha = 1
                    }, completion: { (_) in
                        self.removeFromSuperview()
                })
                
        }
    }
    
    
    
    
}
