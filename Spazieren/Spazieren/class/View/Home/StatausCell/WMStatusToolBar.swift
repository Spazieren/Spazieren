//
//
//

import UIKit

class WMStatusToolBar: UIView {
    //
    var viewModel :WMStatusViewModel?{
        didSet{
//            retweetedButton.setTitle("\(viewModel?.status.reposts_count)", for: [])
//             commentButton.setTitle("\(viewModel?.status.comments_count)", for: [])
//             likeButton.setTitle("\(viewModel?.status.attitudes_count)", for: [])
            retweetedButton.setTitle(viewModel?.retweetedsStr, for: [])
            commentButton.setTitle(viewModel?.commetsStr, for: [])
            likeButton.setTitle(viewModel?.likeStr, for: [])
            
        }
    }
    
    
    
    
    
    // 拖线拖不进来 可以手动写  然后连线  由代码 到 xib
    @IBOutlet weak var retweetedButton:UIButton!
    @IBOutlet weak var commentButton:UIButton!
    @IBOutlet weak var likeButton:UIButton!
    
    
    
}
