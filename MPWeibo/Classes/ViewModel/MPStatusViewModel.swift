//
//  MPStatusViewModel.swift
//  MPWeibo
//
//  Created by Maple on 16/7/22.
//  Copyright © 2016年 Maple. All rights reserved.
//

import UIKit

class MPStatusViewModel: NSObject {
  //MARK: - 属性
  ///定义单例对象
  static let sharedStatusViewModel = MPStatusViewModel()
  
  var loadingStatus: Bool = false
  /**
   发送微博
   
   - parameter status: 微博
   */
  func sendStatus(status: String, image:UIImage?, completion: (error: NSError?) -> Void) {
    //https://api.weibo.com/2/statuses/update.json
    //https://upload.api.weibo.com/2/statuses/upload.json
    let account = MPUserAccountViewModel.sharedUserAccountViewModel.userAccount
    let parameters: [String: AnyObject] = ["access_token": account!.access_token!, "status": status]
    //根据是否有图片，发送不同的请求
    if image == nil {
      let urlString = "2/statuses/update.json"

      MPHttpTool.sharedHttpTool.request(MPNetworkMethod.POST, URLString: urlString, parameters: parameters, progress: nil, success: { (task, responseObject) in
        completion(error: nil)
      }) { (task, error) in
        completion(error: error)
      }
    }else {
      let data = UIImagePNGRepresentation(image!)
      let urlString = "https://upload.api.weibo.com/2/statuses/upload.json"
      MPHttpTool.sharedHttpTool.upload(urlString, parameters: parameters, constructingBodyWithBlock: { (formData) in
        //拼接需要上传的数据，name必须与服务器要求的一致
        formData.appendPartWithFileData(data!, name: "pic", fileName: "test", mimeType: "image/png")
        }, success: { (task, responseObject) in
          completion(error: nil)
        }, failure: { (task, error) in
          completion(error: error)
      })
    }
    
  }
  
  /**
   加载微博数据
   since_id: 下拉刷新参数
   max_id:   上拉刷新参数
   */
  func loadStatusData(since_id: Int64, max_id: Int64, compeletion: (error: NSError?, statusArray: [MPStatus]?) -> Void) {
    //判断是否正在加载信息
    // 判断是否有人正在加载数据
    if loadingStatus {
      // 有人正在加载数据, 需要让调用的人知道因为有人在加载数据,我们没去加载数据了.
      // 自定义错误
      // domain: 表示错误的范围, 自定义
      // code: 表示错误的编码,自定义
      let error = NSError(domain: "cn.itheima.network.loadstatus", code: -1, userInfo: ["errorDescription" : "有人正在加载微博数据,直接返回了"])
      compeletion(error: error, statusArray: nil)
      return
    }
    loadingStatus = true
    MPStatusDAL.sharedStatusDAL.loadStatus(since_id, max_id: max_id) { (error, statusArray) in
      if error != nil {
        print(error)
        self.loadingStatus = false
        return
      }
      if statusArray != nil && statusArray!.count > 0 {
        var statusModel: [MPStatus] = [MPStatus]()
        for dic in statusArray! {
          let status = MPStatus(dic: dic)
          statusModel.append(status)
        }
        //返回数据
        compeletion(error: nil, statusArray: statusModel)
        self.loadingStatus = false
      }else {
        //没有出错，但没有数据
        compeletion(error: nil, statusArray: nil)
        self.loadingStatus = false
      }
    }
  }
}
