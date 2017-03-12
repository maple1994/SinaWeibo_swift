//
//  NSObject+Print.swift
//  emojiKeyboard
//
//  Created by Maple on 16/7/30.
//  Copyright © 2016年 Maple. All rights reserved.
//

import Foundation

extension NSObject {
  class func printIvar() {
    var count: UInt32 = 0
    let ivars = class_copyIvarList(self, &count)
    
    for i in 0 ..< Int(count) {
    let ivar = ivars[i]
      //UnsafePointer<Int8>
      //获得成员变量
      let cName = ivar_getName(ivar)
      let name = String(UTF8String: cName)
      //获得成员变量属性
      let cType = ivar_getTypeEncoding(ivar)
      let type = String(UTF8String: cType)
      print(type! + "--" + name!)
    }
  }
}