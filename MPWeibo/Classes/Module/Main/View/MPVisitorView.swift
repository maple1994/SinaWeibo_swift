//
//  MPVisitorView.swift
//  MPWeibo
//
//  Created by Maple on 16/7/18.
//  Copyright © 2016年 Maple. All rights reserved.
//

import UIKit

protocol VisitorViewDelegate: NSObjectProtocol {
  func visitorViewDidRegister()
  func visitorViewDidLogin()
}

///访客视图，没有登陆的时候显示
class MPVisitorView: UIView {
  ///代理
  weak var delegate: VisitorViewDelegate?
  
  //xib加载的时候回调用这个方法
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //重写这个方法，必须也实现init(coder) 方法
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = UIColor(white: 236 / 255.0, alpha: 1)
    //添加子控件，并且设置约束
    setUpUI()
  }
 
  /**
   添加子控件，并且设置约束
   */
  private func setUpUI() {
    //添加控件
    self.addSubview(iconView)
    self.addSubview(coverView)
    self.addSubview(houseView)
    self.addSubview(textLabel)
    self.addSubview(registerButton)
    self.addSubview(loginButton)
    
    //取消autoresizing
    iconView.translatesAutoresizingMaskIntoConstraints = false
    houseView.translatesAutoresizingMaskIntoConstraints = false
    textLabel.translatesAutoresizingMaskIntoConstraints = false
    registerButton.translatesAutoresizingMaskIntoConstraints = false
    loginButton.translatesAutoresizingMaskIntoConstraints = false
    coverView.translatesAutoresizingMaskIntoConstraints = false;
    
    //设置iconView约束
    self.addConstraint(NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
    
    self.addConstraint(NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: -40))
    
    //设置coverView约束
    self.addConstraint(NSLayoutConstraint(item: coverView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
    
    self.addConstraint(NSLayoutConstraint(item: coverView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0))
    
    //设置houseView约束
    self.addConstraint(NSLayoutConstraint(item: houseView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
    
    self.addConstraint(NSLayoutConstraint(item: houseView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0))
    
    //设置textLabel约束
    self.addConstraint(NSLayoutConstraint(item: textLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 16))
    
    self.addConstraint(NSLayoutConstraint(item: textLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
    
    self.addConstraint(NSLayoutConstraint(item: textLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 260))
    
    //设置registerButton约束
    self.addConstraint(NSLayoutConstraint(item: registerButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: textLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 16))
    
    self.addConstraint(NSLayoutConstraint(item: registerButton, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: textLabel, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 16))
    
    self.addConstraint(NSLayoutConstraint(item: registerButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 100))
    
    self.addConstraint(NSLayoutConstraint(item: registerButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 35))
    
    //设置loginButton约束
    self.addConstraint(NSLayoutConstraint(item: loginButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: textLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 16))
    
    self.addConstraint(NSLayoutConstraint(item: loginButton, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: textLabel, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 16))
    
    self.addConstraint(NSLayoutConstraint(item: loginButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 100))
    
    self.addConstraint(NSLayoutConstraint(item: loginButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 35))
  }

  //MARK: - 公有方法
  func setUpContent(imageName: String, title: String) {
    iconView.image = UIImage(named: imageName)
    textLabel.text = title
    //隐藏屋子
    houseView.hidden = true
    //隐藏蒙版
    self.sendSubviewToBack(coverView)
  }
  /**
   开始动画
   */
  func startAnimation(){
    //添加动画
    let animation = CABasicAnimation(keyPath: "transform.rotation")
    animation.fromValue = 0
    animation.toValue = M_PI * 2
    animation.repeatCount = MAXFLOAT
    animation.duration = 20
    //不移除，作用是切换控制器后，动画不移除
    animation.removedOnCompletion = false
    iconView.layer.addAnimation(animation, forKey: nil)
  }
  //MARK: - button点击事件
  @objc private func loginClick() {
    delegate?.visitorViewDidLogin()
  }
  @objc private func registerClick() {
    delegate?.visitorViewDidRegister()
  }
  //MARK: - 懒加载
  ///轮子
  private lazy var iconView: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
    return imageView
  }()
  
  ///遮罩mask
  private lazy var coverView: UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
  
  ///屋子
  private lazy var houseView: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
    return imageView
  }()
  
  ///label
  private lazy var textLabel: UILabel = {
    let label = UILabel()
    //设置label属性
    label.numberOfLines = 0
    label.textColor = UIColor.darkGrayColor()
    label.text = "关注一些人，回这里看看有什么惊喜关注一些人"
    label.font = UIFont.systemFontOfSize(15)
    label.textAlignment = NSTextAlignment.Center
    label.sizeToFit()
    return label
  }()
  
  ///注册按钮
  private lazy var registerButton: UIButton = {
    let button = UIButton(type: UIButtonType.Custom)
    //设置按钮属性
    button.setBackgroundImage(UIImage(named:"common_button_white_disable"), forState: UIControlState.Normal)
    button.setTitle("注册", forState: UIControlState.Normal)
    button.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
    button.titleLabel?.font = UIFont.systemFontOfSize(18)
    //添加点击事件
    button.addTarget(self, action: #selector(MPVisitorView.registerClick), forControlEvents: UIControlEvents.TouchUpInside)
    return button
  }()
  
  ///登录按钮
  private lazy var loginButton: UIButton = {
    let button = UIButton(type: UIButtonType.Custom)
    //设置按钮属性
    button.setBackgroundImage(UIImage(named:"common_button_white_disable"), forState: UIControlState.Normal)
    button.setTitle("登录", forState: UIControlState.Normal)
    button.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
    button.titleLabel?.font = UIFont.systemFontOfSize(18)
    //添加点击事件
    button.addTarget(self, action: #selector(MPVisitorView.loginClick), forControlEvents: UIControlEvents.TouchUpInside)
    return button
  }()
}











