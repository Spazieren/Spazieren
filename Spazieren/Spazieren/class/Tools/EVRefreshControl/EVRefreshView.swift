//
//  EVRefreshView.swift
//  刷新控件
//
import UIKit

class EVRefreshView: UIView {
    // 刷新状态
    /*
     在ios 中 系统中UIView 封装的旋转动画 默认是 顺时针  改为 - M_PI  也是 顺时针旋转   因为 两个路径的路层一样 
       默认顺时针  此时没有更高的优先级   就顺时针 旋转
     就近原则：CGFloat(M_PI - 0.001) 后   会发现  往原来的 路径 回去  要 近一些 所以 可以达到
     优先级比顺指针 要高 
     如果要实现   360 度旋转  需要 核心动画 CABaseAnimation
     */
    var refreshState:EVRefreshState = .normal{
        didSet{
            switch refreshState {
            case .normal:
                // 恢复状态
                tipIcon?.isHidden = false
                indicator?.stopAnimating()
                //
                tipLabel?.text = "大力出奇迹..."
                //两种写法  此为  常规写法  下面的  为  尾随闭包  准备好的一段代码
                UIView.animate(withDuration: 0.25) {
                self.tipIcon?.transform = CGAffineTransform.identity
                }
            
            case .pulling:
                tipLabel?.text = "放手就刷新..."
            // 颠倒图象方向  添加至 动画 里面
                UIView.animate(withDuration: 0.25) {
                     self.tipIcon?.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI + 0.001))
                }
               
            case .willRefresh:
                tipLabel?.text = "正在刷新中..."
                // 隐藏提示图标
                tipIcon?.isHidden  = true
                // 显示菊花
                indicator?.startAnimating()
               
                
                
                
            }
            
            
        }
    }
    //父视图的高度
    
    var parentViewHeight:CGFloat = 0
    
    
    //提示图标
    @IBOutlet weak var tipIcon: UIImageView?
    //提示标签
    @IBOutlet weak var tipLabel: UILabel?
    // 指示器
    @IBOutlet weak var indicator: UIActivityIndicatorView?
    
    //MARK:类的刷新方法
    class func refreshView() -> EVRefreshView{
        let nib = UINib(nibName: "EVRefreshView", bundle: nil)
        // id 类型  需要转换
        return nib.instantiate(withOwner: nil, options: nil)[0] as! EVRefreshView
    
    
    }
    
}
