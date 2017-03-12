//
//  UIImage+Scale.swift
//  PicturePicker
//
//  Created by Maple on 16/7/31.
//  Copyright © 2016年 Maple. All rights reserved.
//

import UIKit

extension UIImage {
  /**
   等比例缩放图片
   
   - parameter newWidth: 缩放宽度，默认300
   
   - returns: 返回缩放后的图片
   */
  func scaleImage(newWidth: CGFloat = 300) -> UIImage{
    if self.size.width < 300 {
      return self
    }
    //计算缩放的高
    let newHeight = newWidth * self.size.height / self.size.width
    let newSize = CGSize(width: newHeight, height: newWidth)
    //开启图形上下文
    UIGraphicsBeginImageContext(newSize)
    self.drawInRect(CGRect(origin: CGPointZero, size: newSize))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    //关闭上下文
    UIGraphicsEndImageContext()
    
    return newImage
  }
}
