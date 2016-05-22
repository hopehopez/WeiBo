//
//  AppDelegate.swift
//  WeiBo
//
//  Created by 张树青 on 16/5/22.
//  Copyright © 2016年 zsq. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        //创建view
        window = UIWindow(frame:UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        
        //创建跟控制器
        window?.rootViewController = MainViewController()
        window?.makeKeyAndVisible()
        
        return true
    }

    
}

