//
//  MPHomeTableViewController.swift
//  MPWeibo
//
//  Created by Maple on 16/7/18.
//  Copyright © 2016年 Maple. All rights reserved.
//

import UIKit
import SVPullToRefresh

class MPHomeTableViewController: MPBaseTableViewController {

  var statusArray: [MPStatus]? {
    didSet {
      self.tableView.reloadData()
    }
  }
  
  let resuedID = "cell"
    override func viewDidLoad() {
        super.viewDidLoad()
      //判断当前是否为登陆状态
      if MPUserAccountViewModel.sharedUserAccountViewModel.isLogin == false{
        return
      }
      //添加ftp帧率检测器
      // 显示FPS
      UIApplication.sharedApplication().keyWindow?.showInCenter()
      
      //设置导航栏
      setUpBar()
      //设置tableview
      setupTableView()
      //设置标题栏
      if let name = MPUserAccountViewModel.sharedUserAccountViewModel.userAccount?.screen_name {
        setupTitle(name)
      }
      //添加下拉控件
      self.tableView.addSubview(pullDownRefreshView)
      //设置下拉回调
      pullDownRefreshView.refreshingCallBack = {
        self.loadNewData()
      }
      //开始刷新数据
      self.pullDownRefreshView.beginRefresh()
     
      //设置上拉控件
      self.tableView.addInfiniteScrollingWithActionHandler { 
        self.loadMoreData()
      }
    }
  
  /**
   提示刷新了多少条新数据
   
   - parameter count: 新数据条数
   */
  private func showTipLabel(count: Int) {
    //如果已经设置了动画，就不设置，直接返回
    if tipLabel.layer.animationKeys() != nil{
      return
    }
    
    let text = count == 0 ? "没有可加载的微博" : "加载了\(count)条微博"
    self.tipLabel.text = text
    UIView.animateWithDuration(1, animations: { 
      self.tipLabel.frame.origin.y = 44
      }) { (_) in
      //1s后隐藏
      UIView.animateWithDuration(1, delay: 1, options: UIViewAnimationOptions(rawValue: 0), animations: {
        self.tipLabel.frame.origin.y = -64
        }, completion: nil)
    }
  }
  
  ///下拉刷新调用此方法
  private func loadNewData() {
    let status = self.statusArray?.first
    let since_id: Int64 = status?.id ?? 0
    MPStatusViewModel.sharedStatusViewModel.loadStatusData(since_id, max_id: 0) { (error, statusArray) in
      //结束刷新
      self.pullDownRefreshView.endRefreshing()
      if error != nil {
        //出错
        print(error)
        return
      }
      
      //判断是否第一次刷新
      if since_id == 0 {
        self.statusArray = statusArray
      }else {
        let count = statusArray?.count ?? 0
        if count == 0 {
          print("没有加载到微博数据")
          return
        }
        self.showTipLabel(count)
        self.statusArray = statusArray! + self.statusArray!
      }
      
    }
  }
  
  ///上拉刷新调用此方法
  private func loadMoreData() {
    let status = self.statusArray?.last
    let max_id: Int64 = status?.id ?? 0
    MPStatusViewModel.sharedStatusViewModel.loadStatusData(0, max_id: max_id) { (error, statusArray) in
      //结束刷新
      if error != nil {
        //出错
        print(error)
        return
      }
      self.tableView.infiniteScrollingView.stopAnimating()
      self.statusArray = self.statusArray! + statusArray!
    }
  }
  
  ///设置tableview属性
  private func setupTableView() {
    //设置tableview自适应高度
//    self.tableView.estimatedRowHeight = 200
//    self.tableView.rowHeight = UITableViewAutomaticDimension
    self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    self.tableView.allowsSelection = false
    //注册cell
    self.tableView.registerClass(MPStatusViewCell.self, forCellReuseIdentifier: resuedID)

  }

  private func setUpBar() {
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendsearch")
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop")
  }
  
  private func setupTitle(title: String) {
    let button = MPHomeButton(title: title)
    button.addTarget(self, action: #selector(MPHomeTableViewController.titleClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    self.navigationItem.titleView = button
  }
  
  @objc private func titleClick(button: UIButton) {
    button.selected = !button.selected
    var transform = CGAffineTransformIdentity
    if button.selected {
      //这里要注意的是UIView会选择最短路径，所以这里-0.001可以原路返回
      transform = CGAffineTransformMakeRotation(CGFloat(M_PI - 0.001))
    }else {
      transform = CGAffineTransformIdentity
    }
    UIView.animateWithDuration(defaultDuration, animations: {
      button.imageView?.transform = transform
    })
    
  }
  
  //MARK: - 懒加载
  ///下拉刷新控件
  lazy var pullDownRefreshView: MPPullDownRefreshView = MPPullDownRefreshView()
  ///刷新提示Label
  lazy var tipLabel: UILabel = {
    let label = UILabel()
    label.backgroundColor = UIColor.orangeColor()
    label.textColor = UIColor.whiteColor()
    label.textAlignment = NSTextAlignment.Center
    label.frame = CGRectMake(0, -64, UIScreen.width(), 44)
    label.text = "刷新了X条数据"
    self.navigationController?.navigationBar.insertSubview(label, atIndex: 0)
    return label
  }()
}

// MARK: - Table view data source
extension MPHomeTableViewController {
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return statusArray?.count ?? 0
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//    let cell = tableView.dequeueReusableCellWithIdentifier(resuedID, forIndexPath: indexPath) as! MPStatusViewCell
    let cell = tableView.dequeueReusableCellWithIdentifier(resuedID) as! MPStatusViewCell
    //取出模型
    let status: MPStatus = statusArray![indexPath.row]
    cell.status = status
    return cell
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    let rowHeight = self.statusArray?[indexPath.row].cellHeight ?? 0
    return rowHeight
  }
}
