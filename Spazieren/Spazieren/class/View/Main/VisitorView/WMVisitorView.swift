

import UIKit
class WMVisitorView: UIView {
    
    
    @IBOutlet weak var weibo: UIButton!
    
    @IBOutlet weak var weixin: UIButton!
    
    
    
    
    
    
    class func visitorView() ->WMVisitorView{
        
        let nib = UINib(nibName: "WMVisitoriew", bundle: nil)
        let v = nib.instantiate(withOwner: nil, options: nil)[0]as! WMVisitorView
        // 从 xib  加载的视图  默认是  600 ＊600 的
        v.frame = UIScreen.main().bounds
        return v
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    

}
    

 
