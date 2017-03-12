//
//  MPComposeViewController.swift
//  MPWeibo
//
//  Created by Maple on 16/7/27.
//  Copyright © 2016年 Maple. All rights reserved.
//

import UIKit
import SVProgressHUD

class MPComposeViewController: UIViewController {
  
  ///微博最大文字限制
  let maxNumberOfStatus = 25
  ///记录是否显示添加图片
  var isShowing: Bool = false
  
  //MARK: View的声明周期
  override func viewDidLoad() {
      super.viewDidLoad()
    setupUI()
    setupNav()
    setupTitle()
    setupPicturePicker()
    setupToolbar()
    setupNumberLabel()
    //添加监听
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(textChange), name: UITextViewTextDidChangeNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardChange(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
  }
  
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    //如果没有显示添加图片，则弹出键盘
    if !isShowing {
      textView.becomeFirstResponder()
    }
  }

  // MARK: - 设置UI界面
  private func setupPicturePicker() {
    self.view.addSubview(picturePickerVC.view)
    self.addChildViewController(picturePickerVC)
    picturePickerVC.view.translatesAutoresizingMaskIntoConstraints = false
    
    let height = self.view.frame.height * 0.6
    picturePickerVC.view.snp_makeConstraints { (make) in
      make.leading.trailing.equalTo(self.view)
      make.bottom.equalTo(self.view).offset(height)
      make.height.equalTo(height)
    }
  }
  
  private func setupNumberLabel() {
    self.view.addSubview(numberLabel)
    
    numberLabel.snp_makeConstraints { (make) in
      make.trailing.equalTo(toolbar).offset(-3)
      make.bottom.equalTo(toolbar.snp_top).offset(-3)
    }
  }
  
  private func setupToolbar() {
    
    //添加控件
    self.view.addSubview(toolbar)
    
    //添加约束
    toolbar.snp_makeConstraints { (make) in
      make.leading.trailing.bottom.equalTo(self.view)
    }
    let itemSettings = [
      ["imageName": "compose_toolbar_picture", "action": "picture:"],
      ["imageName": "compose_trendbutton_background", "action": "trend:"],
      ["imageName": "compose_mentionbutton_background", "action": "mention:"],
      ["imageName": "compose_keyboardbutton_background", "action": "emoticon:"],
      ["imageName": "compose_add_background", "action": "add:"]
    ]
    toolbar.items = [UIBarButtonItem]()
    for dic in itemSettings {
      let action = dic["action"]!
      let item = UIBarButtonItem(imageName: dic["imageName"]!, target: self, action: Selector(action))
      toolbar.items?.append(item)
      //添加弹簧
      let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
      toolbar.items?.append(space)
    }
    //去掉最后一个弹簧
    toolbar.items?.removeLast()
  }
  
  private func setupUI() {
    self.view.backgroundColor = UIColor.whiteColor()
    self.view.addSubview(textView)
    
    textView.snp_makeConstraints { (make) in
      make.edges.equalTo(self.view)
    }
  }
  
