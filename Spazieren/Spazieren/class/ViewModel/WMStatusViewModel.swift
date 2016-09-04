
import Foundation

// 单条微博的视图模型 


//  如果 没有 任何父类 如果希望在开发的时候   输出 调试信息   需要：
//1。 遵守CustomStringConvertible  协议 
//2.实现dexcription 计算型属性


//MARK: 关于表格的优化
//1.  尽量少计算 所有需要的素材  提前准备好 

//2.不要设置 圆角半径   所有有关  渲染的 属性  都要注意 
//3.不要动态创建控件  所有要显示的 控件  都提前准备  根句数据   显示 还是决定   用内存 换cpu的 压力
//4.cell 中控件的  层次越少越好 数量越少越好 
//5.到底快还是慢  要测试 不要 推测  最合理的优化

//MARK: 没有父类 需要打印  信息  必须 遵守 customStringConvertible

class WMStatusViewModel:CustomStringConvertible{
    
    // 微博模型 
    var status:WMStatus
    // 会员图标   存储型属性
    var memberIcon:UIImage?
    // 认证类型 -1  没有认证 0 认证用户  2 3 5 企业用户  220 达人
    var vipIcon:UIImage?
    // 转发文字
    var retweetedsStr:String?
    // 评论文字
    var commetsStr:String?
    
    //赞文
    var likeStr:String?
    
    // 来源文字
    //var sourceStr:String?
    
    
    //配图视图的大小
    var pictureViewSize = CGSize()
    //
    // 如果是被转法微博   原创微博部分 一定没有图 
    var picURLs:[WMStatusPicture]?{
        // 如果有 被转发的微博  返回被转发微博的配图   没有 就返回原创微博的配图
        // 都没有就返回nil
        return status.retweeted_status?.pic_urls ?? status.pic_urls
    }
    
    //微博正文的属性文本
    //var statusAttrText:AttributedString?
    
    // 被转发微博的属性文本
    //var retweetedAttrText:AttributedString?
    
    // 被转发微博的文字
    var retweetedText:String?
    //行高
    var rowHeight:CGFloat = 0
    
    
    
    
    //MARK:初始化
    
    init(model:WMStatus){
        
        self.status = model
        if model.user?.mbrank > 0 && model.user?.mbrank < 7
        {
            let imageName = "common_icon_membership_level\(model.user?.mbrank ?? 1)"
            memberIcon = UIImage(named: imageName)
            }
        // 认证图标
        switch model.user?.verified_type ?? -1 {
        case 0:
            vipIcon = UIImage(named: "avatar_vip")
        case 2,3,5:
            vipIcon = UIImage(named: "avatar_enterprise_vip")
        
        case 220:
           vipIcon =  UIImage(named: "avatar_grassroot")
        default:
            break
        }
        
        // 设置底部字符串
        // 测试超过 1w 的 数字
        
        //model.reposts_count = 9999964
        retweetedsStr = countString(count: model.reposts_count, defalutStr: "转发")
        commetsStr = countString(count: model.comments_count, defalutStr: "评论")
        likeStr = countString(count: model.attitudes_count, defalutStr: "赞")
       
        // 计算配图模型的大小
        // 有原创的  就计算原创的   有转发的 就计算转发的
        
        pictureViewSize = calcPictureViewSize(count:picURLs?.count)
        // 被转发微博的文字
        retweetedText = "@" + (status.retweeted_status?.user?.screen_name ?? " ")
            + ":"
            + (status.retweeted_status?.text ?? "")
        
        //设置来源字符串
        //sourceStr = "from " + (model.source?.ev_href()?.text ?? "")
        
        
        // 计算行高
        updateRowHeight()
        
        
    }
    
    
    var description:String{
        
        return status.description
        
    }
    
    
    
