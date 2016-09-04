//
//
//
//
//




import UIKit

class WMRunViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.wm_random()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "exit", target: self, action: #selector(close))
        
    }
    //
    @objc private func close(){
      dismiss(animated: true) { 
        print("")
        }
    }
    //
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
