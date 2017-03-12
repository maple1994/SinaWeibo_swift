//
//  MPPicturePickerCell.swift
//  PicturePicker
//
//  Created by Maple on 16/7/31.
//  Copyright © 2016年 Maple. All rights reserved.
//

import UIKit

protocol MPPicturePickerCellDelegate: NSObjectProtocol {
  func picturePickerDidClickAddButton(pickerCell: MPPicturePickerCell);
  func picturePickerDidClickDelete(pickerCell: MPPicturePickerCell);
}

class MPPicturePickerCell: UICollectionViewCell {
  
  /// 代理
  weak var delegate: MPPicturePickerCellDelegate?
  /// 添加图
  var image: UIImage? {
    didSet {
      if image != nil {
        deleteButton.hidden = false
        addButton.setImage(image, forState: UIControlState.Normal)
      }else {
        deleteButton.hidden = true
        setupAddButton()
      }
    }
  }
  
  ///设置addbutton
  private func setupAddButton() {
    addButton.setImage(UIImage(named:"compose_pic_add"), forState: UIControlState.Normal)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  private func setupUI() {
    self.contentView.addSubview(addButton)
    self.contentView.addSubview(deleteButton)
    addButton.translatesAutoresizingMaskIntoConstraints = false
    deleteButton.translatesAutoresizingMaskIntoConstraints = false
    
    //添加约束
    let views = ["ab" : addButton, "db" : deleteButton]
  self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[ab]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
  self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[ab]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
    
   self.contentView.addConstraints( NSLayoutConstraint.constraintsWithVisualFormat("H:[db]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
    self.contentView.addConstraints( NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[db]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
  }
  
  // MARK: - 点击事件
  @objc private func addButtonClick() {
    delegate?.picturePickerDidClickAddButton(self)
  }
  
  @objc private func deleteButtonClick() {
    delegate?.picturePickerDidClickDelete(self)
  }
  
  // MARK: - 懒加载
  ///添加按钮
  private lazy var addButton: UIButton = {
    let button = UIButton()
    
    button.backgroundColor = UIColor.brownColor()
    //添加点击事件
    button.addTarget(self, action: #selector(addButtonClick), forControlEvents: UIControlEvents.TouchUpInside)
    return button
  }()
  
  ///删除按钮
  private lazy var deleteButton: UIButton = {
    let button = UIButton()
    button.hidden = true
    button.setImage(UIImage(named:"compose_photo_close"), forState: UIControlState.Normal)
    //添加点击事件
    button.addTarget(self, action: #selector(deleteButtonClick), forControlEvents: UIControlEvents.TouchUpInside)
    return button
  }()
}
