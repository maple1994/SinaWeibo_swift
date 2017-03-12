//
//  MPEmojiManager.swift
//  emojiKeyboard
//
//  Created by Maple on 16/7/29.
//  Copyright © 2016年 Maple. All rights reserved.
//

import UIKit

///负责加载表情数据的工具类
class MPEmojiManager: NSObject {
  ///单例对象
  static let sharedManager = MPEmojiManager()
  ///mainBundle路径
  let bundlePath = NSBundle.mainBundle().pathForResource("Emoticons.bundle", ofType: nil)
  ///"最近"表情包的存储路径
  let recentPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last! + "/" + "recent.plist"
  lazy var emojiPackages:[MPEmojiPackage] = self.loadAllEmojiPackage()
  
  ///添加最近表情
  func addFavorite(emojiModel: MPEmoji) {
    var recentPageEmoticons = emojiPackages[0].pageEmoticons[0]
    
    var repeatEmoji: MPEmoji?
    for emoji in recentPageEmoticons {
      //判断是否重复添加
      if (emoji.emoji != nil && emoji.code == emojiModel.code) || (emoji.png != nil && emoji.png == emojiModel.png) {
        repeatEmoji = emoji
        break
      }
    }
    //存在重复的表情
    if let rp = repeatEmoji {
      //去除之前的表情
      recentPageEmoticons.removeAtIndex(recentPageEmoticons.indexOf(rp)!)
    }
    //添加到数组中
    recentPageEmoticons.insert(emojiModel, atIndex: 0)
    //判断是否超过20
    if recentPageEmoticons.count > maxCountOfPage {
      recentPageEmoticons.removeLast()
    }

    emojiPackages[0].pageEmoticons[0] = recentPageEmoticons
    saveRecentPageEoticons()
  }
  
  ///加载"最近"表情数据
  private func loadRecentPageEoticons() -> [MPEmoji] {
    let recent = NSKeyedUnarchiver.unarchiveObjectWithFile(recentPath) as? [MPEmoji]
    let empty = [MPEmoji]()
    return recent ?? empty
  }
  
  ///保存"最近"表情数组
  private func saveRecentPageEoticons() {
    NSKeyedArchiver.archiveRootObject( emojiPackages[0].pageEmoticons[0], toFile: recentPath)
  }
  
  ///加载所有emoji表情包
  private func loadAllEmojiPackage() -> [MPEmojiPackage] {
    //最近
    let recentEmoticonPackage = MPEmojiPackage(id: "", group_name_cn: "最近", emoticons: loadRecentPageEoticons())
    // 默认
    let defaultEmoticonPackage = loadEmojiPackage("com.sina.default")
    // emoji
    let emojiEmoticonPackage = loadEmojiPackage("com.apple.emoji")
    // 浪小花
    let lxhEmoticonPackage = loadEmojiPackage("com.sina.lxh")
    
    return [recentEmoticonPackage, defaultEmoticonPackage, emojiEmoticonPackage, lxhEmoticonPackage]
  }
  
  /**
   加载一个表情包
   
   - parameter id: 表情包名称
   */
  private func loadEmojiPackage(id: String) -> MPEmojiPackage{
    //路径名： mainBundle路径 + 表情包名称 + info.plist
    let path = bundlePath! + "/" + id + "/" + "info.plist"
    //将plist加载成字典
    let dictionary = NSDictionary(contentsOfFile: path)
    //取出需要的属性
    let id = dictionary!["id"] as! String
    let group_name_cn = dictionary!["group_name_cn"] as! String
    let emoticons = dictionary!["emoticons"] as! [[String:String]]
    
    var emoticonsArray = [MPEmoji]()
    for dic in emoticons {
      let emoji = MPEmoji(id:id, dic: dic)
      emoticonsArray.append(emoji)
    }
    let package = MPEmojiPackage(id: id, group_name_cn: group_name_cn, emoticons: emoticonsArray)
    return package
  }
  
  
}
