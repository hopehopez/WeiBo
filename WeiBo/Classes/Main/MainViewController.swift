//
//  MainViewController.swift
//  WeiBo
//
//  Created by 张树青 on 16/5/22.
//  Copyright © 2016年 zsq. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //设置当前控制器对应的tabbar的颜色
        //注意: 如果iOS7以前如果设置了tintcolor只有文字会变, 而图片不会变
        tabBar.tintColor = UIColor.orangeColor()
        
        
        addChildViewController("HomeTableViewController",title: "首页", imageName: "tabbar_home")
        addChildViewController("MessageTableViewController", title: "消息", imageName:  "tabbar_message_center")
        addChildViewController("DiscoverTableViewController", title: "发现", imageName: "tabbar_discover")
        addChildViewController("ProfileTableViewController", title: "我的", imageName: "tabbar_profile")
        
    }
    
    //初始化子控制器
    private func addChildViewController(childControllerName: String, title:String, imageName:String) {
        
        //1.动态获取命名空间
        let ns = NSBundle.mainBundle().infoDictionary!["CFBundleExecutable"] as! String

        
        //0.将字符串转换为类
        //0.1命名空间默认情况下就是项目名称 , 但是命名空间名称是可以修改的
        let cls:AnyClass? = NSClassFromString(ns + "." + childControllerName)
        //0.2通过类创建对象
        //0.2.1将AnyClass转换为指定的类型
        let vcCls = cls as! UIViewController.Type
        //0.2.2通过class创建对象
        let vc = vcCls.init()
        
        
        
        //1.1设置首页tabbar对应的数据
        vc.tabBarItem.image = UIImage(named: imageName)
        vc.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
        vc.tabBarItem.title = title
        
        //1.2设置导航条对应的数据
        //home.navigationItem.title = "首页"
        vc.title = title
        
        //2.给首页包装一个导航控制器
        let nav = UINavigationController()
        nav.addChildViewController(vc)
    
        addChildViewController(nav)
    }
   
}
