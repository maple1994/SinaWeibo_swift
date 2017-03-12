//
//  MPPictureView.swift
//  MPWeibo
//
//  Created by Maple on 16/7/24.
//  Copyright © 2016年 Maple. All rights reserved.
//

import UIKit

///最大列数
let maxColumn = 3

///图片的宽高
let imageWH = (UIScreen.width() - 2 * cellMargin - (CGFloat(maxColumn) - 1) * imageMargin) / CGFloat(maxColumn)

class MPPictureView: UIView {
  ///图片url数组
  var pictureUrlArray: [NSURL]? {
    didSet {
      //布局imageView
      let size = layoutImageView(pictureUrlArray)
      self.snp_updateConstraints { (make) in
        make.size.equalTo(size)
      }
    }
  }
  ///imageView数组
  private var imageViewArray: [UIImageView] = [UIImageView] ()
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  private func setupUI() {
    
    for i in 0..<9 {
      let imageView: UIImageView = UIImageView()
      //设置imageView的填充模式
      imageView.contentMode = UIViewContentMode.ScaleAspectFill
      imageView.layer.masksToBounds = true
      //添加点击手势事件
      let tap = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
      imageView.addGestureRecognizer(tap)
      imageView.userInteractionEnabled = true
      imageView.tag = i

      imageViewArray.append(imageView)
      self.addSubview(imageView)
      
      }
  }
  
  @objc private func tap(tap: UITapGestureRecognizer) {
    let browser = SDPhotoBrowser()
    
    browser.sourceImagesContainerView = self
    
    browser.imageCount = pictureUrlArray?.count ?? 0
    
    browser.currentImageIndex = tap.view!.tag
    
    browser.delegate = self
    
    browser.show()
  }
  
  /**
   布局imageView
   */
  private func layoutImageView(pictureArray: [NSURL]?) -> CGSize {
    var numberOfColumn = maxColumn
    let count = pictureUrlArray?.count
//    let count = Int(arc4random_uniform(9))
    if count == 1 {
      numberOfColumn = 1
    }else if count == 2 || count == 4 {
      numberOfColumn = 2
    }
    
    //设置frame
    for (index, imageView) in imageViewArray.enumerate() {
      //如果没有这么多图片，就隐藏已经添加的imageView
      if index >= count {
        imageView.hidden = true
      }else {
        let url = pictureArray![index]
        imageView.sd_setImageWithURL(url)
        //重用cell时，imageView要显示回来
        imageView.hidden = false
        let row = index / numberOfColumn
        let col = index % numberOfColumn
        imageView.backgroundColor = UIColor.randomColor()
        imageView.frame = CGRectMake(CGFloat(col) * (imageWH + imageMargin), CGFloat(row) * (imageWH + imageMargin), imageWH, imageWH)
      }
    }
    if count == 0 {
      return CGSizeZero
    }
    //计算宽 
    let width = CGFloat(numberOfColumn) * imageWH + CGFloat(numberOfColumn - 1) * imageMargin
    //计算高 行数 = (总数 + 列数 - 1) / 列数
    let row = (count! + numberOfColumn - 1) / numberOfColumn
    let height = CGFloat(row) * imageWH + CGFloat(row - 1) * imageMargin

    return CGSizeMake(width, height)
  }
  
  lazy var testLabel: UILabel = UILabel()
  
}


//MARK : - SDPhotoBrowserDelegate
extension MPPictureView: SDPhotoBrowserDelegate {
  func photoBrowser(browser: SDPhotoBrowser!, placeholderImageForIndex index: Int) -> UIImage! {
    let imageView = imageViewArray[index]
    return imageView.image
  }
  
  func photoBrowser(browser: SDPhotoBrowser!, highQualityImageURLForIndex index: Int) -> NSURL! {
    let urlString = pictureUrlArray![index].absoluteString
    // 换成大图
    let largeUrlString = urlString.stringByReplacingOccurrencesOfString("thumbnail", withString: "large")

    return NSURL(string: largeUrlString)
  }
}
