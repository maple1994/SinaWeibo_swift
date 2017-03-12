//
//  MPStatusDAL.swift
//  MPWeibo
//
//  Created by Maple on 16/8/6.
//  Copyright © 2016年 Maple. All rights reserved.
//

import Foundation

class MPStatusDAL: NSObject {
  ///单例对象
  static let sharedStatusDAL:MPStatusDAL = MPStatusDAL()
  ///清除缓存的时间，一般是7天
  let clearTime: NSTimeInterval = 60 //60 * 60 * 24 * 7
  //清除缓存
  func clearCache() {
    let date = NSDate(timeIntervalSinceNow: -clearTime)
    let df = NSDateFormatter()
    df.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let dateString = df.stringFromDate(date)
    let sql = "DELETE FROM T_Status where createTime < '\(dateString)'"
    SQLManager.sharedManager.dbQueue.inDatabase { (db) in
      do{
        try db.executeUpdate(sql, values: [])
      }catch let error as NSError {
        print("清除失败:\(error)")
      }
    }
  }
  
  // 加载微博数据
  func loadStatus(since_id: Int64, max_id: Int64, compeletion: (error: NSError?, statusArray: [[String: AnyObject]]?) -> Void) {
    // 1.查看本地是否有缓存数据
    loadLocalData(Int(since_id), max_id: Int(max_id)) { (error, statues) in
      if error != nil {
        print("数据操作有误\(error)")
        compeletion(error: error, statusArray: nil)
        return
      }
      // 2.如果有缓存数据,直接返回
      if statues != nil && statues?.count > 0 {
        print("本地有数据")
        compeletion(error: nil, statusArray: statues)
        return
      }
      
      // 3.如果没有缓存数据,去网络加载数据
      let account = MPUserAccountViewModel.sharedUserAccountViewModel.userAccount!
      let urlString = "2/statuses/home_timeline.json"
      var paramaters: [String: AnyObject] = ["access_token": account.access_token!
      ]
      //需要获取下拉新数据
      if since_id > 0 {
        paramaters["since_id"] = NSNumber(longLong: since_id)
      }
      //需要获取上拉数据
      if max_id > 0 {
        paramaters["max_id"] = NSNumber(longLong: max_id - 1)
      }
      
      //发送请求
      MPHttpTool.sharedHttpTool.request(MPNetworkMethod.GET, URLString: urlString, parameters: paramaters, progress: nil, success: { (task, responseObject) in
        print("从网络加载数据")
        //转字典
        let data = responseObject as! [String: AnyObject]
        let statuses = data["statuses"] as! [[String: AnyObject]]
        // 4.缓存网络加载的数据到本地数据库
        self.saveStatus(statuses)
        // 5.返回数据给调用者
        compeletion(error: nil, statusArray: statuses)
      }) { (task, error) in
        print(error)
        // 5.返回数据给调用者
        compeletion(error: error, statusArray: nil)
      }

    }
  }

  
  ///从本地加载数据
  private func loadLocalData(since_id: Int, max_id: Int, completion: (error: NSError?, statues: [[String: AnyObject]]?) -> Void) {
    let userID = MPUserAccountViewModel.sharedUserAccountViewModel.userAccount?.uid
    //断言
    assert(userID != nil, "userID为空")
    var sql = "SELECT status_id, status, user_id FROM T_Status WHERE user_id = \(userID!)\n"
    //根据maxid和sinceid判断是上拉刷新还是下拉刷新
    if max_id > 0 {
      //上拉刷新
      sql += "AND status_id < \(max_id)\n"
    }
    if since_id > 0  {
      //下拉刷新
      sql += "AND status_id > \(since_id)\n"
    }
    sql += "ORDER BY status_id DESC LIMIT 2;"
    SQLManager.sharedManager.dbQueue.inDatabase { (db) in
      do {
        let result = try db.executeQuery(sql, values: [])
        var statusArray:[[String: AnyObject]] = [[String: AnyObject]]()
        while result.next() {
          //string -> data -> json
          let status = result.stringForColumn("status")
          let data = status.dataUsingEncoding(NSUTF8StringEncoding)
          let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0))
          statusArray.append(json as! [String: AnyObject])
        }
        completion(error: nil, statues: statusArray)
      }catch let error as NSError{
        print("error:\(error))")
        completion(error: error, statues: nil)
      }

    }
  }
  
  ///保存网络数据到本地
  private func saveStatus(statues: [[String: AnyObject]]) {
    //print(statues)
    //status_id integer primary key, status text, user_id integer
    let userID = MPUserAccountViewModel.sharedUserAccountViewModel.userAccount?.uid
    //断言
    assert(userID != nil, "userID为空")
    let sql = "INSERT INTO T_Status (status_id, status, user_id) VALUES(?, ?, \(userID!))"

    SQLManager.sharedManager.dbQueue.inTransaction { (db, rollback) in
      //遍历字典
      for dic in statues {
        do {
          /*
           let sql = "CREATE TABLE IF NOT EXISTS \(tableName) (status_id integer primary key, status text, user_id integer);"
           */
          let statusID = dic["id"] as! NSNumber
          //数据库不能直接存放字典
          //json -> data -> string
          let data = try NSJSONSerialization.dataWithJSONObject(dic, options: NSJSONWritingOptions(rawValue: 0))
          let status = String(data: data, encoding: NSUTF8StringEncoding)
          //保存到数据库
          try db.executeUpdate(sql, values: [statusID, status!])
        }catch let error as NSError{
          //出错就回滚
          rollback.memory = true
          print("error:\(error))")
        }
      }
      print("保存了 \(statues.count) 条微博数据到数据库")
    }
  }
}
