//
//  HomeTableViewController.swift
//  WeiBo
//
//  Created by 张树青 on 16/5/22.
//  Copyright © 2016年 zsq. All rights reserved.
//

import UIKit

class HomeTableViewController: BaseTableViewController {
    
    var isPresent: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1.如果没有登录, 就设置未登录界面的消息
        if !userLogin {
            visitorView?.setUpVisitorInfo(true, imageName: "visitordiscover_feed_image_house", message: "关注一些人，回这里看看有什么惊喜")
            return
        }
        
        //2.初始化导航条
        setupNav()
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
        btn.selected = !btn.selected;
        
        //2.弹出菜单
        let sd = UIStoryboard(name: "PopoverViewController", bundle: nil)
        let vc = sd.instantiateInitialViewController()
        //2.1设置转场代理
        //默认情况下modal 会移除以前控制器的view, 替换为当前弹出的view
        //如果自定义转场, 那么就不会移除以前控制器的view
        vc?.transitioningDelegate = self
        //2.2设置转场的样式
        vc?.modalPresentationStyle = UIModalPresentationStyle.Custom
        presentViewController(vc!, animated: true, completion: nil)
        
    }
    
}

extension HomeTableViewController: UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning{
    //实现代理方法, 告诉系统谁来负责转场动画
    //UIPresentationController iOS8推出的专门负责转场动画的
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        return PopoverPresentationController(presentedViewController: presented, presentingViewController: presenting)
    }
    
    
    //MARK 只要实现了一下方法, 那么系统自带的默认动画就没有了, "所有" 东西都需要程序员自己的来实现
    //告诉系统谁来负责modal的展现动画
    //presented 被展现动画
    //presenting 发起的视图
    //return 谁来负责
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = true
        return self
    }
    
    //告诉系统谁来负责modal的消失动画
    //dismiss 被关闭的视图
    //return 谁来负责
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = false
        return self
    }
    
    //MARK - UIViewControllerAnimatedTransitioning
    //返回动画时长
    //transitionContext 上下文, 里面保存了动画需要的所有参数
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval{
        return 0.5
    }
    
    //告诉系统如何进行动画, 无论是展现还是消失, 都会调用这个方法
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        if isPresent {
            //展开
            //1.拿到展现视图
            let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
            toView?.transform = CGAffineTransformMakeScale(1.0, 0.0)
            
            //注意: 一定要将视图添加到容器上
            transitionContext.containerView()?.addSubview(toView!)
            //设置锚点
            toView?.layer.anchorPoint = CGPointMake(0.5, 0)
            
            //2.执行动画
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                //2.1 清空transform
                toView?.transform = CGAffineTransformIdentity
                }) { (_) -> Void in
                    //2.2动画执行完毕一定要告诉系统, 否则会发生未知错误
                    transitionContext.completeTransition(true)
            }
        } else {
            //关闭
            let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
            //注意: 一定要将视图添加到容器上
            transitionContext.containerView()?.addSubview(fromView!)
            //设置锚点
            fromView?.layer.anchorPoint = CGPointMake(0.5, 0)
            
            //2.执行动画
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                //2.1 清空transform
                fromView?.transform = CGAffineTransformMakeScale(1.0, 0.000001)
                }) { (_) -> Void in
                    //2.2动画执行完毕一定要告诉系统, 否则会发生未知错误
                    transitionContext.completeTransition(true)
            }

        }
    }
}