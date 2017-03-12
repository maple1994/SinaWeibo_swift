//
//  MPStatusOriginalView.swift
//  MPWeibo
//
//  Created by Maple on 16/7/22.
//  Copyright © 2016年 Maple. All rights reserved.
//

import UIKit

class MPStatusOriginalView: UIView {
  var status: MPStatus? {
    didSet {
      //头像
      if let urlString = status?.user?.profile_image_url {
        iconImageView.sd_setImageWithURL(NSURL(string: urlString), placeholderImage: UIImage(named:"avatar_default_big"))
      }
      //等级
      rangeImageView.image = status?.user?.rangImage
      //认证
      verfiyImageView.image = status?.user?.verfiyImage
      //昵称
      nameLabel.text = status?.user?.screen_name
      //发表时间
      createLabel.text = NSDate.dateFromString(status?.created_at ?? "未知时间")?.sinaDateDescription()
      //来源
      sourceLabel.text = status?.source
      //内容
      contentLabel.attributedText = status!.emoticonString

      //传递模型
      pictureView.pictureUrlArray = status?.pictureUrlArray
      
      //如果图片数组中没有内容，则重新设置pictureView的约束
      var margin = cellMargin
      if status?.pictureUrlArray?.count == 0 {
        margin = 0
      }
      pictureView.snp_updateConstraints(closure: { (make) in
        make.top.equalTo(contentLabel.snp_bottom).offset(margin)
      })
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    self.backgroundColor = UIColor.whiteColor()
    
  }
  
  func setupUI() {
    self.addSubview(iconImageView)
    self.addSubview(rangeImageView)
    self.addSubview(verfiyImageView)
    self.addSubview(nameLabel)
    self.addSubview(createLabel)
    self.addSubview(sourceLabel)
    self.addSubview(contentLabel)
    self.addSubview(pictureView)
    
    //设置约束
    //头像
    iconImageView.snp_makeConstraints { (make) in
      make.top.leading.equalTo(self).offset(cellMargin)
      make.width.height.equalTo(iconWH)
    }
    //昵称
    nameLabel.snp_makeConstraints { (make) in
      make.leading.equalTo(iconImageView.snp_trailing).offset(cellMargin)
      make.top.equalTo(iconImageView.snp_top)
    }
    //等级
    rangeImageView.snp_makeConstraints { (make) in
      make.leading.equalTo(nameLabel.snp_trailing).offset(cellMargin)
      make.centerY.equalTo(nameLabel)
    }
    //认证
    verfiyImageView.snp_makeConstraints { (make) in
      make.centerX.equalTo(iconImageView.snp_trailing)
      make.centerY.equalTo(iconImageView.snp_bottom)
    }
    //发布时间
    createLabel.snp_makeConstraints { (make) in
      make.leading.equalTo(nameLabel)
      make.bottom.equalTo(iconImageView)
    }
    //来源
    sourceLabel.snp_makeConstraints { (make) in
      make.leading.equalTo(createLabel.snp_trailing).offset(cellMargin)
      make.bottom.equalTo(createLabel)
    }
    //内容
    contentLabel.snp_makeConstraints { (make) in
      make.top.equalTo(iconImageView.snp_bottom).offset(cellMargin)
      make.leading.equalTo(iconImageView)
    }
    //图片区域
    pictureView.snp_makeConstraints { (make) in
      make.leading.equalTo(self).offset(cellMargin)
      make.top.equalTo(contentLabel.snp_bottom).offset(cellMargin)
      make.size.equalTo(CGSizeMake(UIScreen.width() - 2 * cellMargin, UIScreen.width() - 2 * cellMargin))
    }
    self.snp_makeConstraints { (make) in
      make.bottom.equalTo(pictureView).offset(cellMargin)
    }
  }
  //MARK: - 懒加载
  ///头像
  lazy var iconImageView: UIImageView = UIImageView()
  ///等级
  lazy var rangeImageView: UIImageView = UIImageView()
  ///认证类型
  lazy var verfiyImageView: UIImageView = UIImageView()
  ///昵称
  lazy var nameLabel: UILabel = {
    let label = UILabel(color: UIColor.darkGrayColor(), fontSize: 15)
    return label
  }()
  ///发布时间label
  lazy var createLabel: UILabel = {
    let label = UILabel(color: UIColor.orangeColor())
    return label
  }()
  ///来源label
  lazy var sourceLabel: UILabel = {
    let label = UILabel(color: UIColor.lightGrayColor())
    return label
  }()
  ///内容label
  lazy var contentLabel: UILabel = {
    let label = UILabel(color: UIColor.darkGrayColor(), fontSize: statusFontSize)
    label.numberOfLines = 0
    label.preferredMaxLayoutWidth = UIScreen.width() - 2 * cellMargin
    return label
  }()
  ///图片区域
  lazy var pictureView: MPPictureView = MPPictureView()
}
