//
//  MPTabBarController.swift
//  MPWeibo
//
//  Created by Maple on 16/7/18.
//  Copyright © 2016年 Maple. All rights reserved.
//

import UIKit

class MPTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
      let myTab = MPTabBar()
      self .setValue(myTab, forKey: "tabBar")
      myTab.composeBlock = {
        //判断是否登录
        if MPUserAccountViewModel.sharedUserAccountViewModel.isLogin {
          let composeVC = MPComposeViewController()
          let nav = MPNavigationController(rootViewController: composeVC)
          self.presentViewController(nav, animated: true, completion: nil)
        }else {
          //弹出登录界面
          let OAuthVc = MPOAuthViewController()
          let nav = MPNavigationController(rootViewController: OAuthVc)
          self.presentViewController(nav, animated: true, completion: nil)
        }
      }
      setUpChildContorller()
    }
  
  /**
   添加子控制器
   */
  private func setUpChildContorller() {
    //首页
    let homeVC = MPHomeTableViewController()
    addChildViewController(homeVC, title: "首页", imageName: "tabbar_home")
    //消息
    let messageVC = MPMessageTableViewController()
    addChildViewController(messageVC, title: "消息", imageName: "tabbar_message_center")
    //发现
    let discoveryVC = MPDiscoveryTableViewController()
    addChildViewController(discoveryVC, title: "发现", imageName: "tabbar_discover")
    //我的
    let profileVC = MPProfileTableViewController()
    addChildViewController(profileVC, title: "我的", imageName: "tabbar_profile")
  }

  /**
   设置子控制器
   
   - parameter controller: 需要设置的控制器
   - parameter title:      标题
   - parameter imageName:  图片名
   */
  private func addChildViewController(controller: UIViewController, title: String, imageName: String) {
    //设置标题
    controller.title = title
    let image = UIImage(named: imageName)
    image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
    //设置图片
    controller.tabBarItem.image = UIImage(named: imageName)
    //设置选中图片
    let selected = imageName + "_selected"
    controller.tabBarItem.selectedImage = UIImage(named: selected)?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
    //设置文字选中颜色
    controller.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.orangeColor()], forState: UIControlState.Selected)
//    tabBar.tintColor = UIColor.orangeColor()
    //添加到tabBar中
    let nav = MPNavigationController(rootViewController: controller)
    addChildViewController(nav)
  }
}










