//
//  MPRetweetView.swift
//  MPWeibo
//
//  Created by Maple on 16/7/24.
//  Copyright © 2016年 Maple. All rights reserved.
//

import UIKit

class MPRetweetView: UIView {
  
  var retweetedStatus: MPStatus? {
    didSet {
      guard let status = retweetedStatus else{
        return
      }
      contentLabel.attributedText = retweetedStatus?.emoticonString
      retweetPictureView.pictureUrlArray = status.pictureUrlArray
      //如果图片数组中没有内容，则重新设置pictureView的约束
      var margin = cellMargin
      if status.pictureUrlArray?.count == 0 {
        margin = 0
      }
      retweetPictureView.snp_updateConstraints(closure: { (make) in
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
  }
  
  private func setupUI() {
    self.addSubview(contentLabel)
    self.addSubview(retweetPictureView)

    contentLabel.snp_makeConstraints { (make) in
      make.leading.top.equalTo(self).offset(cellMargin)
    }
    
    retweetPictureView.snp_makeConstraints { (make) in
      make.top.equalTo(contentLabel.snp_bottom).offset(cellMargin)
      make.leading.equalTo(self).offset(cellMargin)
      make.size.equalTo(CGSizeZero)
    }
    
    //转发的view的高度随内容的增大而增大
    self.snp_makeConstraints { (make) in
      make.bottom.equalTo(retweetPictureView).offset(cellMargin)
    }
  }
  
  //MARK: - 懒加载
  ///内容文本
  lazy var contentLabel: UILabel = {
    let label = UILabel(color: UIColor.darkGrayColor(), fontSize: statusFontSize)
    label.numberOfLines = 0
    label.preferredMaxLayoutWidth = UIScreen.width() - 2 * cellMargin
    return label
  }()
  ///转发图片区域
  lazy var retweetPictureView: MPPictureView = MPPictureView()
}
