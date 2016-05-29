//
//  PopoverAnimator.swift
//  WeiBo
//
//  Created by zsq on 16/5/29.
//  Copyright © 2016年 zsq. All rights reserved.
//

import UIKit

let ZSQPopoverAnimationWillShow = "ZSQPopoverAnimationWillShow"
let ZSQPopoverAnimationWillDismiss = "ZSQPopoverAnimationWillDismiss"

class PopoverAnimator: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning{
    var isPresent: Bool = false
    //定义属性, 保存菜单大小
    var presentFrame = CGRectZero
    
    //实现代理方法, 告诉系统谁来负责转场动画
    //UIPresentationController iOS8推出的专门负责转场动画的
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        let pc = PopoverPresentationController(presentedViewController: presented, presentingViewController: presenting)
        
        pc.presentFrame = presentFrame
        return pc
    }
    
    
    //MARK 只要实现了一下方法, 那么系统自带的默认动画就没有了, "所有" 东西都需要程序员自己的来实现
    //告诉系统谁来负责modal的展现动画
    //presented 被展现动画
    //presenting 发起的视图
    //return 谁来负责
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = true
        
        //发送通知, 即将展开
        NSNotificationCenter.defaultCenter().postNotificationName(ZSQPopoverAnimationWillShow, object: self)
        
        return self
    }
    
    //告诉系统谁来负责modal的消失动画
    //dismiss 被关闭的视图
    //return 谁来负责
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = false
        NSNotificationCenter.defaultCenter().postNotificationName(ZSQPopoverAnimationWillDismiss, object: self)
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
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
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
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
                //2.1 清空transform
                fromView?.transform = CGAffineTransformMakeScale(1.0, 0.000001)
                }) { (_) -> Void in
                    //2.2动画执行完毕一定要告诉系统, 否则会发生未知错误
                    transitionContext.completeTransition(true)
            }
            
        }
    }
}