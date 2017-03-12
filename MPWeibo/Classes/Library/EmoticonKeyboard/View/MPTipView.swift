//
//  MPTipView.swift
//  emojiKeyboard
//
//  Created by Maple on 16/8/8.
//  Copyright © 2016年 Maple. All rights reserved.
//

import UIKit
import pop

///表情键盘弹出提示View
class MPTipView: UIImageView {
  ///记录之前选中的模型
  private var preEmojiModel: MPEmoji?
  
  ///模型数组
  var emojiModal: MPEmoji? {
    didSet {
      if emojiModal == preEmojiModel {
        return
      }
      button.emojiModel = emojiModal
      
      let pop = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
      pop.fromValue = 30
      pop.toValue = 8
      pop.springBounciness = 20
      pop.springSpeed = 20
      button.layer.pop_addAnimation(pop, forKey: nil)
      
      preEmojiModel = emojiModal
    }
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  init() {
    super.init(image: UIImage(named: "emoticon_keyboard_magnifier"))
    //设置锚点
    self.layer.anchorPoint = CGPoint(x: 0.5, y: 1.2)
    button.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
    button.frame = CGRect(x: 0, y: 8, width: 36, height: 36)
    button.center.x = bounds.width * 0.5

    //添加button
    addSubview(button)
  }
  
  private lazy var button: MPEmojiButton = MPEmojiButton()

}
