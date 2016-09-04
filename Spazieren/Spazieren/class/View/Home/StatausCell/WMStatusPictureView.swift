//
//  
import UIKit

class WMStatusPictureView: UIView {
    var viewModel:WMStatusViewModel?{
        didSet{
            
            calcViewSize()
            //设置urls
            urls = viewModel?.picURLs
            
            
        }
    }
    //MARK: 根据配图视图的大小  调整显示内容 
    private func calcViewSize(){
        //单兔
        if viewModel?.picURLs?.count == 1{
        
        let viewSize = viewModel?.pictureViewSize ?? CGSize()
        
        // 处理宽度
        //单图  根据 配图视图的 大小 据该 sunviews[0]的宽高
                        //获取subviews[0]
        let v = subviews[0]
        v.frame = CGRect(x: 0, y: WMStatusPictureViewOutterMargin, width: viewSize.width, height: viewSize.height - WMStatusPictureViewOutterMargin)
        
        }else
            //  多图 /无图 恢复 subviews［0］的宽高保证  九宫格的 布局
        {
         let v = subviews[0]
            v.frame = CGRect(x: 0, y: WMStatusPictureViewOutterMargin, width: WMStatusPictureViewWidth, height: WMStatusPictureViewWidth)
            
            
        }
        
        
        //修改高度约束
         heightCons.constant = viewModel?.pictureViewSize.height ?? 0
        
        
    }
    
    
    
    //微博配图视图  缩略图的地址
    
    private var urls:[WMStatusPicture]?{
        
        didSet{
            // 1. 隐藏所有的imageview
            for v in subviews{
                v.isHidden = true
            }
            //遍历 urls 数组 顺序设置图像
            var index = 0
            
            
            for url:WMStatusPicture in urls ?? [] {
                let iv = subviews[index] as! UIImageView
                // 4张图像的处理
                if index == 1 && urls?.count == 4 {
                    index += 1
                }
                
                // 设置图像  thumbnail_pic
                iv.wm_setImage(url.thumbnail_pic, placeholderImage: nil)
                //图像ishidden  设置回来
                iv.isHidden = false
                // 进入下一次循环  设置条件
                index += 1
            }
            
            
        }
    }
    
    @IBOutlet weak var heightCons :NSLayoutConstraint!
    
    //
    override func awakeFromNib() {
        setupUI()
    }
    

}
//extension

extension WMStatusPictureView{
    // cell 中所有的控件都是提前准备好的
    // 设置的时候 根据数据决定显示
    //不要动态创建控件
    
    private func setupUI(){
        // 设置背景颜色
        backgroundColor = superview?.backgroundColor 
        
        //超出边界的不显示
        clipsToBounds = true
    let count = 3
    let rect = CGRect(x: 0, y: WMStatusPictureViewOutterMargin, width: WMStatusPicturesItemWidth, height: WMStatusPicturesItemWidth)
    for i in 0..<count*count {
     
        let iv = UIImageView()
        //iv.backgroundColor = UIColor.red()
           // 设置iv contentmode
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        //row
        let row = CGFloat(i/count)// 0 1 2
        let col = CGFloat(i%count)
        let xOffset = col*(WMStatusPicturesItemWidth + WMStatusPictureViewInnerMargin)
        let yOffset = row*(WMStatusPicturesItemWidth + WMStatusPictureViewInnerMargin)
        iv.frame = rect.offsetBy(dx: xOffset, dy: yOffset)
        addSubview(iv)
        
    }
    
    }
    
    
}
