//
//  MPStatus.swift
//  MPWeibo
//
//  Created by Maple on 16/7/22.
//  Copyright © 2016年 Maple. All rights reserved.
//

import UIKit

///微博模型
class MPStatus: NSObject {
  //MARK: - 属性
  
  ///微博创建时间
  var created_at: String?
  ///微博ID
  var id: Int64 = 0
  ///微博信息内容
  var text:	String? {
    didSet {
      emoticonString = MPEmoji.stringToEmoticonString(text!, font: UIFont.systemFontOfSize(statusFontSize))
    }
  }
  /// 带表情图片的属性文本
  var emoticonString: NSAttributedString?
  ///配图u字典数组
  var pic_urls: [[String: AnyObject]]? {
    didSet {
      pictureUrlArray = [NSURL]()
      for dic in pic_urls! {
        let urlStirng = dic["thumbnail_pic"] as! String
        let url = NSURL(string: urlStirng)
        pictureUrlArray?.append(url!)
      }
    }
  }
  ///配图url数组
  var pictureUrlArray: [NSURL]?
  ///微博来源
  var source:	String? {
    didSet {
      if source?.characters.count == 0 {
        source = "未知来源"
      }else {
        let NSSource = source! as NSString
        let rangeFirst = NSSource.rangeOfString(">")
        let rangeSecond = NSSource.rangeOfString("</")
        //截取
        source = NSSource.substringWithRange(NSMakeRange(rangeFirst.location + 1, rangeSecond.location - rangeFirst.location - 1))
      }
    }
  }
  ///转发数
  var reposts_count: Int = 0
  ///评论数
  var comments_count: Int = 0
  ///表态数
  var attitudes_count: Int = 0
  ///用户模型
  var user: MPUser?
  ///转发微博，不一定存在！
  var retweeted_status: MPStatus?
  ///cell的高度
  var cellHeight: CGFloat?
  /// 被转发微博拼接好的文字,带用户名从
  var retweetedText: String?

  
  ///计算行高
  private func calRowHeight() {
    //cell间距(8) + 头像间距(8) + 头像高度(35) + 头像和内容间距(8) + 内容高度(计算)
    //配图? 配图高度 + 间距
    //转发？ 间距 + 内容高度 + 间距
    //转发配图？ 配图高度 + 间距
    //cell间距(8) + 头像间距(8) + 头像高度(35) + 头像和内容间距(8)
    var height = cellMargin + cellMargin + iconWH + cellMargin
    //内容高度
    let content = text! as NSString
    height += content.boundingRectWithSize(CGSizeMake(UIScreen.width() - 2 * cellMargin, CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(statusFontSize)], context: nil).height
    //内容间距
    height += cellMargin
    //配图
    let count = pictureUrlArray?.count ?? 0
    if count > 0 {
      height += calPictureSize(pictureUrlArray).height
      height += cellMargin
    }
    //转发
    if let retweeted_status = self.retweeted_status {
      height += cellMargin
//      print(retweeted_status.retweetedText!)
      let nsRetweetString = retweeted_status.retweetedText! as NSString
      height += nsRetweetString.boundingRectWithSize(CGSizeMake(UIScreen.width() - 2 * cellMargin, CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(statusFontSize)], context: nil).height
      height += cellMargin
      //转发配图
      let retweetCount = retweeted_status.pictureUrlArray?.count ?? 0
      if retweetCount > 0 {
        height += calPictureSize(retweeted_status.pictureUrlArray!).height
        height += cellMargin
      }
    }
    
    height += bottomViewHeight
    cellHeight = height
  }
  
  ///计算配图高度
  private func calPictureSize(pictureArray: [NSURL]?) -> CGSize {
    var numberOfColumn = maxColumn
    let count = pictureArray?.count ?? 0

    if count == 1 {
      numberOfColumn = 1
    }else if count == 2 || count == 4 {
      numberOfColumn = 2
    }
    if count == 0 {
      return CGSizeZero
    }
    //计算宽
    let width = CGFloat(numberOfColumn) * imageWH + CGFloat(numberOfColumn - 1) * imageMargin
    //计算高 行数 = (总数 + 列数 - 1) / 列数
    let row = (count + numberOfColumn - 1) / numberOfColumn
    let height = CGFloat(row) * imageWH + CGFloat(row - 1) * imageMargin
    
    return CGSizeMake(width, height)
  }
  
  init(dic: [String: AnyObject]) {
    super.init()
    setValuesForKeysWithDictionary(dic)
    //计算模型高度
    calRowHeight()
  }
  
  override func setValue(value: AnyObject?, forKey key: String) {
    if key == "user" {
      let dic = value as! [String: AnyObject]
        self.user = MPUser(dic: dic)
    }else if key == "retweeted_status" {

      if let dict = value as? [String: AnyObject] {
        // 字典转模型
        retweeted_status = MPStatus(dic: dict)
        
        // 拼接完整的被转发微博内容
        let name = retweeted_status?.user?.screen_name ?? "没有名称"
        let text = retweeted_status?.text ?? "没有微博内容"
        let content = "@ \(name): \(text)"
        
        retweeted_status?.retweetedText = content
      }

    }else {
      super.setValue(value, forKey: key)
    }
  }
  
  override func setValue(value: AnyObject?, forUndefinedKey key: String) {
  }
  
  override var description: String {
    get {
      let keys = ["created_at","id","text","source","reposts_count","comments_count","attitudes_count", "pic_urls", "user"]
      return "\n\n微博模型：" + dictionaryWithValuesForKeys(keys).description
    }
  }
}








