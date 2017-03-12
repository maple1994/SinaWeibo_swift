//
//  MPUserAccount.swift
//  MPWeibo
//
//  Created by Maple on 16/7/21.
//  Copyright © 2016年 Maple. All rights reserved.
//

import UIKit

///用户账户类
class MPUserAccount: NSObject, NSCoding {
 
  ///access_token 用来加载用户数据
  var access_token: String?
  //基本数据类型使用？修饰的话，setValueForKey是找不到这个属性的
  ///过期时间
  var expires_in: NSTimeInterval = 0 {
    didSet{
      expires_date = NSDate(timeIntervalSinceNow: expires_in)
    }
  }
  ///过期日期
  var expires_date: NSDate?
  ///授权用户的UID
  var uid: String?
  ///用户名
  var screen_name: String?
  ///用户头像
  var avatar_large: String?
  
  init(dic: [String: AnyObject]) {
    super.init()
    self.setValuesForKeysWithDictionary(dic)
  }
  
  /**
   找不到对应属性时，调用，如果不实现这个方法，程序会崩溃
   */
  override func setValue(value: AnyObject?, forUndefinedKey key: String) {
//    print(key)
  }
  
  /// 打印
  override var description: String {
    let str = "access_token:\(access_token) \nexpires_in: \(expires_in)\nuid:\(uid) screen_name: \(screen_name), avatar_large: \(avatar_large)"
    return str
  }
  
  //MARK: - 归档解档
  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(access_token, forKey: "access_token")
    aCoder.encodeDouble(expires_in, forKey: "expires_in")
    aCoder.encodeObject(uid, forKey: "uid")
    aCoder.encodeObject(expires_date, forKey: "expires_date")
    aCoder.encodeObject(screen_name, forKey: "screen_name")
    aCoder.encodeObject(avatar_large, forKey: "avatar_large")
  }
  
  required init?(coder aDecoder: NSCoder) {
    self.access_token = aDecoder.decodeObjectForKey("access_token") as? String
    self.uid = aDecoder.decodeObjectForKey("uid") as? String
    self.expires_in = aDecoder.decodeDoubleForKey("expires_in")
    self.expires_date = aDecoder.decodeObjectForKey("expires_date") as? NSDate
    self.screen_name = aDecoder.decodeObjectForKey("screen_name") as? String
    self.avatar_large = aDecoder.decodeObjectForKey("avatar_large") as? String
  }
}
