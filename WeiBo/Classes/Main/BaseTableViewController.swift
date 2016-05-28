//
//  BaseTableViewController.swift
//  WeiBo
//
//  Created by zsq on 16/5/22.
//  Copyright © 2016年 zsq. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController , VisitorViewDelegate{

    //定义一个变量 保存用户是否登录
    var userLogin = true
    var visitorView: VisitorView?
    
    override func loadView() {
        
        userLogin ? super.loadView() : setupVisitorView()

    }
    
    //MARK - 内部控制方法
    //创建未登录界面
    private func  setupVisitorView() {
//        let customView = VisitorView()
//        customView.delegate = self
//        //        customView.backgroundColor = UIColor.redColor()
//        view = customView
//        visitorView = customView
        visitorView = VisitorView()
        visitorView?.delegate = self
        view = visitorView!
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.Plain, target: self, action: "registClick")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: UIBarButtonItemStyle.Plain, target: self, action: "loginClick")
    }
    
     func registClick() {
        print(__FUNCTION__)
    }
     func loginClick() {
        print(__FUNCTION__)
    }
    
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.Plain, target: self, action: "registerBtnWillClick")
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: UIBarButtonItemStyle.Plain, target: self, action: "loginBtnWillClick")
//        
//    }
//    
    // MARK: - VisitorViewDelegate
    func loginBtnWillClick() {
        print(__FUNCTION__)
    }
    func registerBtnWillClick() {
        print(__FUNCTION__)
    }

}
