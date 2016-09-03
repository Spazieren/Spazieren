

import Foundation
extension String{
    
    //从当前字符串中  提取链接和文本
    // swift  提供了 元组的  可以同时返回多个值 
    // 如果是oc 可以反悔字典/ 自定义对象/指针的指针
    func ev_href() ->(link:String,text:String)?{
        // 0.匹配方案
        let pattern = "<a href=\"(.*?)\".*?>(.*?)</a>"
        //创建正则表达式 并匹配第一项
        guard let regx = try? RegularExpression(pattern: pattern, options: []),
                result = regx.firstMatch(in: self, options: [], range: NSRange(location: 0, length: characters.count)) else{
                return nil
        }
        //2.获取结果
        let link = (self as NSString).substring(with: result.range(at:1))
        let text = (self as NSString).substring(with: result.range(at:2))
        //
        print("\(link) + \(text)")
        

        return (link,text)
    }
}
