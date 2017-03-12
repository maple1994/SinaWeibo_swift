//
//  MPPlaceholderTextView.swift
//  MPWeibo
//
//  Created by Maple on 16/7/28.
//  Copyright © 2016年 Maple. All rights reserved.
//

import UIKit

class MPPlaceholderTextView: UITextView {
  ///占位文字
  var placeholder: String? {
    didSet {
      self.placeholderLabel.text = placeholder
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(frame: CGRect, textContainer: NSTextContainer?) {
    super.init(frame: frame, textContainer: textContainer)
    setupUI()
    //添加监听
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(textChange), name: UITextViewTextDidChangeNotification, object: nil)
  }
  
  ///文字改变时调用
  @objc private func textChange() {
    self.placeholderLabel.hidden = self.hasText()
  }
  
  ///注销监听
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  private func setupUI() {
    //添加控件
    self.addSubview(placeholderLabel)
    
    //添加约束
    placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
    self.addConstraint(NSLayoutConstraint(item: placeholderLabel, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 5))
    self.addConstraint(NSLayoutConstraint(item: placeholderLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 8))
  }
  
  //MARK: - 懒加载
  private lazy var placeholderLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFontOfSize(18)
    label.text = "占位占位"
    label.textColor = UIColor.lightGrayColor()
    return label
  }()
  
}
