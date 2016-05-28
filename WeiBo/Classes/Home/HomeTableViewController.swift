//
//  HomeTableViewController.swift
//  WeiBo
//
//  Created by 张树青 on 16/5/22.
//  Copyright © 2016年 zsq. All rights reserved.
//

import UIKit

class HomeTableViewController: BaseTableViewController {

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
        titleBtn.setTitle("即可江南", forState: UIControlState.Normal)
        
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
        btn.selected = !btn.selected;
    }
   
}
