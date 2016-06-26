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

    @IBOutlet weak var messageLb: UILabel!
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
        //output.rectOfInterest = CGRectMake(0, 0, 1, 1)

        //添加预览图层
        view.layer.insertSublayer(previewLayer, atIndex: 0)
        
        //添加绘制图层到预览图层上
        previewLayer.addSublayer(drawerLayer)
        
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
    
    //创建用于绘制边线的图层
    private lazy var drawerLayer: CALayer = {
        let layer = CALayer()
        layer.frame = UIScreen.mainScreen().bounds
        return layer
    }()
    
}

extension QRCodeViewController: AVCaptureMetadataOutputObjectsDelegate {
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        //1. 获取扫描到的数据
        print(metadataObjects.last?.stringValue)
        messageLb.text = metadataObjects.last?.stringValue
        
        //2. 获取扫描到的二维码的位置
        for obj in metadataObjects {
            //2.1 判断当前获取到的对象 是否是机器可识别的类型
            if obj is AVMetadataMachineReadableCodeObject {
                
                //2.2 将坐标转换成界面可识别的坐标
                let codeObject = previewLayer.transformedMetadataObjectForMetadataObject(obj as! AVMetadataObject) as! AVMetadataMachineReadableCodeObject
               drawLines(codeObject)
            }
        }
        
    }
    
    private func drawLines (obj: AVMetadataMachineReadableCodeObject) {
        if obj.corners.isEmpty {
            return
        }
        
        clearCorners()
        
        //1. 创建图层
        let layer = CAShapeLayer()
        layer.borderWidth = 4;
        layer.strokeColor = UIColor.redColor().CGColor
        layer.fillColor = UIColor.clearColor().CGColor
        
        //2. 创建路径
        let path = UIBezierPath()
        var point = CGPointZero
        var index: Int = 0
        //2.1移动到第一个点
        CGPointMakeWithDictionaryRepresentation((obj.corners[index++] as! CFDictionaryRef ), &point)
        path.moveToPoint(point)
        //2.2移动到其他点
        while index < obj.corners.count {
            CGPointMakeWithDictionaryRepresentation((obj.corners[index++] as! CFDictionaryRef) , &point)
            path.addLineToPoint(point)
        }
        //2.3 关闭路径
        path.closePath()
        
        //2.4 绘制路径
        layer.path = path.CGPath
        
        //3 添加到图层
        drawerLayer.addSublayer(layer)
    
    }
    
    private func clearCorners() {
        if drawerLayer.sublayers == nil || drawerLayer.sublayers?.count == 0 {
            return
        }
        for layer in drawerLayer.sublayers! {
            layer.removeFromSuperlayer()
        }
    }
}