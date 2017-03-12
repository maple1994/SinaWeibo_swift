//
//  UILabel+Extension.swift
//  MPWeibo
//
//  Created by Maple on 16/7/22.
//  Copyright © 2016年 Maple. All rights reserved.
//

import UIKit

extension UILabel {
  //默认返回字体大小为12的label
  convenience init(color: UIColor, fontSize: CGFloat = 12) {
    self.init()
    self.font = UIFont.systemFontOfSize(fontSize)
    self.textColor = color
  }
}
