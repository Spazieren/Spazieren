//
//  WBComposeViewController.swift
//  传智微博
//
//  Created by will on 8/28/16.
//  Copyright © 2016 connected. All rights reserved.
//

import UIKit
// 撰写微博控制器
class WBComposeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.cz_random()
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
