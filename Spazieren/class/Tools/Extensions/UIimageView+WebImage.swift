
import Foundation
import SDWebImage
extension UIImageView{
    
    //// 包装 隔离 sdwebimage  设置 图像函数                                    //是否头像
    func wm_setImage(_ urlString:String?,placeholderImage: UIImage?,isAvatar:Bool = false){
        // 处理url
        
        guard let urlString = urlString,
            url = URL(string: urlString) else{
            image = placeholderImage
            return
        }
        
        // 可选值 只是用在swift 中,oc 有的时候 使用  ！  依旧可以传入nil 
        //［weak self］  表示 在 后面代码块 self  是弱引用  
        sd_setImage(with: url, placeholderImage: placeholderImage, options: [], progress: nil) { [weak self](image, _, _, _) in
            // 完成回调   对头像进行判断 
            if isAvatar{
                self?.image = image?.wm_avatarImage(self?.bounds.size)
            }
            
            
            
        
        }
    }
}
