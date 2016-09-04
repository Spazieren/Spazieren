//
//  
//

import UIKit

class WMTitleButton: UIButton {
    //title  是 nil  就显示home  有的话就显示 title  和图像
    init(title:String?){
        super.init(frame: CGRect())
        if title == nil {
            setTitle("HOME", for: [])
        }else{
            setTitle(title!+" ", for: [])
            //设置图像
           setImage(UIImage(named: "navigationbar_arrow_down"), for:UIControlState())
           setImage(UIImage(named: "navigationbar_arrow_up"), for:.selected)
            

        }
        //设置字体 和颜色
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        //设置颜色
        setTitleColor(UIColor.darkGray(), for: [])
        //设置大小
        sizeToFit()
        
        
    }
    
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // 重写布局子视图
    override func layoutSubviews() {
        super.layoutSubviews()
        // 判断titleLabel imageView  是否同时存在
        guard let titleLabel =  titleLabel,imageView = imageView else {
            return
        }
        //  该方法  会调用两次   所以  会 看不到
        //oc  中 不能直接修改 结构体属性的 成员变量   拿到结构体属性  拿到 属性的成员变量  修改
        // swift  可以直接修改 结构体属性的成员变量
        print("\(titleLabel)\(imageView)")
        
        //  标题靠左   图标的x  以 tiplaebel 的 bounds 的宽度为 起点
        titleLabel.frame.origin.x = 0
        imageView.frame.origin.x = titleLabel.bounds.width
        
        
        
        /* 将label 的x  向左移动 imageview 的宽度
        // titleLabel.frame = titleLabel.frame.offsetBy(dx: -imageView.bounds.width, dy: 0)
        
        // 将imageview的x 向右移动label 的宽度
        imageView.frame = imageView.frame.offsetBy(dx: titleLabel.bounds.width, dy: 0)
        */
    }
    
    
    
    
}
