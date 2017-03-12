//
//  AppDelegate.swift
//  MPWeibo
//
//  Created by Maple on 16/7/18.
//  Copyright © 2016年 Maple. All rights reserved.
//

import UIKit
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    SVProgressHUD.setMinimumDismissTimeInterval(2)
    setUpNavBar()
    //测试
//    let isLogin = MPUserAccountViewModel.sharedUserAccountViewModel.isLogin
    //创建窗口
    window = UIWindow(frame: UIScreen.mainScreen().bounds)
    window?.rootViewController = selectRootController()
    //显示
    window?.makeKeyAndVisible()
    
    return true
  }
  
  class func changRootViewController(controller: UIViewController) {
    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
    delegate.window?.rootViewController = controller
  }
  
  /**
   返回根控制器
   */
  private func selectRootController() -> UIViewController {
    if MPUserAccountViewModel.sharedUserAccountViewModel.isLogin {
      //用户登陆
      if isNewVersion() {
        //新版本
        return MPNewFeatureViewController()
      }else {
        return MPWelcomeViewController()
      }
    }else {
      //用户没有登陆
      return MPTabBarController()
    }
  }
  
  /**
   判断是否为新版本
   */
  private func isNewVersion() -> Bool {
    let currentVersion = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
    let key = "version"
    let lastVersion = NSUserDefaults.standardUserDefaults().stringForKey(key)
    if (lastVersion == nil) {
      //存储当前版本
      NSUserDefaults.standardUserDefaults().setObject(currentVersion, forKey: key)
      NSUserDefaults.standardUserDefaults().synchronize()
    }
    let isNew: Bool = (currentVersion != lastVersion)
    return isNew
  }
  
  /**
   设置navBar的样式
   */
  private func setUpNavBar() {
    let bar = UINavigationBar.appearance()
    bar.tintColor = UIColor.orangeColor()
  }

  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(application: UIApplication) {
    // 应用退出到后台清除缓存
    MPStatusDAL.sharedStatusDAL.clearCache()
  }

  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }


}

