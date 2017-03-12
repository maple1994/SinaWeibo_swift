//
//  MPNewFeatureViewController.swift
//  MPWeibo
//
//  Created by Maple on 16/7/21.
//  Copyright © 2016年 Maple. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class MPNewFeatureViewController: UICollectionViewController {

  ///流水布局
  let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
  
  ///item的个数
  let itemCount = 4
  
  init() {
    super.init(collectionViewLayout: layout)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.registerClass(MPNewFeatureCell.self, forCellWithReuseIdentifier: reuseIdentifier)
      setUpLayout()
    }
  
  private func setUpLayout() {
    layout.itemSize = self.view.bounds.size
    layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    self.collectionView?.pagingEnabled = true
    self.collectionView?.bounces = false
  }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return itemCount
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MPNewFeatureCell
//      cell.backgroundColor = UIColor.randomColor()
      cell.image = UIImage(named: "new_feature_\(indexPath.item + 1)")
      if indexPath.item == itemCount - 1 {
        //显示
        cell.showButton(true)
      }else {
        //隐藏
        cell.showButton(false)
      }
        return cell
    }

}
