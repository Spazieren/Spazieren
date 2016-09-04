//
//  WMHomeViewController.swift
//  传智微博
//
//  Created by will on 8/15/16.
//  Copyright © 2016 connected. All rights reserved.
//

import UIKit

// 原创微博的  可复用id 
private let retweetedcellId = "retweetedcellId"

 //定义的全局常量   尽量使用private 当前文件可以访问， 否则到处 都可以访问
private let originalcellId = "originalcellId"

class WMHomeViewController: WMBaseViewController {
    // 列表视图模型
    private lazy var listViewModel = WMStatusListViewModel()
    
    
    //实现父类的 数据源方法
    override func loaddata() {
        listViewModel.loadStatus(self.isPullup) { (isSucess,shouldRefresh) in
           print("最后一条\(self.listViewModel.statusList.last?.status.text)")
            
            self.refreshControl?.endRefreshing()
            // 恢复上啦刷新标记
            self.isPullup = false
            if shouldRefresh{
            // reloaddata
                self.tableview?.reloadData()
            }
        }
     }
    
//        //MARK:---调用抽取的 新浪微博数据获取参数
//
//        WMNetworkManager.shared.statusList { (list, isSuccess) in
//            print(list)
//        }
//
   @objc  private func showFriends(){
     print(#function)
    let vc = WMDemoViewController()
    //MARK:---隐藏下面的bar  当跳转的时候----

    vc.hidesBottomBarWhenPushed = true
    
        // push   是由 nav 做的
    navigationController?.pushViewController(vc, animated: true)
        
    }

   

}
//MARK:---表格数据源方法 具体方法实现 不需要super

extension WMHomeViewController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.statusList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 自定义cell  需要返回 指定类型的cell  前面 不是可选类型  转换类型 用as!  如 下 as! WMStatusCell
        // 取出视图模型  做判断   可复用cell 类型 
           let vm = listViewModel.statusList[indexPath.row]
        //有转发 就有转发的cell 模式    没有救用原创的 cell
        let cellID = (vm.status.retweeted_status != nil) ? retweetedcellId:originalcellId
        
        //
        // 取cell  会调用代理方法 (如果有)  没有就会找到cell  按照自动布局的规则从上向下计算  找到向下的约束  从而计算动态的行高
        

        let cell = tableview?.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! WMStatusCell
        
     
        // 设置cell 的博文
        
        cell.viewModel = vm
        // 返回cell 
        return cell
    }
    
    //MARK:重写父类的 height for at indexpath
    // 父类(base)  必须 实现代理方法     子类 才可以重写  swift 3.0  才需要 2.0  不需要 
    ///行高  for row at indexpath
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //  根据 indexpath  获取视图模型
        let vm = listViewModel.statusList[indexPath.row]
        //返回计算好的 行高
        return vm.rowHeight
    }
    
    
    
    
    
    

}



//MARK:---设置界面----
extension WMHomeViewController{
    //重写父类的方法
    override func setupTableView() {
        super.setupTableView()
        
        navItem.leftBarButtonItem = UIBarButtonItem(title: "friends", target: self, action: #selector(showFriends))
        
        // 由于在登录成功有  已经 将导航栏左右item 清空  view 清空  再次加载view  会调用 对应的构造方法  构建正确的ui
        //navItem.rightBarButtonItem = nil
        
        // 注册原型cell
        //tableview?.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        //
        // UINib(nibName: "WMStatusNormalCell", bundle: nil)
        // 注册 cell  自定义的类型   不用系统的
        tableview?.register(UINib(nibName: "WMStatusNormalCell", bundle: nil), forCellReuseIdentifier: originalcellId)
        //
        tableview?.register(UINib(nibName: "WMStatusRetweetedCell", bundle: nil), forCellReuseIdentifier: retweetedcellId)
        
        // 设置行高
        // 取消自动行高
        //tableview?.rowHeight = UITableViewAutomaticDimension  //自动设置
        tableview?.estimatedRowHeight = 300   // 预估行高
        // 取消分割线
        tableview?.separatorStyle = .none
        
        
        setupNavTitle()
        
        //
    
        
    }
    
    
    //设置导航栏标题
    func setupNavTitle(){
        
        let title = WMNetworkManager.shared.userAccount.screen_name
        let button = WMTitleButton(title: title)
        navItem.titleView = button
        button.addTarget(self, action: #selector(clickTitleButton), for: .touchUpInside)
        
    }
    @objc func clickTitleButton(_ btn:UIButton){
        //设置btn 的状态
       btn.isSelected = !btn.isSelected
        
        
        
        
    }
    
    
    
    
}
