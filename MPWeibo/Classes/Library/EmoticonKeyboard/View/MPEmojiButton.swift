//
//  MPEmojiButton.swift
//  emojiKeyboard
//
//  Created by Maple on 16/7/29.
//  Copyright © 2016年 Maple. All rights reserved.
//

import UIKit

///表情按钮
class MPEmojiButton: UIButton {
  ///模型数据
  var emojiModel: MPEmoji? {
    didSet {
      //设置emoji表情
      if emojiModel!.emoji != nil {
        self.setTitle(emojiModel?.emoji, forState: UIControlState.Normal)
      }else {
        self.setTitle(nil, forState: UIControlState.Normal)
      }
      //设置图片
      if emojiModel?.png != nil {
        self.setImage(UIImage(named: emojiModel!.fullPathPng!), forState: UIControlState.Normal)
      }else {
        self.setImage(nil, forState: UIControlState.Normal)
      }
      
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.titleLabel?.font = UIFont.systemFontOfSize(34)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
