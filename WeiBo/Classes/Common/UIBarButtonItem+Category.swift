//
//  UIBarButtonItem+Category.swift
//  WeiBo
//
//  Created by zsq on 16/5/28.
//  Copyright © 2016年 zsq. All rights reserved.
//

import UIKit
extension UIBarButtonItem {
    //如果在func前面加上class , 就相当于OC中的+  类方法
    class func createBarButtonItem(imageName: String, target: AnyObject?, action: Selector) -> UIBarButtonItem{
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), forState: UIControlState.Highlighted)
        btn.sizeToFit()
        btn .addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        return UIBarButtonItem(customView: btn)
    }
}
