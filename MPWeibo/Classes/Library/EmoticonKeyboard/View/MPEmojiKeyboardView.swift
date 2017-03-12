//
//  MPEmojiKeyboardView.swift
//  emojiKeyboard
//
//  Created by Maple on 16/7/28.
//  Copyright © 2016年 Maple. All rights reserved.
//

import UIKit
///键盘高度
let keyboardHeight: CGFloat = 216
///表情键盘类
class MPEmojiKeyboardView: UIView {
  ///外部传进来的textView
  weak var textView: UITextView?
  
  ///布局layout
  let layout: UICollectionViewFlowLayout = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.minimumLineSpacing = 0
    flowLayout.minimumInteritemSpacing = 0
    flowLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
    return flowLayout
  }()
  
  ///重用标识
  let ReuseIdentifier = "ReuseIdentifier"
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(frame: CGRect) {
    let newFrame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: keyboardHeight)
    super.init(frame: newFrame)
    setupUI()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    layout.itemSize = self.collectView.frame.size
  }
  
  private func setupUI() {
    //添加控件
    self.addSubview(collectView)
    self.addSubview(toolbar)
    self.addSubview(pageControl)
    //设置约束
    collectView.translatesAutoresizingMaskIntoConstraints = false
    toolbar.translatesAutoresizingMaskIntoConstraints = false
    pageControl.translatesAutoresizingMaskIntoConstraints = false
    
    
    //可视化约束语句
    self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[cv]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["cv" : collectView]))
    self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[tb]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["tb" : toolbar]))
    self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[cv]-0-[tb(==44)]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["cv" : collectView, "tb" : toolbar]))
    //设置指示器属性
    self.addConstraint(NSLayoutConstraint(item: pageControl, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
    self.addConstraint(NSLayoutConstraint(item: pageControl, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: collectView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
    self.addConstraint(NSLayoutConstraint(item: pageControl, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 25))
  }
  
  ///切换pageControl
  private func setupPageControl(indexPath: NSIndexPath) {
    pageControl.numberOfPages = MPEmojiManager.sharedManager.emojiPackages[indexPath.section].pageEmoticons.count
    pageControl.currentPage = indexPath.item
  }
  
  //MARK: - 懒加载
  ///工具条
  private lazy var toolbar: MPEmojiToolbar = {
    let toolbar = MPEmojiToolbar()
    toolbar.delegate = self
    return toolbar
  }()
  ///collectionView
  private lazy var collectView: UICollectionView = {
    let cv = UICollectionView(frame: CGRectZero, collectionViewLayout: self.layout)
    cv.backgroundColor = UIColor.yellowColor()
    //注册cell
    cv.registerClass(MPEmojiCell.self, forCellWithReuseIdentifier: self.ReuseIdentifier) 
    //代理
    cv.dataSource = self
    cv.delegate = self
    //分页显示
    cv.pagingEnabled = true
    cv.bounces = false
    return cv
  }()
  ///分页指示器
  private lazy var pageControl: UIPageControl = {
    let pc = UIPageControl()
    pc.hidesForSinglePage = true
    //_currentPageImage  _pageImage
    pc.setValue(UIImage(named:"compose_keyboard_dot_selected"), forKey: "currentPageImage")
    pc.setValue(UIImage(named:"compose_keyboard_dot_normal"), forKey: "pageImage")
    return pc
  }()
}
//MARK: - UICollectView代理
extension MPEmojiKeyboardView: UICollectionViewDataSource, UICollectionViewDelegate {
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return MPEmojiManager.sharedManager.emojiPackages.count
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    let package = MPEmojiManager.sharedManager.emojiPackages[section]
    return package.pageEmoticons.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectView.dequeueReusableCellWithReuseIdentifier(ReuseIdentifier, forIndexPath: indexPath) as! MPEmojiCell
    
    //设置代理
    cell.delegate = self
    cell.indexPath = indexPath
    let package = MPEmojiManager.sharedManager.emojiPackages[indexPath.section]
    cell.pageEmoji = package.pageEmoticons[indexPath.row]
    return cell
  }
  
  func scrollViewDidScroll(scrollView: UIScrollView) {
    //collectView中间参照点
    var refPoint = self.collectView.center
    
    //统一坐标系
    refPoint.x += scrollView.contentOffset.x
    //遍历现在正显示的cell，判断那个cell包含参照点
    for cell in self.collectView.visibleCells() {
      if cell.frame.contains(refPoint) {
        //获得当前显示cell的indexpath
        let indexPath = self.collectView.indexPathForCell(cell)
        //选中对应的按钮
        self.toolbar.switchButton(indexPath!.section)
        //切换pageCount页码
        setupPageControl(indexPath!)
      }
    }
  }
}

//MARK: - toobar代理
extension MPEmojiKeyboardView: MPEmojiToolbarDelegate {
  func emojjToolbar(buttonDidClick button: UIButton, type: MPEmojiToolbarType) {
    let indexPath = NSIndexPath(forItem: 0, inSection: type.rawValue)
    //让collectionView滚到指定的位置
    self.collectView.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: UICollectionViewScrollPosition.Left)
    
    //切换pageCount页码
    setupPageControl(indexPath)
  }
}

//MARK: - MPEmojiCellDelegate
extension MPEmojiKeyboardView: MPEmojiCellDelegate {
  func emojiCell(didClickButton emojiModel: MPEmoji) {
    //插入表情
    self.textView?.insert(emojiModel)
    //给“最近”添加表情
    MPEmojiManager.sharedManager.addFavorite(emojiModel)
  }
  
  func emojiCellDidClickDelte() {
    self.textView?.deleteBackward()
  }
}





