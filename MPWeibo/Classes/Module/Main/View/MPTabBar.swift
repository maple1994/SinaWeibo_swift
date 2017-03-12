//
//  MPTabBar.swift
//  MPWeibo
//
//  Created by Maple on 16/7/18.
//  Copyright © 2016年 Maple. All rights reserved.
//

import UIKit

class MPTabBar: UITabBar {
  
  ///item个数
  private let itemCount: Int = 5
  
  ///点击中间按钮闭包
  var composeBlock: (() -> Void)?
  
  /**
   * 添加中间按钮
   */
  override func layoutSubviews() {
    super.layoutSubviews()
    //计算宽度
    let width = self.frame.width / CGFloat(itemCount)
    var index = 0
    
    for view in self.subviews {
      if view.isKindOfClass(NSClassFromString("UITabBarButton")!) {
        view.frame = CGRect(x: CGFloat(index) * width, y: 0, width: width, height: self.frame.height)
        
        index += 1
        if index == 2 {
          //设置button的frame
          self.composeButton?.frame = CGRect(x: CGFloat(index) * width, y: 0, width: width, height: self.frame.height)

          index += 1
        }
      }
    }
  }
  
  //MARK:懒加载 -
  //中间按钮,懒加载
  private lazy var composeButton: UIButton? = {
    let button = UIButton(type: UIButtonType.Custom)
    //设置图片
    button.setImage(UIImage(named: "tabbar_compose_icon_add"), forState: UIControlState.Normal)
    button.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), forState: UIControlState.Highlighted)
    //设置背景图片
    button.setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState: UIControlState.Normal)
    button.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
    //添加点击事件
    button.addTarget(self, action: #selector(MPTabBar.composeClick), forControlEvents: UIControlEvents.TouchUpInside)
    //添加
    self.addSubview(button)
    return button
  }()

  func composeClick() -> Void {
    composeBlock?()
  }
}
