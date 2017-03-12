//
//  MPEmoji.swift
//  emojiKeyboard
//
//  Created by Maple on 16/7/29.
//  Copyright © 2016年 Maple. All rights reserved.
//

import UIKit

class MPEmoji: NSObject, NSCoding {
  ///表情文件夹名
  var id: String
  ///表情名称
  var chs: String?
  ///表情图片名
  var png: String?{
    didSet {
      fullPathPng = MPEmojiManager.sharedManager.bundlePath! + "/" + id + "/" + png!
    }
  }
  ///emoji表情16进制
  var code: String?{
    didSet{
      let scanner = NSScanner(string: code!)
      var result: UInt32 = 0
      scanner.scanHexInt(&result)
      emoji = "\(Character(UnicodeScalar(result)))"
    }
  }
  ///emoji表情
  var emoji: String?
  ///图片全路径
  var fullPathPng: String?
  
  class func stringToEmoticonString(text: String, font: UIFont) -> NSAttributedString? {
    //匹配方案
    let pattern = "\\[.*?\\]"
    // 定义属性字符串
    let emoticonString = NSMutableAttributedString(string: text)
    do{
      //创建正则表达式对象
      let regular = try NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.DotMatchesLineSeparators)
      
      //匹配所有符合条件的内容
      let results = regular.matchesInString(text, options: NSMatchingOptions(rawValue: 0), range: NSRange(location: 0, length: text.characters.count))
      
      for result in results.reverse() {
        let range = result.rangeAtIndex(0)
        //取出表情对应的名称
        let nsStr = text as NSString
        let chs = nsStr.substringWithRange(range)
        //字符串转表情模型
        let emojiModel = MPEmoji.emoticonNameToEmoticonModel(chs)
        if let emoji = emojiModel {
          let attr = emoji.emojiModelToAttrString(font)
          emoticonString.replaceCharactersInRange(range, withAttributedString: attr!)
        }
      }
      
    }catch let error as NSError {
      print(error)
    }
    return emoticonString
  }
  
  /**
   返回带图片的属性文本
   
   - parameter font: 字体
   
   - returns: 属性文本
   */
  func emojiModelToAttrString(font: UIFont) -> NSAttributedString? {
    var attrM = NSMutableAttributedString()
    if let fullPath = self.fullPathPng {
      //创建附件
      let attach = MPTextAttachment()
      //添加图片
      attach.image = UIImage(named: fullPath)
      attach.chs = self.chs
      //设置bounds，要注意的是bounds的y和frame的y是相反的
      let imageWH = font.lineHeight ?? 20
      attach.bounds = CGRect(x: 0, y: -5, width: imageWH, height: imageWH)
      
      let attr = NSAttributedString(attachment: attach)
      //添加font属性，若不添加，连续输入两个图片表情后，大小会变化
      attrM = NSMutableAttributedString(attributedString: attr)
      attrM.addAttribute(NSFontAttributeName, value: font, range: NSRange(location: 0, length: attr.length))
    }
    return attrM
  }
  
  /**
   根据表情名字，返回对应的模型
   
   - parameter name: 表情名字
   
   - returns: 表情模型
   */
  class func emoticonNameToEmoticonModel(name: String) -> MPEmoji? {
    for package in MPEmojiManager.sharedManager.emojiPackages {
      for emojiModel in package.emoticons {
        if emojiModel.chs == name {
          return emojiModel
        }
      }
    }
    return nil
  }

  
  init(id: String, dic: [String: String]) {
    self.id = id
    super.init()
    setValuesForKeysWithDictionary(dic)
  }
  
  override func setValue(value: AnyObject?, forUndefinedKey key: String) {
  }
  
  /// 打印对象
  override var description: String {
    return "\n\t\t: 表情模型:chs:\(chs), png:\(png), code:\(code)"
  }
  
  ///解档
  required init?(coder aDecoder: NSCoder) {
    self.id = aDecoder.decodeObjectForKey("id") as! String
    self.chs = aDecoder.decodeObjectForKey("chs") as? String
    self.png = aDecoder.decodeObjectForKey("png") as? String
    self.code = aDecoder.decodeObjectForKey("code") as? String
    self.emoji = aDecoder.decodeObjectForKey("emoji") as?  String
    //由于沙盒路径每次都会改变，所以在这里拼接一个新的fullPath
    if let png = self.png {
      self.fullPathPng = MPEmojiManager.sharedManager.bundlePath! + "/" + self.id + "/" + png
    }
  }
  
  ///归档
  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(id, forKey: "id")
    aCoder.encodeObject(chs, forKey: "chs")
    aCoder.encodeObject(png, forKey: "png")
    aCoder.encodeObject(code, forKey: "code")
    aCoder.encodeObject(emoji, forKey: "emoji")
  }

}
