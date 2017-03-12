//
//  MPPullDownRefreshView.swift
//  PullDownRefresh
//
//  Created by Maple on 16/7/25.
//  Copyright © 2016年 Maple. All rights reserved.
//

import UIKit


enum MPPullDownRefreshViewStatus {
  case Normal      ///下拉刷新状态
  case Pulling     ///释放刷新状态
  case Refreshing  ///正在刷新状态
}

///下拉刷新控件
class MPPullDownRefreshView: UIView {
  ///当前控件状态，默认是下拉刷新状态
  var currentStatus: MPPullDownRefreshViewStatus = .Normal {
    didSet{
      switch currentStatus {
      case .Normal:
        UIView.animateWithDuration(0.25, animations: {
          self.arrowImageView.transform = CGAffineTransformIdentity
        })
        infoLabel.text = "下拉刷新"
      case .Pulling:
        infoLabel.text = "释放刷新"
        UIView.animateWithDuration(0.25, animations: { 
          self.arrowImageView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        })
      case .Refreshing:
        infoLabel.text = "正在刷新..."
        arrowImageView.hidden = true
        loadingImageView.hidden = false
        //添加旋转动画
        let ba = CABasicAnimation(keyPath: "transform.rotation")
        ba.toValue = M_PI * 2
        ba.duration = 0.75
        ba.repeatCount = MAXFLOAT
        ba.removedOnCompletion = false
        loadingImageView.layer.addAnimation(ba, forKey: nil)
        
        //停留
        UIView.animateWithDuration(0.25, animations: { 
          self.mySuperView?.contentInset.top = self.mySuperView!.contentInset.top + self.frame.height
        })
        
        //执行回调
        refreshingCallBack?()
      }
    }
  }
  
  ///刷新执行闭包
  var refreshingCallBack: (() -> Void)?
  
  ///记录父视图
  var mySuperView: UIScrollView?
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(frame: CGRect) {
    let newFrame = CGRectMake(0, -60, UIScreen.mainScreen().bounds.width, 60)
    super.init(frame: newFrame)
    setupUI()
  }
  
  ///即将添加到父视图时，添加父视图监听
  override func willMoveToSuperview(newSuperview: UIView?) {
    //如果父视图是Scrollview则添加监听
    if newSuperview is UIScrollView {
      mySuperView = newSuperview as? UIScrollView
      mySuperView?.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
    }
  }
  
  deinit {
    mySuperView?.removeObserver(self, forKeyPath: "contentOffset")
  }
  
  override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
    //判断控件的状态，分别判断拖拽和释放两种情况
    if mySuperView!.dragging {
      // normal ==> pulling
      // 1.当前是normal状态  2.offY < -124
      if currentStatus == .Normal && mySuperView?.contentOffset.y < -124{
        currentStatus = .Pulling
        
        // pulling ==> normal
        // 1.当前是pulling状态  2.offY > -124
      }else if currentStatus == .Pulling && mySuperView?.contentOffset.y > -124 {
        self.currentStatus = .Normal
      }
    }else {
      if currentStatus == .Pulling {
        self.currentStatus = .Refreshing
      }
    }
    
  }
  
  private func setupUI() {
    addSubview(loadingImageView)
    addSubview(arrowImageView)
    addSubview(infoLabel)
    //默认异常loadingImageView
    loadingImageView.hidden = true
    loadingImageView.translatesAutoresizingMaskIntoConstraints = false
    arrowImageView.translatesAutoresizingMaskIntoConstraints = false
    infoLabel.translatesAutoresizingMaskIntoConstraints = false
    self.addConstraint(NSLayoutConstraint(item: loadingImageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: -40))
    
    self.addConstraint(NSLayoutConstraint(item: loadingImageView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0))
    
    self.addConstraint(NSLayoutConstraint(item: arrowImageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: loadingImageView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))

    self.addConstraint(NSLayoutConstraint(item: arrowImageView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: loadingImageView, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0))
    
    self.addConstraint(NSLayoutConstraint(item: infoLabel, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: arrowImageView, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 10))
    
    self.addConstraint(NSLayoutConstraint(item: infoLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: arrowImageView, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0))
  }
  
  //MARK: - 公开方法
  ///结束刷新
  func endRefreshing() {
    if currentStatus == .Refreshing {
      currentStatus = .Normal
      //隐藏
      UIView.animateWithDuration(0.25, animations: {
        self.mySuperView?.contentInset.top = self.mySuperView!.contentInset.top - self.frame.height
      })
      loadingImageView.hidden = true
      loadingImageView.layer.removeAllAnimations()
      arrowImageView.hidden = false
    }
  }
  ///开始刷新
  func beginRefresh() {
    currentStatus = .Refreshing
  }
  
  //MARK: - 懒加载
  ///箭头
  lazy var arrowImageView = UIImageView(image: UIImage(named:"tableview_pull_refresh"))
  ///加载
  lazy var loadingImageView = UIImageView(image: UIImage(named:"tableview_loading"))
  ///信息label
  lazy var infoLabel: UILabel = {
    let label: UILabel = UILabel()
    label.text = "下拉刷新"
    label.sizeToFit()
    label.textColor = UIColor.darkGrayColor()
    label.font = UIFont.systemFontOfSize(15)
    return label
  }()
}



