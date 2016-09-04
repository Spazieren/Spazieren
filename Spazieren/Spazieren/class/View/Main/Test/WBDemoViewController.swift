//
//
import UIKit

class WMDemoViewController: WMBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //
        title = "No.\(navigationController?.childViewControllers.count ?? 0)"

        // Do any additional setup after loading the view.
    }
    //MARK:---@objc private func showNext----
    @objc private func showNext(){
        let vc = WMDemoViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    

}
//MARK:---<#tips#>----
extension WMDemoViewController{
    
    override func setupTableView() {
        super.setupTableView()
         navItem.rightBarButtonItem = UIBarButtonItem(title: "Next", target: self, action: #selector(showNext))
    }
//    override func setupUI() {
//        super.setupUI()
//        //navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .Plain, target: self, action: #selector(showNext))
//        let btn:UIButton = UIButton.cz_textButton("下一个", fontSize: 12, normalColor: UIColor.darkGrayColor(), highlightedColor: UIColor.orangeColor())
//        btn.addTarget(self, action: #selector(showNext), forControlEvents: .TouchUpInside)
//        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btn)
       
    }
    
