//
//  SQLManager.swift
//  数据库操作
//
//  Created by Maple on 16/8/5.
//  Copyright © 2016年 Maple. All rights reserved.
//

import Foundation
import FMDB

class SQLManager: NSObject {
  ///单例对象
  static let sharedManager = SQLManager()
  ///数据库对象
  let dbQueue: FMDatabaseQueue
  
  override init() {
    let dbPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last! + "/fmdb.db"
    print("dbPath: \(dbPath)")
    self.dbQueue = FMDatabaseQueue(path: dbPath)
    super.init()
    
    createTable("T_Status")
  }
  
  private func createTable(tableName: String) {
    //         CREATE TABLE IF NOT EXISTS \(tableName) (statusId INTEGER PRIMARY KEY, status TEXT, userId INTEGER, createTime TEXT DEFAULT (datetime('now', 'localtime')));
    let sql = "CREATE TABLE IF NOT EXISTS \(tableName) (status_id integer primary key, status text, user_id integer, createTime TEXT DEFAULT (datetime('now', 'localtime')));"
    
    dbQueue.inDatabase { (db) in
      do {
        try db.executeUpdate(sql, values: [])
      }catch let error as NSError {
        // 如果真的出现异常就到这里面,程序还会正常执行
        print("出现异常: \(error)")
      }
    }
  }
}