    //MARK:缓存行高
    //根据当前的视图模型 计算行高
    func updateRowHeight(){
        //UI 间距 常数的 设置
        let margin:CGFloat = 12
        let iconHeight:CGFloat = 34
        let toolBarHeight :CGFloat = 35
        // 保存高度的  变量 声明  和初始化   完成后 赋值给 模型中的 属性
        var height:CGFloat = 0
        
        //boundingRect 参数
        //正文的 宽高  区域   宽就是 正文的区域宽度  高尽量大   因为 要换行    宽度固定  高度根据行数( 内容 字体 区域宽度 决定高度多少  )  自动生成
        let viewSize = CGSize(width: UIScreen.wm_screenWidth() - 2*margin, height: CGFloat(MAXFLOAT))
        //  原创区域字体
        let originalFont = UIFont.systemFont(ofSize: 15)
        // 转发微博字体
        let retweetedFont = UIFont.systemFont(ofSize: 14)
        
        //1. 计算顶部位置   无论是 远传 还是  转发  都有的
        height = 2*margin + iconHeight + margin
        //2.正文高度
        if let text = status.text {
            //1. 预期尺寸 宽度固定  高度尽量大
            // 选项 换行文本 统一使用 ..usesLineFragmentOrigin
            //attributes: [NSFontAttributeName:originalFont]   字典属性
          height+=(text as NSString).boundingRect(with: viewSize, options: [.usesLineFragmentOrigin], attributes: [NSFontAttributeName:originalFont], context: nil).height
            
            
        }
        
        
        
        //判断 是否 是  转发文本
        if status.retweeted_status != nil{
            
            
            height += 2*margin
            //  此处要使用  retweetedText  这个才是 需要显示的 完整的   文字  还有  "@"   和 ":"
            
            if let text = retweetedText{
                height += (text as NSString).boundingRect(with: viewSize, options:[.usesLineFragmentOrigin], attributes: [NSFontAttributeName:retweetedFont], context: nil).height
                
                
                
            }
        }
        //加上 配图视图的高度
        height += pictureViewSize.height
        // 加上间距
        height += margin
        // 加上底部工具栏
        height  += toolBarHeight
        
        //计算出来的  预测行高
        rowHeight = height
        
        
    }
    
    
    
       // 使用网络缓存的 单张图象 更新配图视图的大小
    //MARK:更新单张 图片的配图视图
    // 新浪针对 单张图片 都是缩略图 但是  偶尔 会有 一张 特别大（7000*9000）的   图片 怎么 处理
    // 关于长微博   长到 宽度  只有一个点
    func updateSingleImageSize(image:UIImage){
        var size = image.size
        // 设置 判断 过宽 过窄的  常量
        let  maxWidth:CGFloat = 300
        let  minWidth:CGFloat = 40
        let  minHeight:CGFloat = 5
        //MARK:过宽图象处理

        if size.width > maxWidth {
            // 设置最大宽度
            size.width = maxWidth
            //等比例调整高度
            size.height = size.width * image.size.height/image.size.width
        }
        
        //MARK: 图象过窄图象 处理 
        if size.width < minWidth {
            // 设置最大宽度
            size.width = minWidth
            //要特殊处理高度   否则 太高 影响体验   /4
            size.height = size.width * image.size.height/image.size.width/4
        }
        
        
        //特例  图片 本身就很窄  很长  定义一个 minHeight
        // 如果看到  比较疑惑的  分支 千万 不要动
        if size.height < minHeight{
            size.height = minHeight
    
        }
        
        // 注意 尺寸 需要加上 顶部的 12 歌 间距 便于 布局
        size.height+=WMStatusPictureViewOutterMargin
        
        // 重新设置 配图视图的大小
        pictureViewSize = size
        
        //更新行高
        updateRowHeight()
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    //计算配图的的配图视图的大小
    // 加上private  外部无法访问
    private func calcPictureViewSize(count:Int?) ->CGSize{
        if  count == 0  || count == nil {
            return CGSize()
        }
        
        //计算配图视图的宽度
        // 常数准备 
        // 在 common 里面
       
        //根据 count 计算行数  count: 1-  9
        let row = (count! + 1)/3 + 1
               //根据行数 算高度 height
         //2. 计算高度
        var  height = WMStatusPictureViewOutterMargin
                 height += CGFloat(row)*WMStatusPicturesItemWidth
                 height +=  CGFloat(row - 1) * WMStatusPictureViewInnerMargin
        //let WMStatusPictureViewHeight =
        
        
        
        
        return CGSize(width:WMStatusPictureViewWidth , height: height)
    }
    
    
    
    
    
    
    
    //给定一个数字  返回一个描述结果
    private func countString(count:Int,defalutStr:String) -> String{
        if count == 0{
            return defalutStr
        }
        if count < 10000 {
            return count.description
        }
        return String(format: "%.02f万",Double(count)/10000)
        
    }
    
    
    
    
}
