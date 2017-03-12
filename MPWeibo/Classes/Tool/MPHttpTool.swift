//
//  MPHttpTool.swift
//  MPWeibo
//
//  Created by Maple on 16/7/19.
//  Copyright © 2016年 Maple. All rights reserved.
//

import UIKit
import AFNetworking

enum MPNetworkMethod: String {
  case GET = "GET"
  case POST = "POST"
}
class MPHttpTool: NSObject {
  
  var manager: AFHTTPSessionManager
  //定义单例对象
  static let sharedHttpTool:MPHttpTool = MPHttpTool()

  //定义为私有方法，这样外部则不可以调用init方法创建新对象
  private override init() {
    let baseUrl = NSURL(string: "https://api.weibo.com/")
    manager = AFHTTPSessionManager(baseURL: baseUrl)
    manager.responseSerializer.acceptableContentTypes?.insert("text/plain")
  }
  
  func upload(URLString: String, parameters: AnyObject?, constructingBodyWithBlock:((formData: AFMultipartFormData) -> Void)?, success: ((task: NSURLSessionDataTask, responseObject: AnyObject?) -> Void)?, failure: ((task: NSURLSessionDataTask?, error: NSError) -> Void)?) {
    manager.POST(URLString, parameters: parameters, constructingBodyWithBlock: constructingBodyWithBlock, progress: nil, success: success, failure: failure)
  }
  
  private func requestGET(URLString: String, parameters: AnyObject?, progress: ((progress: NSProgress) -> Void)?, success: ((task: NSURLSessionDataTask, responseObject: AnyObject?) -> Void)?, failure: ((task: NSURLSessionDataTask?, error: NSError) -> Void)?) {
    manager.GET(URLString, parameters: parameters, progress: progress, success: success, failure: failure)
  }
  
  private func requestPOST(URLString: String, parameters: AnyObject?, progress: ((progress: NSProgress) -> Void)?, success: ((task: NSURLSessionDataTask, responseObject: AnyObject?) -> Void)?, failure: ((task: NSURLSessionDataTask?, error: NSError) -> Void)?) {
    manager.POST(URLString, parameters: parameters, progress: progress, success: success, failure: failure)
  }
  
  /**
   网络封装请求
   
   - parameter method:     请求方式
   - parameter URLString:  请求url
   - parameter parameters: 参数
   - parameter progress:   进度回调
   - parameter success:    成功回调
   - parameter failure:    失败回调
   */
  func request(method: MPNetworkMethod, URLString: String, parameters: AnyObject?, progress: ((progress: NSProgress) -> Void)?, success: ((task: NSURLSessionDataTask, responseObject: AnyObject?) -> Void)?, failure: ((task: NSURLSessionDataTask?, error: NSError) -> Void)?) -> Void {
    switch method {
    case .GET:
      requestGET(URLString, parameters: parameters, progress: progress, success: success, failure: failure)
    case .POST:
      requestPOST(URLString, parameters: parameters, progress: progress, success: success, failure: failure)
    }
  }

}
