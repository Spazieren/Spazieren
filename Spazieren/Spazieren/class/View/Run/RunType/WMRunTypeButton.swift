//
//  
//
//
//
//
import UIKit

// UIControl  内置了  touchupinside 
class WMRunTypeButton: UIControl {

    @IBOutlet weak var imageView: UIImageView!
   
    @IBOutlet weak var tipLabel: UILabel!
    //点击按钮 要展现的 控制器的类型
    var clsName:String?

    // 使用图象名称和/ 标题 按钮创建  按钮  布局从 xib 中加载
    
    class func runTypeButton(imageName:String,title:String) -> WMRunTypeButton{
        let nib = UINib(nibName: "WMrunTypeButton", bundle: nil)
        let btn =  nib.instantiate(withOwner: nil, options: nil)[0] as! WMRunTypeButton
        btn.imageView.image = UIImage(named: imageName)
        btn.tipLabel.text = title
        return btn
    }
    
    
    
    
    
}
