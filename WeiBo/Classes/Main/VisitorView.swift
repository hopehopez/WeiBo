//
//  VisitorView.swift
//  WeiBo
//
//  Created by zsq on 16/5/22.
//  Copyright © 2016年 zsq. All rights reserved.
//

import UIKit

// Swift中如何定义协议: 必须遵守NSObjectProtocol
protocol VisitorViewDelegate: NSObjectProtocol{
    // 登录回调
    func loginBtnWillClick()
    // 注册回调
    func registerBtnWillClick()
}

class VisitorView: UIView {
    
    // 定义一个属性保存代理对象
    // 一定要加上weak, 避免循环引用
    weak var delegate: VisitorViewDelegate?
    
    func setUpVisitorInfo(isHome: Bool, imageName: String, message: String) {
        //不是首页就隐藏转盘
        iconView.hidden = !isHome
        homeIcon.image = UIImage(named: imageName)
        messageLabel.text = message
        
        if isHome {
            startAnimation()
        }
    }
    func loginBtnClick(){
        //        print(__FUNCTION__)
        delegate?.loginBtnWillClick()
    }
    func registerBtnClick(){
        //        print(__FUNCTION__)
        delegate?.registerBtnWillClick()
    }

    
    private func startAnimation() {
        //1.创建动画
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        //2.设置动画属性
        animation.toValue = 2 * M_PI
        animation.duration = 20
        animation.repeatCount = MAXFLOAT
        //动画执行完后是否移除
        animation.removedOnCompletion = false
        
        //3.将动画添加到图层上
        iconView.layer.addAnimation(animation, forKey: nil)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //1.添加子控件
        addSubview(iconView)
        addSubview(maskBGView)
        addSubview(homeIcon)
        addSubview(messageLabel)
        addSubview(loginButton)
        addSubview(registerButton)
        //2.布局子控件
        //2.1 设置背景
        iconView.xmg_AlignInner(type: XMG_AlignType.Center, referView: self, size: nil)
        //2.2设置小房子
        homeIcon.xmg_AlignInner(type: XMG_AlignType.Center, referView: self, size: nil)
        //2.3设置文本
        messageLabel.xmg_AlignVertical(type: XMG_AlignType.BottomCenter, referView: homeIcon, size: nil)
         //"哪个控件" 的 "什么属性" "等于" "另外一个控件" 的 "什么属性" 乘以"多少" 加上"多少"
        addConstraint(NSLayoutConstraint(item: messageLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 224))
        //2.4设置按钮
        registerButton.xmg_AlignVertical(type: XMG_AlignType.BottomLeft, referView: messageLabel, size: CGSizeMake(100, 30), offset: CGPointMake(0, 20))
        loginButton.xmg_AlignVertical(type: XMG_AlignType.BottomRight, referView: messageLabel, size: CGSizeMake(100, 30), offset: CGPointMake(0, 20))
        
        //2.5设置蒙版
        maskBGView.xmg_Fill(self)
    }
    
    //Swift推荐我们自定义一个控件, 要么用控件, 要么就用xib.storyboard
    required init?(coder aDecoder: NSCoder) {
        //如果通过xib.storyboard创建该类, 那么就会崩溃
        fatalError("init(coder) has not been implemented")
    }
    
    //MARK: - 懒加载控件
    ///转盘
    private lazy var iconView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
        return iv
    }()
    ///图标
    private lazy var homeIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
        return iv
    }()
    ///文本
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "jjjj"
        label.numberOfLines = 0
label.textColor = UIColor.darkGrayColor()
        return label
    }()
    //登录按钮
    private lazy var loginButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("登录", forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        btn.addTarget(self, action: "loginBtnClick", forControlEvents:UIControlEvents.TouchUpInside)
        return btn
    }()
    //注册按钮
    private lazy var registerButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("注册", forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        btn.addTarget(self, action: "registerBtnClick", forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    
    private lazy var maskBGView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
        return iv
    }()
    
}
