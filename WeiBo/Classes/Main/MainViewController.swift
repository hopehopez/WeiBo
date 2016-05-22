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
        
        
        addChildViewController(HomeTableViewController(),title: "首页", imageName: "tabbar_home")
        addChildViewController(MessageTableViewController(), title: "消息", imageName:  "tabbar_message_center")
        addChildViewController(DiscoverTableViewController(), title: "发现", imageName: "tabbar_discover")
        addChildViewController(ProfileTableViewController(), title: "我的", imageName: "tabbar_profile")
        
    }
    
    //初始化子控制器
    private func addChildViewController(childController: UIViewController, title:String, imageName:String) {
        
        //1.1设置首页tabbar对应的数据
        childController.tabBarItem.image = UIImage(named: imageName)
        childController.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
        childController.tabBarItem.title = title
        
        //1.2设置导航条对应的数据
        //home.navigationItem.title = "首页"
        childController.title = title
        
        //2.给首页包装一个导航控制器
        let nav = UINavigationController()
        nav.addChildViewController(childController)
        
        //3.
        addChildViewController(nav)
    }
   
}
