//
//  UIScreen+Extension.swift
//  MPWeibo
//
//  Created by Maple on 16/7/22.
//  Copyright © 2016年 Maple. All rights reserved.
//

import UIKit

extension UIScreen {
  class func width() -> CGFloat{
    return UIScreen.mainScreen().bounds.width
  }
  
  class func height() -> CGFloat {
    return UIScreen.mainScreen().bounds.height
  }
}
