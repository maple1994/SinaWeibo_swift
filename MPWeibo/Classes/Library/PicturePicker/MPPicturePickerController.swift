//
//  MPPickerPictureController.swift
//  PicturePicker
//
//  Created by Maple on 16/7/31.
//  Copyright © 2016年 Maple. All rights reserved.
//

import UIKit

class MPPicturePickerController: UICollectionViewController {
  
  /// 布局属性
  private let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
  /// 重用标识
  private let resuedID = "cell"
  /// collectionView 左右间距
  private let margin: CGFloat = 5
  /// 最大张数
  private let maxPhotoCount = 6
  /// 图片数组
  var images:[UIImage] = [UIImage]()
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  init() {
    super.init(collectionViewLayout: self.layout)
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupCollectionView()
  }
  
  ///设置collectView相关属性
  private func setupCollectionView() {
    self.collectionView?.backgroundColor = UIColor.whiteColor()
    self.collectionView?.registerClass(MPPicturePickerCell.self, forCellWithReuseIdentifier: resuedID)
    self.collectionView?.contentInset = UIEdgeInsets(top: 0, left: margin, bottom: 0, right: margin)
    let itemWH = 80
    
    //设置item的大小
    layout.itemSize = CGSize(width: itemWH, height: itemWH)
  }
  
  
}

// MARK: - collectView代理
extension MPPicturePickerController {
  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    let count = images.count != maxPhotoCount ? images.count + 1 : maxPhotoCount
    return count
  }
  
  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell: MPPicturePickerCell = collectionView.dequeueReusableCellWithReuseIdentifier(resuedID, forIndexPath: indexPath) as! MPPicturePickerCell
    let image: UIImage? = indexPath.item < images.count ? images[indexPath.item] : nil
    cell.image = image
    cell.delegate = self
    
    return cell
  }
}

// MARK: - picturePickerCell代理
extension MPPicturePickerController: MPPicturePickerCellDelegate {
  func picturePickerDidClickAddButton(pickerCell: MPPicturePickerCell) {
     let picker = UIImagePickerController()
     picker.delegate = self
     self.presentViewController(picker, animated: true, completion: nil)
  }
  
  
  func picturePickerDidClickDelete(pickerCell: MPPicturePickerCell) {
    let indexPath = self.collectionView?.indexPathForCell(pickerCell)
    //删掉数组对应的图片
    images.removeAtIndex(indexPath!.item)
    self.collectionView?.reloadData()
  }
}

// MARK: - MPPicturePickerController代理
extension MPPicturePickerController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
    images.append(image.scaleImage())
    self.collectionView?.reloadData()
    picker.dismissViewControllerAnimated(true, completion: nil)
  }
}

