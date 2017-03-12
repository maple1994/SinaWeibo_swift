//
//  MPUser.swift
//  MPWeibo
//
//  Created by Maple on 16/7/22.
//  Copyright © 2016年 Maple. All rights reserved.
//

import UIKit

///用户个人信息类
class MPUser: NSObject {
  //MARK: - 属性列表
  
  ///用户UID
  var id:	Int64 = 0
  ///用户昵称
  var screen_name: String?
  ///用户头像地址（中图），50×50像素
  var profile_image_url: String?
  /// verified_type 没有认证:-1   认证用户:0  企业认证:2,3,5  达人:220
  var verified_type: Int = -1 {
    didSet {
      var image: UIImage? = nil
      switch verified_type {
      case 0:
        // 认证用户
        image = UIImage(named: "avatar_vip")
      case 2,3,5:
        // 企业认证:2,3,5
        image = UIImage(named: "avatar_enterprise_vip")
      case 220:
        // 达人
        image = UIImage(named: "avatar_grassroot")
      default:
        image = nil
      }
      verfiyImage = image
    }
  }
  /// 会员等级
  var mbrank: Int = 0 {
    didSet {
      if mbrank > 0 && mbrank <= 6 {
        let image = UIImage(named: "common_icon_membership_level\(mbrank)")
        rangImage = image
      } else {
        rangImage = nil
      }
    }
  }
  /// rank图片
  var rangImage: UIImage?
  /// 认证图片
  var verfiyImage: UIImage?
  
  init(dic: [String: AnyObject]) {
    super.init()
    setValuesForKeysWithDictionary(dic)
  }
  
  override func setValue(value: AnyObject?, forUndefinedKey key: String) {
  }
  
  override var description: String {
    get {
      let keys = ["id","screen_name","profile_image_url","verified_type","mbrank"]
      return "\n\n用户模型：" + dictionaryWithValuesForKeys(keys).description
    }
  }
}
