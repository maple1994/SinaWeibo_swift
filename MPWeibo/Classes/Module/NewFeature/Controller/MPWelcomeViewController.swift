//
//  MPWelcomeViewController.swift
//  MPWeibo
//
//  Created by Maple on 16/7/21.
//  Copyright © 2016年 Maple. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

class MPWelcomeViewController: UIViewController {

  override func viewDidLoad() {
      super.viewDidLoad()
    setUpUI()
    //判断是否登录,没有登录则不做任何事情
    if !MPUserAccountViewModel.sharedUserAccountViewModel.isLogin {
      return
    }
    //设置头像,这时候如果缓存中有图片，则直接显示缓存的图片
    setIcon()
    MPUserAccountViewModel.sharedUserAccountViewModel.loadUserInfo { (error) in
      if error != nil {
        //出错
        print(error)
        return
      }
      //设置头像
      self.setIcon()
    }
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    startAnimation()
  }
  
  /**
   设置头像
   */
  private func setIcon() {
    if let avatar_large = MPUserAccountViewModel.sharedUserAccountViewModel.userAccount?.avatar_large{
      let url = NSURL(string: avatar_large)
      iconImageView.sd_setImageWithURL((url), placeholderImage: UIImage(named: "avatar_default_big"))
      }
  }
  
  /**
   开始动画
   */
  private func startAnimation() {
    let offY = -(UIScreen.mainScreen().bounds.height - 160)
    iconImageView.snp_updateConstraints { (make) in
      make.bottom.equalTo(self.view).offset(offY)
    }
    
    //开始动画
    UIView.animateWithDuration(1, delay: 0.1, usingSpringWithDamping: 0.75, initialSpringVelocity: 7, options: UIViewAnimationOptions(rawValue: 0), animations: {
      //强制更新
      self.view.layoutIfNeeded()
      }) { (_) in
      UIView.animateWithDuration(defaultDuration, animations: { 
        self.welcomeLabel.alpha = 1
        }, completion: { (_) in
          AppDelegate.changRootViewController(MPTabBarController())
      })
    }
  }
  
  /**
   设置UI
   */
  private func setUpUI() {
    //添加子控件
    self.view.addSubview(bgImageView)
    self.view.addSubview(iconImageView)
    self.view.addSubview(welcomeLabel)
    
    //设置约束
    bgImageView.snp_makeConstraints { (make) in
        make.edges.equalTo(self.view)
    }
    iconImageView.snp_makeConstraints { (make) in
      make.bottom.equalTo(self.view).offset(-160)
      make.centerX.equalTo(self.view)
      make.width.height.equalTo(90)
    }
    welcomeLabel.snp_makeConstraints { (make) in
      make.top.equalTo(iconImageView.snp_bottom).offset(16)
      make.centerX.equalTo(self.view)
    }
  }

  //MARK: - 懒加载
  ///背景图片
  lazy var bgImageView: UIImageView = UIImageView(image: UIImage(named: "ad_background"))
  
  ///头像
  lazy var iconImageView: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "avatar_default_big"))
    imageView.layer.cornerRadius = 45
    imageView.layer.masksToBounds = true
    return imageView
  }()
  
  ///欢迎文本
  lazy var welcomeLabel: UILabel = {
    let label = UILabel()
    label.text = "欢迎回来"
    label.sizeToFit()
    label.alpha = 0
//    label.font = UIFont().fontWithSize(18)
    return label
  }()
}


