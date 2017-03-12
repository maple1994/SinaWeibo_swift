//
//  MPUserAccountViewModel.swift
//  MPWeibo
//
//  Created by Maple on 16/7/21.
//  Copyright © 2016年 Maple. All rights reserved.
//

import UIKit

/// userAccount类的工具类
class MPUserAccountViewModel: NSObject {
  //MARK: - 属性
  ///用户是否登陆
  var isLogin: Bool {
    get{
      return userAccount != nil
    }
  }
  ///定义单例对象
  static let sharedUserAccountViewModel = MPUserAccountViewModel()
  ///用户账号类
  var userAccount: MPUserAccount?
  
  //MARK: - 公开方法
  /**
   根据code获得accessToken，并保存用户信息到沙盒
   */
  func saveUserAccount(code: String, compeletion: (error: NSError?) -> Void) {
    let urlString = "https://api.weibo.com/oauth2/access_token"
    let parameters = ["client_id": client_id,
                      "client_secret": appSecret,
                      "grant_type": "authorization_code",
                      "code": code,
                      "redirect_uri": redirect_uri
    ]
    MPHttpTool.sharedHttpTool.request(MPNetworkMethod.POST, URLString: urlString, parameters: parameters, progress: nil, success: { (task, responseObject) in
      let dic = responseObject as! [String: AnyObject]
      self.userAccount = MPUserAccount(dic: dic)
      self.archiveAccount(self.userAccount!)
      //回调
      compeletion(error: nil)
    }) { (task, error) in
      compeletion(error: error)
    }

  }
  
  /**
   加载用户信息
   */
  func loadUserInfo(complete: (error: NSError?)->Void) {

    let urlString = "https://api.weibo.com/2/users/show.json"
    guard let access_token = userAccount?.access_token else{
      print("access_token为空")
      return
    }
    guard let uid = userAccount?.uid else {
      print("uid为空")
      return
    }
    
    let parameters = ["access_token": access_token,
                      "uid": uid,
    ]

    MPHttpTool.sharedHttpTool.request(MPNetworkMethod.GET, URLString: urlString, parameters: parameters, progress: nil, success: { (task, responseObject) in
      let dic: [String: AnyObject] = responseObject as! [String: AnyObject]
      self.userAccount?.screen_name = dic["screen_name"] as? String
      self.userAccount?.avatar_large = dic["avatar_large"] as? String
      //加载用户信息后，马上归档
      self.archiveAccount(self.userAccount!)
      //执行回调
      complete(error: nil)
      }) { (task, error) in
        complete(error: error)
    }
  }
  
  // MARK: - 私有方法
  ///私有化构造函数
  override init() {
    super.init()
    //加载账号
    userAccount = loadUserAccount()
  }

  /**
   从沙盒中加载用户账号信息
   */
  private func loadUserAccount() -> MPUserAccount?{
    //从沙盒中加载用户账号信息
    let account = NSKeyedUnarchiver.unarchiveObjectWithFile(getUserAccountPath()) as? MPUserAccount
    
    //判断有效期
    if account?.expires_date?.compare(NSDate()) == NSComparisonResult.OrderedDescending {
      return account
    }else {
      return nil
    }
  }
  
  /**
   将用户信息归档
   */
  private func archiveAccount(account: MPUserAccount) {
    NSKeyedArchiver.archiveRootObject(account, toFile: self.getUserAccountPath())
  }
  
  /**
   获得用户账号沙盒路径
   */
  private func getUserAccountPath() -> String {
    return (NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last?.stringByAppendingString("/user.plist"))!
  }
  
  
}