  ///设置导航栏
  private func setupNav() {
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(cancle))
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发布", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(publish))
    //默认为不能点击状态
    self.navigationItem.rightBarButtonItem?.enabled = false
  }
  
  ///设置标题
  private func setupTitle() {
    //取出用户名，拼接要显示的标题
    let account = MPUserAccountViewModel.sharedUserAccountViewModel.userAccount
    let title = "发微博\n" + "\(account!.screen_name!)"
    
    //设置富文本属性
    let attrTitle = NSMutableAttributedString(string: title)
    let nsTitle = title as NSString
    let range = nsTitle.rangeOfString("\(account!.screen_name!)")
    attrTitle.addAttributes([NSForegroundColorAttributeName: UIColor.lightGrayColor(), NSFontAttributeName : UIFont.systemFontOfSize(12)], range: range)
    
    //创建label并设置属性
    let titleLabel = UILabel()
    titleLabel.font = UIFont.systemFontOfSize(14)
    titleLabel.attributedText = attrTitle
    titleLabel.textAlignment = NSTextAlignment.Center
    titleLabel.numberOfLines = 0
    titleLabel.sizeToFit()
    self.navigationItem.titleView = titleLabel
  }
  
  //MARK: - 私有方法
  @objc private func textChange() {
    self.navigationItem.rightBarButtonItem?.enabled = textView.hasText()
  }
  
  @objc private func keyboardChange(notification: NSNotification) {
    let userInfo = notification.userInfo!
    //键盘动画时间
    let duration: NSTimeInterval = userInfo[UIKeyboardAnimationDurationUserInfoKey]!.doubleValue
    //取出键盘最后的frame
    let endRect: CGRect = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue
    //计算偏移量
    let offY = -(UIScreen.height() - endRect.origin.y)
    //toolbar跟随键盘移动
    self.toolbar.snp_updateConstraints { (make) in
      make.bottom.equalTo(self.view).offset(offY)
    }
    UIView.animateWithDuration(duration) {
      self.view.layoutIfNeeded()
    }
  }
  
  //MARK: - 点击事件
  @objc private func picture(button: UIButton) {
    picturePickerVC.view.snp_updateConstraints { (make) in
      make.bottom.equalTo(self.view).offset(0)
    }
    UIView.animateWithDuration(0.25) { 
      self.view.layoutIfNeeded()
    }
    isShowing = true
    self.textView.resignFirstResponder()
  }
  @objc private func trend(button: UIButton) {
    print("#")
  }
  @objc private func mention(button: UIButton) {
    print("@")
  }
  @objc private func emoticon(button: UIButton) {
    textView.resignFirstResponder()
    
    // 如果是系统键盘就切换到自定义的键盘,如果是自定义的键盘就切换到系统键盘
    textView.inputView = textView.inputView == nil ? emoticonKeyboard : nil
    let image: UIImage
    let highlightedImage: UIImage
    if textView.inputView == nil {
      image = UIImage(named: "compose_emoticonbutton_background_highlighted")!
      highlightedImage = UIImage(named: "compose_emoticonbutton_background_highlighted")!
    }else {
      image = UIImage(named: "compose_keyboardbutton_background")!
      highlightedImage = UIImage(named: "compose_keyboardbutton_background_highlighted")!
    }
    button.setImage(image, forState: UIControlState.Normal)
    button.setImage(highlightedImage, forState: UIControlState.Highlighted)
    
    // 延迟0.25秒将键盘弹出来
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(250 * USEC_PER_SEC)), dispatch_get_main_queue()) { () -> Void in
      self.textView.becomeFirstResponder()
    }
  }
  @objc private func add(button: UIButton) {
    print("+")
  }
  ///点击了取消
  @objc private func cancle() {
    SVProgressHUD.dismiss()
    textView.resignFirstResponder()
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  ///点击了发布
  @objc private func publish() {
    //取出微博内容
    let status = self.textView.resultText()
    //取出微博图片
    let image = picturePickerVC.images.first
    
    //判断是否超出长度
    if status.characters.count > maxNumberOfStatus {
      SVProgressHUD.showErrorWithStatus("文字超过长度了...")
      return
    }
    
    // 没有超出长度, 发布微博
    SVProgressHUD.showWithStatus("正在发布微博...")

    MPStatusViewModel.sharedStatusViewModel.sendStatus(status, image:image) { (error) in
      if error != nil {
        print(error)
        SVProgressHUD.showErrorWithStatus("发布微博失败了")
        return
      }
      
      // 发布微博成功了
      SVProgressHUD.showSuccessWithStatus("发布微博成功了")
      // 延时关闭
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), { () -> Void in
        self.cancle()
      })
    }
  }
  
  //MARK: - 懒加载
  ///图片选择控制器
  private lazy var picturePickerVC: MPPicturePickerController = MPPicturePickerController()
  
  ///输入框
  private lazy var textView: MPPlaceholderTextView = {
    let tv = MPPlaceholderTextView()
    tv.placeholder = "请输入你想分享的内容"
    tv.alwaysBounceVertical = true
    tv.font = UIFont.systemFontOfSize(18)
    tv.keyboardDismissMode = .OnDrag
    tv.delegate = self
    return tv
  }()
  
  ///工具条
  private lazy var toolbar: UIToolbar = UIToolbar()
  
  ///表情键盘
  private lazy var emoticonKeyboard: MPEmojiKeyboardView = {
    let kv = MPEmojiKeyboardView()
    kv.textView = self.textView
    return kv
  }()
  
  ///剩余文字label
  private lazy var numberLabel: UILabel = {
    let label = UILabel()
    label.text = "\(self.maxNumberOfStatus)"
    label.font = UIFont.systemFontOfSize(11)
    label.textColor = UIColor.lightGrayColor()
    return label
  }()
}

extension MPComposeViewController: UITextViewDelegate {
  func textViewDidChange(textView: UITextView) {
    
    // 获得输入的长度
    let inputCount = textView.resultText().characters.count
    // 设置剩余的长度
    numberLabel.text = "\(maxNumberOfStatus - inputCount)"
    
    // 如果超出了长度,文字改为红色
    if inputCount > maxNumberOfStatus {
      numberLabel.textColor = UIColor.redColor()
    } else {
      numberLabel.textColor = UIColor.lightGrayColor()
    }

  }
}
