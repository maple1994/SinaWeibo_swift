//
//  MPHomeButton.swift
//  MPWeibo
//
//  Created by Maple on 16/7/22.
//  Copyright © 2016年 Maple. All rights reserved.
//

import UIKit

class MPHomeButton: UIButton {

  convenience init(title: String) {
    self.init()
    self.setTitle(title, forState: UIControlState.Normal)
    self.setImage(UIImage(named: "navigationbar_arrow_down"), forState: UIControlState.Normal)
    self.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
    self.sizeToFit()
  }
  override func layoutSubviews() {
    super.layoutSubviews()
    self.titleLabel?.frame.origin.x = 0
    self.imageView?.frame.origin.x = self.titleLabel!.frame.width + 5
  }

}
