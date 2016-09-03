
import UIKit
//1.  使用TextKit 接管Label 的底层实现  ‘绘制’ textStorage 的文本内容
//2.使用 正则  表达式 过滤 URl  设置URL的 特殊显示
//3.交互
//
//UILabel  默认不能 垂直顶部对齐  使用 TextKit 可以
//  在IOS 7.0 之前  要实现  这样的 效果 需要使用 CoreText  很繁琐
//
class WMLabel: UILabel {
    // 重写 属性 - 进一步  体会 TextKit  接管  底层的实现
    //一旦内容变化   需要 让 textStorage 响应 变化
    // MARK:重写属性
    override var text: String?{
        didSet{
            // 重新 准备文本
            prepareTextContent()
        }
    }
    
    
    // MARK:构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareTextSystem()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepareTextSystem()
        //fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:点击  变色 测试
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //获取用户点击位置
        guard let location = touches.first?.location(in: self) else{
            return
        }
        //获取当前点中的索引
        let idx = layoutManager.glyphIndex(for: location, in: textContainer)
        print("点我了\(idx)")
        // 判断 idx  是否在 urls 的ranges 范围内  如果在 就高亮
        for  r in urlRanges ?? []{
            //NSRange  调入头文件 可以看到 该方法 
            if NSLocationInRange(idx, r){
                print("需要高亮")
                // 修改点中的  文本的 字体属性 
                textStorage.addAttributes([NSForegroundColorAttributeName:UIColor.blue()], range: r)
                // 如果 需要重绘  需要调用     setNeedsDisplay()   但是 不是 drawRect
                setNeedsDisplay()
            }else{
                print("没搓到")
            }
        }
        
        
    }
    
    
    
    
    
    
    // 绘制文本
    // 在IOS 中   绘制工作 是类似油画 似的  后绘制的内容 会把之前 绘制的 内容 覆盖掉
    // 尽量 避免 使用 带透明度的颜色 会严重影响性能
    override func drawText(in rect: CGRect) {
        let range = NSRange(location: 0, length: textStorage.length)
        //  绘制背景
        layoutManager.drawBackground(forGlyphRange: range, at: CGPoint())
        // 绘制Glyphs  字形
        layoutManager.drawGlyphs(forGlyphRange: range, at: CGPoint())
        
    }
    //
    override func layoutSubviews() {
        super.layoutSubviews()
        //指定绘制文本的区域
        textContainer.size = bounds.size
    }
    
    // MARK:textkit的核心对象
    // 属性文本存储
    private lazy var textStorage = NSTextStorage()
    //负责文本  ‘字型’布局
    private  lazy  var layoutManager = NSLayoutManager()
    //设定文本绘制的范围
    private lazy var textContainer = NSTextContainer()
    
}

// MARK:设置TextKit  核心对象
private extension WMLabel{
    //准本文本系统
    func prepareTextSystem(){
        // 0.开启用户交互
        isUserInteractionEnabled = true
        
        //1.准本文本内容
        prepareTextContent()
        //2.设置对象的属性
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
    
    }
    
    //准本文本内容  使用 TextKit 接管label 的内容
    func prepareTextContent(){
        if let attributedText = attributedText{
        textStorage.setAttributedString(attributedText)
        } else if let text = text{
        textStorage.setAttributedString(AttributedString(string: text))
        }else{
           textStorage.setAttributedString(AttributedString(string: ""))
        }
        
        // 遍历范围数组  设置URL 文字的属性
        for r in urlRanges ?? []{
            textStorage.addAttributes([
                NSForegroundColorAttributeName:UIColor.red(),
                NSBackgroundColorAttributeName:UIColor.init(white: 0.9, alpha: 1.0)
                
                ], range: r)
            
        }
        
        
        
    }
}

// MARK:正则表达式 函数 
private extension WMLabel{
    //返回textStorge 中  的 URL range 的数组 
    var  urlRanges:[NSRange]?{
        //1.正则表达式
        let pattern = "[a-zA-z]*://[a-zA-Z0-9/\\.]*"
        guard let regx = try?RegularExpression(pattern: pattern, options: [])else{
            return nil
        }
        // 多重匹配
        let matches = regx.matches(in:textStorage.string, options: [], range: NSRange(location: 0, length: textStorage.length))
        
        // 遍历 matches 结果 数组 生成range 的 数组
        var ranges = [NSRange]()
        
        for  m in matches{
            ranges.append(m.range(at: 0))
        }
        
        return ranges
    }
    
    
    
    
}


































