//
//  TextView+Emoticon.swift
//  emojiKeyboard
//
//  Created by Maple on 16/7/30.
//  Copyright © 2016年 Maple. All rights reserved.
//

import UIKit

extension UITextView{
  ///返回网络传输的字符串
  func resultText() -> String {
    //拼接字符串
    var resultString = ""
    self.attributedText.enumerateAttributesInRange(NSMakeRange(0, self.attributedText.length), options: NSAttributedStringEnumerationOptions(rawValue:0)) { (dictionary, range, _) in
      //如果字典中包含“NSAttachment”这个key，则表明图片表情
      if let attach = dictionary["NSAttachment"]{
        //取出附件
        let newAttach = attach as! MPTextAttachment
        resultString += newAttach.chs!
      }else {
        //取出其他文字
        let otherString = self.attributedText.string as NSString
        let subString = otherString.substringWithRange(range)
        resultString += subString
      }
    }
    return resultString
  }
  
  ///插入表情
  func insert(emojiModel: MPEmoji) {
    //插入emoji表情
    if let emoji = emojiModel.emoji {
      self.insertText(emoji)
    }
    
    let attrM = emojiModel.emojiModelToAttrString(self.font!)
      
    //拿到当前文本
    let currentText = self.attributedText
    //变为可变
    let currentTextM = NSMutableAttributedString(attributedString: currentText!)
    //拿到当前光标的范围
    let currentRange = self.selectedRange
    //替换
    currentTextM.replaceCharactersInRange(NSMakeRange(currentRange.location, 0), withAttributedString: attrM!)
    self.attributedText = currentTextM
    
    // 重新设置光标位置
    self.selectedRange = NSMakeRange(currentRange.location + 1, 0)

    //发送通知
    NSNotificationCenter.defaultCenter().postNotificationName(UITextViewTextDidChangeNotification, object: self)
    //调用代理方法
    delegate?.textViewDidChange!(self)
  }
}
