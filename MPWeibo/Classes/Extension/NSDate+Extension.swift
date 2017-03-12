//
//  NSDate+Extension.swift
//  日期判断
//
//  Created by Maple on 16/7/26.
//  Copyright © 2016年 Maple. All rights reserved.
//

import Foundation

extension NSDate {
  /**
   根据新浪的时间字符串转化为NSDate对象
   
   - parameter dateString: 新浪的时间字符串
   */
  class func dateFromString(dateString: String) -> NSDate? {
    let creat_at = dateString
    let df = NSDateFormatter()
    // 如果是真机
    df.locale = NSLocale(localeIdentifier: "EN")
    //EEE MMM dd HH:mm:ss zzz yyyy
    df.dateFormat = "EEE MMM dd HH:mm:ss zzz yyyy"
    let date = df.dateFromString(creat_at)
    return date
  }
  

  /// 返回新浪时间表现格式
  ///     -   刚刚(一分钟内)
  ///     -   X分钟前(一小时内)
  ///     -   X小时前(当天)
  ///     -   昨天 HH:mm(昨天)
  ///     -   MM-dd HH:mm(一年内)
  ///     -   yyyy-MM-dd HH:mm(更早期)
  func sinaDateDescription() -> String {
    let calendar = NSCalendar.currentCalendar()
    //是否在今天
    if calendar.isDateInToday(self) {
      //获得当前时间和传入时间的差值
      let delta = Int(NSDate().timeIntervalSinceDate(self))
      //一分钟内
      if delta < 60 {
        return "刚刚"
        //X分钟前
      }else if delta < 60 * 60 {
        return "\(delta / 60)分钟前"
      }else {
        return "\(delta / 60 / 60)小时前"
      }
    }
    
    let df = NSDateFormatter()
    df.locale = NSLocale(localeIdentifier: "EN")
    //是否在昨天
    if calendar.isDateInYesterday(self) {
      df.dateFormat = "昨天 HH:mm"
      return df.stringFromDate(self)
    }
    if calendar.compareDate(self, toDate: NSDate(), toUnitGranularity: NSCalendarUnit.Year) == NSComparisonResult.OrderedSame{
      //同一年
      df.dateFormat = "MM-dd HH:mm"
      return df.stringFromDate(self)
    }else {
      //更早期
      df.dateFormat = "yyyy-MM-dd HH:mm"
      return df.stringFromDate(self)
    }
  }
}
