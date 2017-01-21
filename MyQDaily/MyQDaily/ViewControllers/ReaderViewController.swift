//
//  ReaderViewController.swift
//  MyQDaily
//
//  Created by 石冬冬 on 17/1/19.
//  Copyright © 2017年 sdd. All rights reserved.
//

import UIKit
import Foundation
import WebKit
import MBProgressHUD

class ReaderViewController: UIViewController {
    // MARK: -内部属性
    /**WKWebView滑动后的Y轴偏移量*/
    var contentOffSetY:CGFloat?
    /**加载的动画View*/
    var loadingView:UIView = {
        let v = UIView()
        return v
    }()
    /**底部视图*/
    var footerView:ReaderFooterView = {
    
        let v = ReaderFooterView()
        return v
        
    }()
    
    var loadImageView:UIImageView = {
    
        let imageV = UIImageView()
        var imageArray:[UIImage] = []
        for index in 0...92 {
            let imageName = "QDArticleLoading_0\(index)"
            let image = UIImage(named: imageName)
            imageArray.append(image!)
        }
        
        imageV.animationImages = imageArray
        imageV.animationDuration = 3.0
        imageV.animationRepeatCount = 0
        
        return imageV
    }()

    // MARK: -生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        automaticallyAdjustsScrollViewInsets = false
    }
    
    private func setupUI() {
        
        view.backgroundColor = UIColor.whiteColor()
        let readerWebView = UIWebView()
        readerWebView.frame = self.view.bounds
        readerWebView.delegate = self
        readerWebView.scrollView.delegate = self
    
        guard let tempUrl = newsUrl else{
            MBProgressHUD.promptHudWithShowHUDAddedTo(self.view, message: "未抓取到URL")
            navigationController?.popViewControllerAnimated(true)
            return
        }
        let requset = NSURLRequest(URL: NSURL(string: tempUrl)!)
        
        readerWebView.loadRequest(requset)
        view.addSubview(readerWebView)
        
        
        loadingView.backgroundColor = UIColor.whiteColor()
        view.addSubview(loadingView)
        loadImageView.frame = CGRectMake((SCREEN_WIDTH - 100) / 2, (SCREENH_HEIGHT - 100) / 2, 100, 100)
        loadingView.addSubview(loadImageView)

        footerView.frame = CGRectMake(0, SCREENH_HEIGHT - 50, SCREEN_WIDTH, 50)
        footerView.delegate = self
        view.insertSubview(footerView, aboveSubview: readerWebView)
        
        
    }
    
    deinit {
        contentOffSetY = 0.0
    }
    
    // MARK: -外部属性
    var newsUrl:String?
    var readerViewType:NSInteger? {
        didSet {
            if readerViewType == 1 { // 轮播图来的
                footerView.backgroundColor = UIColor.clearColor()
                footerView.footerType = 1
            } else { // tableView来的
                footerView.backgroundColor = UIColor.whiteColor()
                footerView.footerType = 2
            }
        }
    }
    
}

extension ReaderViewController:UINavigationControllerDelegate,UIScrollViewDelegate,UIWebViewDelegate,ReaderFooterViewDelegate
{
    
    // MARK: -UIWebViewDelegate
    func webViewDidStartLoad(webView: UIWebView) {
        loadImageView.startAnimating()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        // 渐隐加载动画
        UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.loadingView.alpha = 0
            }) { (_) -> Void in
                self.loadImageView.stopAnimating()
                self.loadingView.removeFromSuperview()
                
        }
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        loadImageView.stopAnimating()
        MBProgressHUD.promptHudWithShowHUDAddedTo(self.view, message: "加载失败")
        dispatch_after(2, dispatch_get_main_queue()) { () -> Void in
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        return true
    }
    
    
    // MARK: -UIScrollViewDelegate
    // 滚动时
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if readerViewType == 1 {
            if scrollView.contentOffset.y == 0 {
                footerView.footerType = 1
                self.footerView.backgroundColor = UIColor.clearColor()
            }
        }
       
        if let offsetY = contentOffSetY {
            if scrollView.contentOffset.y > offsetY{
                hideFooterView()
            } else if scrollView.contentOffset.y < offsetY {
                showFooterView()
            }
        }
        
        
    }
    
    
    // 停止滚动时
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        contentOffSetY = scrollView.contentOffset.y
    }
    
    
    // 显示底部视图
    private func showFooterView() {
        if footerView.layer.frame.origin.y == SCREENH_HEIGHT - 50{
            return
        }
        footerView.footerType = 2
        footerView.backgroundColor = UIColor.whiteColor()
        footerView.alpha = 0.9
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            var tempFrame = self.footerView.layer.frame
            tempFrame.origin.y -= 50
            self.footerView.layer.frame = tempFrame
        })
    }
    
    // 隐藏底部视图
    private func hideFooterView() {
        if footerView.layer.frame.origin.y == SCREENH_HEIGHT {
            return
        }
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            var tempFrame = self.footerView.layer.frame
            tempFrame.origin.y += 50
            self.footerView.layer.frame = tempFrame
        })
        
    }
    
    // MARK: -ReaderFooterViewDelegate
    func backbtnClick(view: ReaderFooterView) {
        navigationController?.popViewControllerAnimated(true)
    }

    func shareBtnClick(view: ReaderFooterView) {
        let image = UIImage(named: "2")
        
        shareWithImage(self, image: image!)
    }
}
