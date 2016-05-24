//
//  BaseTableViewController.swift
//  WeiBo
//
//  Created by zsq on 16/5/22.
//  Copyright © 2016年 zsq. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {

    //定义一个变量 保存用户是否登录
    var userLogin = false
    
    override func loadView() {
        
        userLogin ? super.loadView() : setupVisitorView()

    }
    
    //MARK - 内部控制方法
    //创建未登录界面
    private func  setupVisitorView() {
        let customView = VisitorView()
        //customView.backgroundColor = UIColor.redColor()
        view = customView
    }
}
