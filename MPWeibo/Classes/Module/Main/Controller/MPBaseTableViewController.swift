//
//  MPBaseTableViewController.swift
//  MPWeibo
//
//  Created by Maple on 16/7/18.
//  Copyright © 2016年 Maple. All rights reserved.
//

import UIKit

///基础tableView控制器，根据登陆状态显示不同的View
class MPBaseTableViewController: UITableViewController {
  var isLogin = MPUserAccountViewModel.sharedUserAccountViewModel.isLogin
  
  override func loadView() {
    if isLogin {
      super.loadView()
    }else {
      let visitorView = MPVisitorView()
      self.view = visitorView
      //指定代理
      visitorView.delegate = self
      //根据不同的控制器，加载不同的图片和标题
      if self is MPHomeTableViewController {
        visitorView.startAnimation()
      }else if self is MPMessageTableViewController {
        visitorView.setUpContent("visitordiscover_image_message", title: "登录后，别人评论你的微博，发给你的消息，都会在这里收到通知")
      }else if self is MPDiscoveryTableViewController {
        visitorView.setUpContent("visitordiscover_image_message", title: "登录后，最新、最热微博尽在掌握，不再会与实事潮流擦肩而过")
      }else if self is MPProfileTableViewController {
        visitorView.setUpContent("visitordiscover_image_profile", title: "登录后，你的微博、相册、个人资料会显示在这里，展示给别人")
      }
      
      //设置点击事件
      self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MPBaseTableViewController.visitorViewDidRegister))
      self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登陆", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MPBaseTableViewController.visitorViewDidLogin))
    }
  }
}

//MARK: - VisitorViewDelegate
extension MPBaseTableViewController: VisitorViewDelegate {
   func visitorViewDidRegister() {
    print(#function)
  }
   func visitorViewDidLogin() {
    let vc = MPOAuthViewController()
    let nav = MPNavigationController(rootViewController: vc)
    self.presentViewController(nav, animated: true, completion: nil)
  }
}
