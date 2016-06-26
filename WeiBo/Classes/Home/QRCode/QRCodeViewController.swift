//
//  QRCodeViewController.swift
//  WeiBo
//
//  Created by zsq on 16/5/29.
//  Copyright © 2016年 zsq. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeViewController: UIViewController , UITabBarDelegate{

    @IBOutlet weak var scanView: UIView!
    @IBOutlet weak var containerHeightCons: NSLayoutConstraint!
    @IBOutlet weak var top_constraint: NSLayoutConstraint!
    @IBOutlet weak var customTabBar: UITabBar!
    @IBAction func closeBtnClick(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        //设置底部视图默认选中第0个
        customTabBar.selectedItem = customTabBar.items![0]
        customTabBar.delegate = self
        scanView.layer.masksToBounds = true
    }

    override func viewDidAppear(animated: Bool) {
        startAnimation()
        startScan()
    }
    
    //开始动画
    private func startAnimation() {
        UIView.animateWithDuration(2) { () -> Void in
            self.top_constraint.constant = self.containerHeightCons.constant;
            UIView.setAnimationRepeatCount(MAXFLOAT)
            self.view.layoutIfNeeded()
        }

    }
    //开始扫描
    private func startScan() {
        //判断能否将输入对象加入session
        if !session.canAddInput(deviceInput) {
            return
        }
        
        //判断能否将输出对象加入session
        if !session.canAddOutput(output) {
            return
        }
        
        //将输入和输出都加入到会话中
        session.addInput(deviceInput)
        session.addOutput(output)
        
        //设置能够解析出的数据类型, 一定要在加入会话后在设置, 否则会报错
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        print(output.metadataObjectTypes)
        
        //设置输出对象 的代理
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())

        //添加预览图层
        view.layer.insertSublayer(previewLayer, atIndex: 0)
        
        session.startRunning()
    }
    
    //MARK: - TabBar Delegate
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem){
        if item.tag == 1000 {
            self.containerHeightCons.constant = 300.0
        } else {
            self.containerHeightCons.constant = 150.0
        }
        
        //移除动画
        self.scanView.layer.removeAllAnimations()
        //重新开始动画
        self.view.layoutIfNeeded()
        
    }
    
    //MARK: - 懒加载
    //会话
    private lazy var session: AVCaptureSession = AVCaptureSession()
    //拿到输入设备
    private lazy var deviceInput: AVCaptureDeviceInput? = {
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        do {
            let input = try AVCaptureDeviceInput(device: device)
            return input
        }catch {
            print(error)
            return nil
        }
    }()
    //拿到输出设备
    private lazy var output: AVCaptureMetadataOutput = AVCaptureMetadataOutput()
    
    //创建预览图层
    private lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer(session: self.session)
        layer.frame = UIScreen.mainScreen().bounds
        return layer
    }()
    
}

extension QRCodeViewController: AVCaptureMetadataOutputObjectsDelegate {
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        print(metadataObjects.last?.stringValue)
        
    }
}