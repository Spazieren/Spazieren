//
//  WMStatusListViewModel.swift
//  传智微博
//
//  Created by will on 8/18/16.
//  Copyright © 2016 connected. All rights reserved.
//


import Foundation
import SDWebImage
// 微博数据列表视图模型
/*
 如果类需要使用KVC 或者 使用字典转模型  设置对象值 类就需要继承自NSOBject
 如果类只是 包装一些代码  方法 可以不用任何父类  好处 是更加轻量级
 如果用OC 写 都要继承自根类 就需要继承自NSOBject
 
 */
private let maxPullupTryTimes = 3
class WMStatusListViewModel{
    // 微博视图模型数组 懒加载
    lazy var statusList = [WMStatusViewModel]()
    //
    private var pullupErrorTimes = 0
    
    
    //完成 回调  网络请求 是否成功 
    func loadStatus(_ pullUp:Bool,completion:(isSucess:Bool,hasMorePullUp:Bool)-> ()){
        
        // 判断是否上啦刷新  并且检查❌次数
        if pullUp && pullupErrorTimes > maxPullupTryTimes {
            completion(isSucess: true,hasMorePullUp: false)
            return
        }
        
    
        //下拉刷心
        //since_id  取出数组中的第一条微博的id
        let since_id = pullUp ? 0 :(statusList.first?.status.id ?? 0)
        
        let max_id = !pullUp ? 0: (statusList.last?.status.id ?? 0)
        
        
        
        
        
        
        WMNetworkManager.shared.statusList(since_id,max_id: max_id) { (list, isSuccess) in
            // 判断网络 加载  是否成功   r如果 失败就 返回
            
            if !isSuccess{
                completion(isSucess: false, hasMorePullUp: false)
                return
                
            }
            // 遍历 字典数组   字典 转模型  －》视图模型 
            var array = [WMStatusViewModel]()
            
            
            
            for  dict in list ?? []{
                print("____________________")
                print( "\(dict)")
                print(dict["pic_urls"])
                
                
                print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^")
                //  创建微博模型
                let status = WMStatus()
                // 用字典设置模型属性
                status.yy_modelSet(with: dict)
                // 使用 微博模型  创建 微博视图模型 
                
                let viewModel = WMStatusViewModel(model: status)
                // 添加到数组
                
                array.append(viewModel)
                // print(array)

                
            }
            

//            //  字典转模型
//            var array = [WMStatusViewModel]()
//            // 遍历服务器返回的 字典数组
//            for dict in list ?? []{
//                guard  let model = WMStatus.yy_model(with:dict) else {
//                    // 如果 判断失败结束当前 循环  进入 下一轮 循环
//                    continue
//                }
//                // 将视图模型添加到 数组
//                array.append(WMStatusViewModel(model:model))
//
//                
//            }
//            
//
//            //字典转模型      所有第三方框架   都支持 嵌套的 字典转模型
//            guard  let array = NSArray.yy_modelArray(with: WMStatus.self, json: list ?? []) as? [WMStatus] else {
//                completion(isSucess: isSuccess,hasMorePullUp: false)
//                return
//            }
//            
            
            print("刷新了\(array.count)跳数据 \(array)")
            // 拼接数据
            if pullUp{
                self.statusList+=array
            }else{
                // 下拉刷心 应该将结果数组拼接在数组前面
                self.statusList = array + self.statusList
                }
            
            //判断  上啦刷新的数据量
            if pullUp && array.count == 0{
                self.pullupErrorTimes+=1
                completion(isSucess: isSuccess, hasMorePullUp: false)
            }else{
                // 真正 有数据的   回调   可以缓存只有一张图象的 其它的不缓存 逻辑在函数体内
                //
                self.cacheSingleImage(list: array, completion: completion)
                
                
                //completion(isSucess: isSuccess, hasMorePullUp: true)
            }
            
        }
        
    }
    
    
    ///  本次下载的 视图模型  数组
    // --parameter list:本次下载的视图模型数组
    //MARK:应该缓存完单张图片后  并且修改过 配图视图的大小之后  再回调  才能保证表格等比例显示单张图象
    // 解决  将 网络请求  设置数据源  方法的 回调block/ 闭包 当作参数 传递给 本方法  在线程组 完成监听 确定缓存了单张图片后 在执行回调

    private func cacheSingleImage(list:[WMStatusViewModel],completion:(isSucess:Bool,hasMorePullUp:Bool)-> ()){
        // 调度组 
        let group = DispatchGroup()
        
        
        
        // 记录数据长度
        var length = 0
        // 遍历数组  有单张图象的 进行缓存
        for vm in list{
            //1.判断图象数量
            if vm.picURLs?.count != 1{
                continue
                // 结束该次循环 往上走  判断下一次 
                //  return 的话 整个函数  都步执行了
            }
            //2.代码执行到此处    vm 中 有且仅有一张图片
            guard let pic = vm.picURLs?[0].thumbnail_pic,
                url = URL(string:pic) else{
                    continue
                    //  跳出本次循环  继续执行下一次循环体
            }
            //3.下载图象
            //downloadimage  是 SDWEBImage 的核心方法
            //图象下载完成后  会自动保存在沙盒中 文件路径 是 url的  MD5
            //如果沙盒中已经存在 需要加载的图象  后续调用 sd  都会加载本地沙盒中的 缓存文件 , 不会再发器网络请求 同时 回调方法
            // 同样会调用  方法  还是 原来的方法  调用还是同样的调用  只是不会 发起网络请求   内部有判断逻辑
            //注意点： 如果缓存的 图象 很大 要找 后台要 接口
            //
            
            
            //A> 入组  后监听 后面的 block(最近的？？)
            group.enter()
            
            
            print("要缓存的是\(url)")
            
            //sdwebimage  下载图象
            SDWebImageManager.shared().downloadImage(with: url, options: [], progress: nil, completed: { (image, _, _, _, _) in
                // 将图象转换为二进制数据 
                if let image = image ,
                    data = UIImagePNGRepresentation(image){
                    //NSdata 是 length 属性
                    length+=data.count
                    
                    // 图象缓存成功   更新 配图视图的大小
                    vm.updateSingleImageSize(image: image)
                    
                    
                    
                }
                
                
                
                
                print("缓存的图象是\(image)")
                //B-> 调度组 出组  放在回调的 最后一句   调度组为空   且  出入是匹配的   则会执行  调度组的监听方法
                group.leave()
            })
            
            
            
        }
        //C-> 调度组入组  出组 完成  调度组为空  执行监听方法
       group.notify(queue: DispatchQueue.main) { 
        print("图象缓存完成 \(length/1024)K")
        
        // 执行闭包的回调
        completion(isSucess: true, hasMorePullUp: true)
        
        }
        
        
    }
    
    
    
    
    
    
}
