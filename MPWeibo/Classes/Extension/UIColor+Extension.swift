//
//  UIColor+Extension.swift
//  MPWeibo
//
//  Created by Maple on 16/7/21.
//  Copyright © 2016年 Maple. All rights reserved.
//

import UIKit

extension UIColor {
  /**
   返回随机颜色
   */
  class func randomColor() -> UIColor{
    let r = CGFloat(arc4random_uniform(256)) / 255.0
    let g = CGFloat(arc4random_uniform(256)) / 255.0
    let b = CGFloat(arc4random_uniform(256)) / 255.0
    return UIColor(red: r, green: g, blue: b, alpha: 1)
  }
}
