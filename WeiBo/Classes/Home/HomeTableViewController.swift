//
//  HomeTableViewController.swift
//  WeiBo
//
//  Created by 张树青 on 16/5/22.
//  Copyright © 2016年 zsq. All rights reserved.
//

import UIKit

class HomeTableViewController: BaseTableViewController {
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1.如果没有登录, 就设置未登录界面的消息
        if !userLogin {
            visitorView?.setUpVisitorInfo(true, imageName: "visitordiscover_feed_image_house", message: "关注一些人，回这里看看有什么惊喜")
            return
        }
        
        //2.初始化导航条
        setupNav()
        
        //3.添加通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "change", name: ZSQPopoverAnimationWillShow, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "change", name: ZSQPopoverAnimationWillDismiss, object: nil)
    }
    deinit {
        //移除通知
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    func change() {
        let titleBtn = navigationItem.titleView as! TitleButton
        titleBtn.selected = !titleBtn.selected
    }
    
    private func setupNav() {
        //1. 初始化左右按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem.createBarButtonItem("navigationbar_friendattention", target: self, action: "leftItemClick")
        navigationItem.rightBarButtonItem = UIBarButtonItem.createBarButtonItem("navigationbar_pop", target: self, action: "rightItemClick")
        
        //2.初始化标题按钮
        let titleBtn = TitleButton()
        titleBtn.setTitle("极客江南 ", forState: UIControlState.Normal)
        
        titleBtn.addTarget(self, action: "titleBtnClick:", forControlEvents: UIControlEvents.TouchUpInside)
        
        navigationItem.titleView = titleBtn
    }
    
    func leftItemClick() {
        print("点了左边的")
    }
    func rightItemClick() {
        print("点了右边的")
    }
    func titleBtnClick(btn: UIButton) {
        //1.修改箭头方向
        //btn.selected = !btn.selected;
        
        //2.弹出菜单
        let sb = UIStoryboard(name: "PopoverViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController()
        //2.1设置转场代理
        //默认情况下modal 会移除以前控制器的view, 替换为当前弹出的view
        //如果自定义转场, 那么就不会移除以前控制器的view
        //vc?.transitioningDelegate = self
        
        vc?.transitioningDelegate = popoverAnimator
        
        //2.2设置转场的样式
        vc?.modalPresentationStyle = UIModalPresentationStyle.Custom
        presentViewController(vc!, animated: true, completion: nil)
        
    }
    
    //MARK: - 懒加载
    //一定要定义一个属性, 来保存自定义转场对象, 否则会报错
    private lazy var popoverAnimator: PopoverAnimator = {
        let pa = PopoverAnimator()
        pa.presentFrame = CGRect(x: 100, y: 56, width: 200, height: 350)
        return pa
    }()
    
}

