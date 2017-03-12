//
//  UIBarButton+Extension.swift
//  MPWeibo
//
//  Created by Maple on 16/7/21.
//  Copyright © 2016年 Maple. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
  convenience init(imageName: String) {
    let button = UIButton(type: UIButtonType.Custom)
    button.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
    button.setImage(UIImage(named: imageName + "_highlighted"), forState: UIControlState.Highlighted)
    button.sizeToFit()
    //必须调用self的init方法或者便利构造函数！
    self.init(customView: button)
  }
  
  convenience init(imageName: String, target: AnyObject, action: Selector) {
    let button = UIButton(type: UIButtonType.Custom)
    button.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
    button.setImage(UIImage(named: imageName + "_highlighted"), forState: UIControlState.Highlighted)
    button.sizeToFit()
    //添加点击事件
    button.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
    //必须调用self的init方法或者便利构造函数！
    self.init(customView: button)
  }
}
