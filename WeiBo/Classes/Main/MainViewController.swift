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
        
        addChildViewControllers()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //添加加号按钮
        setupComposeBtn()
    }
    
    //监听按钮的点击
    //注意: 监听按钮点击的方法不能是私有方法
    //按钮点击事件的调用是由 运行循环 监听并以消息机制传递的, 因此, 监听函数不能设置为private
    func composeBtnClick() {
        print(__FUNCTION__)
    }
    
    private func setupComposeBtn() {
        //1.添加加号按钮
        tabBar.addSubview(composeBtn)
        
        //2.调整加号的位置
        let width = UIScreen.mainScreen().bounds.size.width / CGFloat( viewControllers!.count)
        let rect = CGRect(x: 0, y: 0, width: width, height: 49)
        composeBtn.frame = rect
        composeBtn.frame = CGRectOffset(rect, 2 * width, 0)
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
    
    //添加所有自控制器
    private func addChildViewControllers() {
        //1.获取json文件路径
        let path = NSBundle.mainBundle().pathForResource("MainVCSettings.json", ofType: nil)
        //2.通过文件路径创建NSData
        if let jsonPath = path {
            let jsonData = NSData(contentsOfFile: jsonPath)
            //3.序列化json数据 -> Array
            do {
                //有可能发生异常的代码
                //try: 发生异常会跳到catch中继续执行
                //try!: 发生异常程序直接崩溃
                let dictArr = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers)
                //4.遍历数组, 动态创建控制器和设置数据
                //在Swift中, 如果要遍历一个数组, 必须明确数据的类型
                for dict in dictArr as! [[String: String]] {
                    //报错的原因是因为addChildViewController参数必须有值, 但是字典的返回值是可选类型
                    addChildViewController(dict["vcName"]!, title: dict["title"]!, imageName: dict["imageName"]!)
                }
            } catch {
                //发生异常后执行
                print(error)
                
                //从本地加载
                addChildViewController("HomeTableViewController",title: "首页", imageName: "tabbar_home")
                addChildViewController("MessageTableViewController", title: "消息", imageName:  "tabbar_message_center")
                addChildViewController("DiscoverTableViewController", title: "发现", imageName: "tabbar_discover")
                addChildViewController("ProfileTableViewController", title: "我的", imageName: "tabbar_profile")
            }
            
        }
        
        
    }
    
    //MARk 懒加载
    lazy var composeBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "tabbar_compose_icon_add"), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), forState: UIControlState.Highlighted)
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
        
        //添加监听
        btn.addTarget(self, action: "composeBtnClick", forControlEvents: UIControlEvents.TouchUpInside)
        
        return btn
    }()
}