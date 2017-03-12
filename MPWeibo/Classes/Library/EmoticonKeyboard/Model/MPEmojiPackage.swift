//
//  MPEmojiPackage.swift
//  emojiKeyboard
//
//  Created by Maple on 16/7/29.
//  Copyright © 2016年 Maple. All rights reserved.
//

import UIKit

///定义表情包模型
class MPEmojiPackage: NSObject {
  ///表情包的文件夹名
  var id: String
  ///表情模型数组
  var emoticons: [MPEmoji]
  ///表情包名字
  var group_name_cn: String
  ///分页处理
  var pageEmoticons: [[MPEmoji]] = [[MPEmoji]]()
  
  init(id: String, group_name_cn: String, emoticons: [MPEmoji]) {
    self.id = id
    self.group_name_cn = group_name_cn
    self.emoticons = emoticons
    super.init()
    splitEmoticons()
  }
  
  ///将emoticons数组分成20一组的二维数组
  private func splitEmoticons() {
    //一页最多maxCountOfPage
    let nsEmoticons = emoticons as NSArray
    //计算可以分成页
    let pageCount = (emoticons.count + maxCountOfPage - 1) / maxCountOfPage
    //如果一页都没有，则添加一页
    if pageCount == 0 {
      pageEmoticons.append(emoticons)
    }
    for  i in 0..<pageCount {
      let start = i * maxCountOfPage
      var length = maxCountOfPage
      //判断是否超出边界
      if start + length > emoticons.count {
        length = emoticons.count - start
      }
      let range = NSRange(location: start, length: length)
      let subEmoticon = nsEmoticons.subarrayWithRange(range) as! [MPEmoji]
      pageEmoticons.append(subEmoticon)
    }
  }
  
  /// 对象打印方法
  override var description: String {
    return "表情包模型: id:\(id), group_name_cn:\(group_name_cn), emoticons:\(emoticons)"
  }
}
