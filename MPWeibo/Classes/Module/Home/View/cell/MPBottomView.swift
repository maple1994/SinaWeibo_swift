//
//  MPBottomView.swift
//  MPWeibo
//
//  Created by Maple on 16/7/24.
//  Copyright © 2016年 Maple. All rights reserved.
//

import UIKit

class MPBottomView: UIView {

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  private func setupUI() {
    self.addSubview(retweetButton)
    self.addSubview(commentButton)
    self.addSubview(likeButton)
    self.addSubview(seperatorLineFirst)
    self.addSubview(seperatorLineSecond)
    
    retweetButton.snp_makeConstraints { (make) in
      make.top.leading.bottom.equalTo(self)
    }
    
    commentButton.snp_makeConstraints { (make) in
      make.leading.equalTo(retweetButton.snp_trailing)
      make.top.bottom.equalTo(self)
      make.width.equalTo(retweetButton)
    }
    
    likeButton.snp_makeConstraints { (make) in
      make.top.bottom.trailing.equalTo(self)
      make.leading.equalTo(commentButton.snp_trailing)
      make.width.equalTo(commentButton)
    }
    
    seperatorLineFirst.snp_makeConstraints { (make) in
      make.centerX.equalTo(retweetButton.snp_trailing)
      make.centerY.equalTo(retweetButton)
    }
    
    seperatorLineSecond.snp_makeConstraints { (make) in
      make.centerX.equalTo(commentButton.snp_trailing)
      make.centerY.equalTo(commentButton)
    }
  }
  
  //MARK : - 懒加载
  ///转发按钮
  lazy var retweetButton: UIButton = UIButton(title: "转发", image: "timeline_icon_retweet")
  ///评论按钮
  lazy var commentButton: UIButton = UIButton(title: "评论", image: "timeline_icon_comment")
  ///点赞按钮
  lazy var likeButton: UIButton = UIButton(title: "赞", image: "timeline_icon_unlike")
  ///分割线1
  lazy var seperatorLineFirst: UIImageView = UIImageView(image: UIImage(named: "timeline_card_bottom_line"))
  ///分割线2
  lazy var seperatorLineSecond: UIImageView = UIImageView(image: UIImage(named: "timeline_card_bottom_line"))
}
