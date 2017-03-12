//
//  MPOAuthViewController.swift
//  MPWeibo
//
//  Created by Maple on 16/7/19.
//  Copyright © 2016年 Maple. All rights reserved.
//

import UIKit
import SVProgressHUD

/// 授权登陆控制器
class MPOAuthViewController: UIViewController {

  //将view替换为UIWebview
  override func loadView() {
    self.view = webView
    webView.delegate = self
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    SVProgressHUD.showWithStatus("正在加载中...")
    //设置导航条
    setUpNaigationBar()
    //加载登陆授权页面
    let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(client_id)&redirect_uri=\(redirect_uri)"
    webView.loadRequest(NSURLRequest(URL: NSURL(string: urlString)!))
  }
  
  /**
   设置导航条
   */
  private func setUpNaigationBar() {
    self.navigationItem.title = "登陆"
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "填充", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MPOAuthViewController.fill))
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MPOAuthViewController.cancle))
  }
  
  /**
   点击填充
   */
  @objc private func fill() {
    //document.getElementById('userId').value='18819457942'
    //document.getElementById('passwd').value='maple123'
    let jsString = "document.getElementById('userId').value='18819457942'; document.getElementById('passwd').value='maple123456'"
    //执行js代码
    webView.stringByEvaluatingJavaScriptFromString(jsString)
  }
  
  /**
   点击取消
   */
  @objc private func cancle() {
    SVProgressHUD.dismiss()
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  //MARK: - 懒加载
  lazy var webView = UIWebView()
}

//MARK: - UIWebViewDelegate
extension MPOAuthViewController: UIWebViewDelegate {
  func webViewDidFinishLoad(webView: UIWebView) {
    //加完完毕后关闭蒙版
    SVProgressHUD.dismiss()
  }
  
  func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
    let urlString = request.URL!.absoluteString
    let url = request.URL!
    
    //授权成功返回的“code=”前缀
    let authPrefix = "code="
    if urlString.hasPrefix(redirect_uri) {
      //code=6eae83fdabb72724e422ff4607dbb1b4  点击授权
      //error_uri=%2Foauth2%2Fauthorize&error  点击取消
      if url.query!.hasPrefix(authPrefix) {
        //截取code的值
        let NSQuery = url.query! as NSString
        let code = NSQuery.substringFromIndex(authPrefix.characters.count)
        //发送post请求
        MPUserAccountViewModel.sharedUserAccountViewModel.saveUserAccount(code, compeletion: { (error) in
          if error == nil {
            //成功
            self.cancle()
            AppDelegate.changRootViewController(MPWelcomeViewController())
          }else {
            //失败
            SVProgressHUD.showErrorWithStatus("加载accessToken失败")
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), { 
              self.cancle()
            })
          }
        })
      }
      return false
    }else {
      return true
    }
  }
}






