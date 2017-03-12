//
//  MPEmojiToolbar.swift
//  emojiKeyboard
//
//  Created by Maple on 16/7/28.
//  Copyright © 2016年 Maple. All rights reserved.
//

import UIKit


///枚举
enum MPEmojiToolbarType: Int {
  case Recent = 0  //最近
  case Default = 1 //默认
  case Emoji = 2   //emoji
  case Lxh = 3     //浪小花
}

protocol MPEmojiToolbarDelegate: NSObjectProtocol {
  func emojjToolbar(buttonDidClick button: UIButton, type:MPEmojiToolbarType)
}

///工具条
class MPEmojiToolbar: UIView {
  
  //按钮数组
  var buttons: [UIButton] = [UIButton]()
  //记录组中按钮
  var selectButton: UIButton = UIButton()
  ///代理
  weak var delegate: MPEmojiToolbarDelegate?
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  private func setupUI() {
    let names = ["最近", "默认", "emoji", "浪小花"]
    //添加按钮
    for (index, name) in names.enumerate() {
      let button = UIButton()
      button.setTitle(name, forState: UIControlState.Normal)
      button.setBackgroundImage(UIImage(named: "compose_emotion_table_mid_normal"), forState: UIControlState.Normal)
      button.setBackgroundImage(UIImage(named: "compose_emotion_table_mid_selected"), forState: UIControlState.Disabled)
      button.tag = index
      //添加点击事件
      button.addTarget(self, action: #selector(buttonClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
      self.addSubview(button)
      buttons.append(button)
      //默认选中第一个按钮
      if index == 0 {
        buttonClick(button)
      }
    }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    //设置按钮frame
    let buttonW = UIScreen.mainScreen().bounds.width / CGFloat(buttons.count)
    let buttonH = self.bounds.height
    for (index, button) in buttons.enumerate() {
      button.frame = CGRect(x: CGFloat(index) * buttonW, y: 0, width: buttonW, height: buttonH)
    }
  }
  
  @objc private func buttonClick(button: UIButton) {
    switchSelected(button)
    delegate?.emojjToolbar(buttonDidClick: button, type: MPEmojiToolbarType(rawValue: button.tag)!)
  }
  
  ///切换按钮状态
  private func switchSelected(button: UIButton) {
    selectButton.enabled = true
    button.enabled = false
    selectButton = button
  }
  
  ///根据传入的下标修改选中的按钮
  func switchButton(section: Int){
    let button = buttons[section]
    switchSelected(button)
  }
}


