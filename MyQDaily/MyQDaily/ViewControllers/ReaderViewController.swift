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
    
    // 帧动画视图
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        automaticallyAdjustsScrollViewInsets = false
    }
    
    fileprivate func setupUI() {
        
        view.backgroundColor = UIColor.white
        let readerWebView = UIWebView()
        readerWebView.frame = self.view.bounds
        readerWebView.delegate = self
        readerWebView.scrollView.delegate = self
    
        guard let tempUrl = newsUrl else{
            MBProgressHUD.promptHudWithShowHUDAddedTo(self.view, message: "未抓取到URL")
            navigationController?.popViewController(animated: true)
            return
        }
        let requset = URLRequest(url: URL(string: tempUrl)!)
        
        readerWebView.loadRequest(requset)
        view.addSubview(readerWebView)
        
        
        loadingView.backgroundColor = UIColor.white
        view.addSubview(loadingView)
        loadImageView.frame = CGRect(x: (SCREEN_WIDTH - 100) / 2, y: (SCREENH_HEIGHT - 100) / 2, width: 100, height: 100)
        loadingView.addSubview(loadImageView)

        footerView.frame = CGRect(x: 0, y: SCREENH_HEIGHT - 50, width: SCREEN_WIDTH, height: 50)
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
                footerView.backgroundColor = UIColor.clear
                footerView.footerType = 1
            } else { // tableView来的
                footerView.backgroundColor = UIColor.white
                footerView.footerType = 2
            }
        }
    }
    
}

extension ReaderViewController:UINavigationControllerDelegate,UIScrollViewDelegate,UIWebViewDelegate,ReaderFooterViewDelegate
{
    
    // MARK: -UIWebViewDelegate
    func webViewDidStartLoad(_ webView: UIWebView) {
        loadImageView.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        // 渐隐加载动画
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.loadingView.alpha = 0
            }, completion: { (_) -> Void in
                self.loadImageView.stopAnimating()
                self.loadingView.removeFromSuperview()
                
        }) 
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        loadImageView.stopAnimating()
        MBProgressHUD.promptHudWithShowHUDAddedTo(self.view, message: "加载失败")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { () -> Void in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        return true
    }
    
    
    // MARK: -UIScrollViewDelegate
    // 滚动时
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if readerViewType == 1 {
            if scrollView.contentOffset.y == 0 {
                footerView.footerType = 1
                self.footerView.backgroundColor = UIColor.clear
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
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        contentOffSetY = scrollView.contentOffset.y
    }
    
    
    // 显示底部视图
    fileprivate func showFooterView() {
        if footerView.layer.frame.origin.y == SCREENH_HEIGHT - 50{
            return
        }
        footerView.footerType = 2
        footerView.backgroundColor = UIColor.white
        footerView.alpha = 0.9
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            var tempFrame = self.footerView.layer.frame
            tempFrame.origin.y -= 50
            self.footerView.layer.frame = tempFrame
        })
    }
    
    // 隐藏底部视图
    fileprivate func hideFooterView() {
        if footerView.layer.frame.origin.y == SCREENH_HEIGHT {
            return
        }
        
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            var tempFrame = self.footerView.layer.frame
            tempFrame.origin.y += 50
            self.footerView.layer.frame = tempFrame
        })
        
    }
    
    // MARK: -ReaderFooterViewDelegate
    func backbtnClick(_ view: ReaderFooterView) {
        navigationController?.popViewController(animated: true)
    }

    func shareBtnClick(_ view: ReaderFooterView) {
        let image = UIImage(named: "2")
        
        shareWithImage(self, image: image!)
    }
}
