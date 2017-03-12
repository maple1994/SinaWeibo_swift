//
//  MPNewFeatureCell.swift
//  MPWeibo
//
//  Created by Maple on 16/7/21.
//  Copyright © 2016年 Maple. All rights reserved.
//

import UIKit
import SnapKit

class MPNewFeatureCell: UICollectionViewCell {
  
  ///要显示的图片
  var image: UIImage? {
    didSet{
      bgImageView.image = image
    }
  }
  
  override init(frame: CGRect) {
     super.init(frame: frame)
    setUpUI()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  /**
   添加控件，设置约束
   */
  private func setUpUI() {
    //添加控件
    self.contentView.addSubview(bgImageView)
    self.contentView.addSubview(sharedButton)
    self.contentView.addSubview(startButton)
    
    //设置约束
    bgImageView.snp_makeConstraints { (make) in
      make.edges.equalTo(self.contentView)
    }
    
    startButton.snp_makeConstraints { (make) in
      make.centerX.equalTo(self.contentView)
      make.bottom.equalTo(self.contentView).offset(-160)
    }
    
    sharedButton.snp_makeConstraints { (make) in
      make.bottom.equalTo(startButton.snp_top).offset(-16)
      make.centerX.equalTo(self.contentView)
    }
  }
  
  func showButton(isShow: Bool) -> Void {
    sharedButton.hidden = !isShow
    startButton.hidden = !isShow
  }
  
  @objc private func share() {
    sharedButton.selected = !sharedButton.selected
  }
  
  @objc private func start() {
    AppDelegate.changRootViewController(MPTabBarController())
  }
  
  //MARK: - 懒加载
  ///背景图片
  lazy var bgImageView = UIImageView(image: UIImage(named: "new_feature_1"))
  
  ///分享按钮
  lazy var sharedButton: UIButton = {
    let button = UIButton(type: UIButtonType.Custom)
    button.setImage(UIImage(named: "new_feature_share_false"), forState: UIControlState.Normal)
    button.setImage(UIImage(named: "new_feature_share_true"), forState: UIControlState.Selected)
    button.setTitle(" 点击分享给好友", forState: UIControlState.Normal)
    button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
    button.sizeToFit()
    button.addTarget(self, action: #selector(share), forControlEvents: UIControlEvents.TouchUpInside)
    return button
  }()
  
  ///开始按钮
  lazy var startButton: UIButton = {
    let button = UIButton(type: UIButtonType.Custom)
    button.setBackgroundImage(UIImage(named: "new_feature_finish_button"), forState: UIControlState.Normal)
    button.setBackgroundImage(UIImage(named: "new_feature_finish_button_highlighted"), forState: UIControlState.Highlighted)
    button.setTitle("开始体验", forState: UIControlState.Normal)
    button.sizeToFit()
    button.addTarget(self, action: #selector(start), forControlEvents: UIControlEvents.TouchUpInside)
    return button
  }()
}










