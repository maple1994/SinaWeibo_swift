//
//  MPStatusViewCell.swift
//  MPWeibo
//
//  Created by Maple on 16/7/22.
//  Copyright © 2016年 Maple. All rights reserved.
//

import UIKit
import SnapKit

class MPStatusViewCell: UITableViewCell {
  ///bottom顶部约束
  var bottomTopConstraint: Constraint?
  
  var status: MPStatus? {
    didSet {
      originalView.status = status
      retweetView.retweetedStatus = status?.retweeted_status
      
      //删除bottom之前的约束
      bottomTopConstraint?.uninstall()
      
      //如果没有转发微博，有则显示，无则隐藏
      if status?.retweeted_status == nil {
        //这里要注意的是，修改约束不能直接修改参照
        //要记录之前的约束，后再删除，才能重新添加约束
        
        //更新bottomView的约束为原创View
        bottomView.snp_makeConstraints(closure: { (make) in
          bottomTopConstraint = make.top.equalTo(originalView.snp_bottom).constraint
        })
        retweetView.hidden = true
      }else {
        //更新bottomView的约束为转发View
        bottomView.snp_makeConstraints(closure: { (make) in
          bottomTopConstraint = make.top.equalTo(retweetView.snp_bottom).constraint
        })
        retweetView.hidden = false
      }
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
    // 设置背景颜色
    contentView.backgroundColor = UIColor(white: 237.0 / 255, alpha: 1)
  }
  
  /**
   添加控件，设置约束
   */
  func setupUI() {
    self.contentView.addSubview(originalView)
    self.contentView.addSubview(retweetView)
    self.contentView.addSubview(bottomView)

    //设置约束
    originalView.snp_makeConstraints { (make) in
      make.top.equalTo(cellMargin)
      make.left.right.equalTo(self.contentView)
    }
    
    retweetView.snp_makeConstraints { (make) in
      make.top.equalTo(originalView.snp_bottom)
      make.leading.trailing.equalTo(self.contentView)
    }
    
    bottomView.snp_makeConstraints { (make) in
      bottomTopConstraint = make.top.equalTo(retweetView.snp_bottom).constraint
      make.leading.trailing.equalTo(self.contentView)
      make.height.equalTo(bottomViewHeight)
    }
    contentView.snp_makeConstraints { (make) in
      make.top.leading.trailing.equalTo(self)
      make.bottom.equalTo(bottomView)
    }
  }
  
  
  //MARK: - 懒加载
  ///原创View
  lazy var originalView: MPStatusOriginalView = MPStatusOriginalView()
  ///转发View
  lazy var retweetView: MPRetweetView = MPRetweetView()
  ///底部按钮区域
  lazy var bottomView: MPBottomView = MPBottomView()
}
