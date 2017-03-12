//
//  UIButton+Extension.swift
//  MPWeibo
//
//  Created by Maple on 16/7/24.
//  Copyright © 2016年 Maple. All rights reserved.
//

import UIKit

extension UIButton {
  convenience init(title: String, image: String, bgImage: String = "timeline_card_bottom_background", titleColor: UIColor = UIColor.darkGrayColor(), fontSize: CGFloat = 15) {
    self.init()
    self.setTitle(title, forState: UIControlState.Normal)
    self.setImage(UIImage(named: image), forState: UIControlState.Normal)
    self.setBackgroundImage(UIImage(named: bgImage), forState: UIControlState.Normal)
      self.setBackgroundImage(UIImage(named:bgImage + "_highlighted"), forState: UIControlState.Highlighted)
    self.titleLabel?.font = UIFont.systemFontOfSize(fontSize)
    self.setTitleColor(titleColor, forState: UIControlState.Normal)

  }
}
