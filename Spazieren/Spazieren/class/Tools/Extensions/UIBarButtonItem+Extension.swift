

import UIKit

extension UIBarButtonItem{
    // isBack  是返回按钮 是 就加上箭头
   
    convenience init(title:String,fontSize:CGFloat = 16,target:AnyObject?,action:Selector,isBack:Bool = false) {
        
        let btn:UIButton = UIButton.wm_textButton(title, fontSize: fontSize, normalColor: UIColor.darkGray(), highlightedColor: UIColor.orange())
        
        //navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btn)
        if isBack {
            let imageName = "navigationbar_back_withtext"
            btn.setImage(UIImage(named: imageName), for: UIControlState())
             btn.setImage(UIImage(named: imageName+"_highlighted"), for: UIControlState.highlighted)
            //调整加入图片？后的大小
            btn.sizeToFit()
            
        }
        
         btn.addTarget(target, action: action, for: .touchUpInside)
        //self.init     实例化uIBarbuttonitem  
        self.init(customView:btn)
    }
}
