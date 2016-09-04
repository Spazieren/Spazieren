//
//
import UIKit

class WMStatusCell: UITableViewCell {
    //微博视图模型
    var viewModel:WMStatusViewModel?{
        didSet{
            
            // 微博文本
            statusLabel?.text = viewModel?.status.text
            // 设置名字
            nameLabel.text = viewModel?.status.user?.screen_name
            // 设置会员图标  直接获取  属性   不需要 计算 
            memberIconView.image = viewModel?.memberIcon
            //认证图标
            vipIvonView.image = viewModel?.vipIcon
            // 用户头像
            iconView.wm_setImage(viewModel?.status.user?.profile_image_url, placeholderImage: UIImage(named: "avatar_default_big"),isAvatar: true)
            // 底部工具栏 
            toolBar.viewModel = viewModel
            // 配图视图视图模型
            
            pictureView.viewModel = viewModel
           // 设置被转发微博的文字  原创的没有该属性  是可选的 属性
            retweetedLabel?.text = viewModel?.retweetedText
            // 设置来源  在 返回的 json 中  yymodel  会 转进来
            // sourceLabel.text = viewModel?.sourceStr
            sourceLabel.text = viewModel?.status.source
            

            
        }
        
    }
    
    
    
    //   头像
    @IBOutlet weak var iconView: UIImageView!
    // 姓名
    @IBOutlet weak var nameLabel: UILabel!
    // 会员
    @IBOutlet weak var memberIconView: UIImageView!
    // 时间
    @IBOutlet weak var timeLabel: UILabel!
    // 来源
    @IBOutlet weak var sourceLabel: UILabel!
    //vip 认证 在头像右下角
    @IBOutlet weak var vipIvonView: UIImageView!
    //微博正文
    @IBOutlet weak var statusLabel: UILabel!
    // 底部工具栏
    @IBOutlet weak var toolBar: WMStatusToolBar!
    // 配图视图
    @IBOutlet weak var pictureView: WMStatusPictureView!
    //被转发微博的 连线  原创微博 没有此控件 要用问号
    
    @IBOutlet weak var retweetedLabel: UILabel?
    
    
    
    //@IBOutlet weak var pictureTopCons: NSLayoutConstraint!
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
        //MARK:---offsetScreen-rendered    离屏渲染  异步绘制
        self.layer.drawsAsynchronously = true
       
        //删格化 是栅格化 -异步绘制按成之后  会生成 一张 独立的图象 ，cell 在屏幕上滚动的   
        //本质上 就是这张图片 ，而 cell  优化  要尽量减少 图层的 数量  相当于 只有 一层  ，
        //能不快？停止滚动 之后 可以接受监听
        //
        self.layer.shouldRasterize = true
        
        //注意点： 图象显示 不清楚 ，该术语  是 平面设计师 的 称呼
        //使用注意：必须指定分辨率

        self.layer.rasterizationScale = UIScreen.main().scale
        
    }
    
    
    
    
    
    
    
    
    
    
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
