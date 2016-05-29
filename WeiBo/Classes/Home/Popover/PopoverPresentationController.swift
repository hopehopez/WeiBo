//
//  PopoverPresentationController.swift
//  WeiBo
//
//  Created by zsq on 16/5/28.
//  Copyright © 2016年 zsq. All rights reserved.
//

import UIKit

class PopoverPresentationController: UIPresentationController {
    //定义属性, 保存菜单大小
    var presentFrame = CGRectZero
    
    //初始化方法, 用于创建负责转场动画的对象
    //参数一: 被展现的控制器
    //参数二: 发起的控制器, Xcode6是nil , XCode7是野指针
    //return: 负责转场动画的对象
    override init(presentedViewController: UIViewController, presentingViewController: UIViewController) {
        
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
        
        //print(presentedViewController)
        //print(presentingViewController)
    }
    
    //即将布局转场子视图时调用
    override func containerViewWillLayoutSubviews() {
        //1.修改弹出视图的大小
        //containerView 容器视图
        //presentView() 被展现的view
        if presentFrame == CGRectZero {
            presentedView()?.frame = CGRectMake(100, 56, 200, 200)
        } else {
            presentedView()?.frame = presentFrame
        }
        
        //2.在容器视图上添加蒙版, 插入到展现视图的下面
        //因为展现视图和蒙版都在一个视图上, 而后添加的会盖住先添加的
        containerView?.insertSubview(cover, atIndex: 0)
    }
    //MARK - 懒加载
    private lazy var cover: UIView = {
        //创建view
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.2)
        view.frame = UIScreen.mainScreen().bounds
        
        //添加手势
        let tap = UITapGestureRecognizer(target: self, action: "close")
        view.addGestureRecognizer(tap)
        
        return view
    }()
    
    func close() {
        presentedViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}
