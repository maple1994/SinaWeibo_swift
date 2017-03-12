//
//  MPEmojiCell.swift
//  emojiKeyboard
//
//  Created by Maple on 16/7/29.
//  Copyright © 2016年 Maple. All rights reserved.
//

import UIKit

///定义协议
protocol MPEmojiCellDelegate: NSObjectProtocol {
  func emojiCell(didClickButton emojiModel: MPEmoji)
  func emojiCellDidClickDelte()
}


///一页最多7列
let maxNumberOfColumn = 7
///一页最多3行
let maxNumberOfRow = 3
///一页最多20个表情
let maxCountOfPage = 20

///表情cell
class MPEmojiCell: UICollectionViewCell {
  //MARK: - 成员属性
  ///记录上一次选中的按钮
  var preButton: MPEmojiButton?
  
  ///代理属性
  weak var delegate: MPEmojiCellDelegate?
  
  ///测试文本
  var indexPath: NSIndexPath? {
    didSet {
      debugLabel.text = "我是第 \(indexPath!.section) 组,第 \(indexPath!.item) 个cell"
      recentLabel.hidden = (indexPath?.section != 0)
    }
  }
  ///一页的模型数组
  var pageEmoji: [MPEmoji]? {
    didSet {
      for button in buttons {
        button.hidden = true
      }

      for (index, emoji) in pageEmoji!.enumerate() {
        //取出按钮
        let button = buttons[index]
        button.hidden = false
        button.emojiModel = emoji
      }
    }
  }
  ///保存20个按钮
  var buttons: [MPEmojiButton] = [MPEmojiButton]()
  
  //MARK: - 设置界面
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    //设置背景颜色
    self.contentView.backgroundColor = UIColor(white: 237.0 / 255.0, alpha: 1)
  }
  
  override func willMoveToWindow(newWindow: UIWindow?) {
    guard let w = newWindow else{
      return
    }
    w.addSubview(self.tipView)
    self.tipView.hidden = true
  }
  
  private func setupUI() {
    //添加20个按钮
    for _ in 0..<20 {
      let button = MPEmojiButton()
      self.contentView.addSubview(button)
      //添加点击事件
      button.addTarget(self, action: #selector(buttonClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
      //默认隐藏，有才显示
      button.hidden = true
      buttons.append(button)
      //添加长按手势
      let long = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
      long.minimumPressDuration = 0.1
      button.addGestureRecognizer(long)
    }
    //添加调试label
    self.contentView.addSubview(debugLabel)
    //添加删除按钮
    self.contentView.addSubview(deleteButton)
    //添加删除按钮点击使劲
    deleteButton.addTarget(self, action: #selector(deleteButtonClick), forControlEvents: UIControlEvents.TouchUpInside)
    //添加最近按钮
    self.contentView.addSubview(recentLabel)
    
    //设置约束
    recentLabel.translatesAutoresizingMaskIntoConstraints = false
    self.contentView.addConstraint(NSLayoutConstraint(item: recentLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -5))
    self.contentView.addConstraint(NSLayoutConstraint(item: recentLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: -5))
  }
  
  ///布局子控件
  override func layoutSubviews() {
     super.layoutSubviews()
    layoutButton()
    
  }
  
  ///布局按钮
  private func layoutButton() {
    // cell上下，左右间距
    let lrMargin: CGFloat = 5
    let bottomMargin: CGFloat = 25
    
    //计算按钮宽高
    let buttonW = (self.contentView.frame.width - 2 * lrMargin) / CGFloat(maxNumberOfColumn)
    let buttonH = (self.contentView.frame.height - bottomMargin) / CGFloat(maxNumberOfRow)
    for (index, button) in buttons.enumerate() {
      let row = index / maxNumberOfColumn
      let col = index % maxNumberOfColumn
      button.frame = CGRect(x: lrMargin + CGFloat(col) * buttonW, y: CGFloat(row) * buttonH, width: buttonW, height: buttonH)
    }
    //删除按钮，固定在第六列第二行
    let x = lrMargin + CGFloat((maxNumberOfColumn - 1)) * buttonW
    let y = CGFloat((maxNumberOfRow - 1)) * buttonH
    deleteButton.frame = CGRect(x: x, y: y, width: buttonW, height: buttonH)
  }
  
  //MARK: - 私有方法
  /**
   根据坐标点，返回对应的按钮
   
   - parameter location: 坐标点
   */
  private func getButton(location: CGPoint) -> MPEmojiButton?{
    
    //遍历按钮数组
    for btn in buttons {
      
      //当前点在按钮上，且按钮没有被隐藏
      if btn.frame.contains(location) && !btn.hidden{
        if preButton == btn {
          return btn
        }
        preButton = btn
        return btn
      }
    }
    return nil
  }
  
  //MARK: - 事件处理
  @objc private func deleteButtonClick() {
    delegate?.emojiCellDidClickDelte()
  }
  
  @objc private func longPress(gesture: UIGestureRecognizer) {
    let location = gesture.locationInView(self.contentView)
   
    guard let button = getButton(location) else {
      tipView.hidden = true
      return
    }
    switch gesture.state {
    case .Changed, .Began:
      tipView.hidden = false
      //转换坐标系
      let center = self.convertPoint(button.center, toView: window)
      tipView.center = center
      tipView.emojiModal = button.emojiModel
    case .Ended:
      tipView.hidden = true
      buttonClick(button)
    case .Failed, .Cancelled:
      tipView.hidden = true
    default:
      break
    }
    
  }
  
  @objc private func buttonClick(button: MPEmojiButton) {
    delegate?.emojiCell(didClickButton: button.emojiModel!)
  }
  
  //MARK: - 懒加载
  ///提示View
  private lazy var tipView: MPTipView = MPTipView()
  ///调试用的label
  private lazy var debugLabel: UILabel = {
    let label = UILabel()
    label.hidden = true
    label.textColor = UIColor.whiteColor()
    label.font = UIFont.systemFontOfSize(25)
    label.frame = CGRect(x: 20, y: 20, width: 350, height: 200)
    return label
  }()
  ///删除按钮
  private lazy var deleteButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "compose_emotion_delete"), forState: UIControlState.Normal)
    button.setImage(UIImage(named: "compose_emotion_delete_highlighted"), forState: UIControlState.Highlighted)
    button.sizeToFit()
    return button
  }()
  ///最近label
  private lazy var recentLabel: UILabel = {
    let label = UILabel()
    label.text = "最近使用的表情"
    label.font = UIFont.systemFontOfSize(12)
    label.textColor = UIColor.grayColor()
    label.sizeToFit()
    return label
  }()
  
}
