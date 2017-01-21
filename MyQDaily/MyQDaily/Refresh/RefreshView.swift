//
//  RefreshView.swift
//  MyQDaily
//
//  Created by 石冬冬 on 17/1/21.
//  Copyright © 2017年 sdd. All rights reserved.
//

import UIKit

class RefreshView: UIRefreshControl {
    
    private var refreshBackView:CustomRefreshBackView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        refreshBackView = CustomRefreshBackView()
        addSubview(refreshBackView!)
        refreshBackView?.frame = CGRectMake(0, 0, SCREEN_WIDTH, 188)
        
        // 监听refreshController的frame的改变
        addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions.New, context: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeObserver(self, forKeyPath: "frame")
    }
    
    var loadingFlag = false
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if frame.origin.y == 0  || frame.origin.y == -64 {
            return
        }
        
        // 是否触发下拉刷新事件
        if refreshing && !loadingFlag {
            loadingFlag = true
            refreshBackView?.startLoadingView()
            return
        }
        
    }
    override func endRefreshing() {
        super.endRefreshing()
        loadingFlag = false
        refreshBackView?.stopLoadingView()
    }
}


class CustomRefreshBackView:UIView {
    
    var backImageView:UIImageView?
    var loadingImageView:UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        backImageView = UIImageView()
        backImageView?.frame = CGRectMake(0, 0, SCREEN_WIDTH, 188)
        backImageView?.image = UIImage(named: "reveal_refresh_foreground")
        addSubview(backImageView!)
        
        loadingImageView = UIImageView()
        loadingImageView?.image = UIImage(named: "reveal_refresh_sun")
        loadingImageView?.frame = CGRectMake(0.3 * SCREEN_WIDTH, 30, 20, 20)
        addSubview(loadingImageView!)
    }
    
    // 外部方法
    
    // 开始动画
    func startLoadingView() {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.toValue = 2 * M_PI
        animation.duration = 0.5
        animation.repeatCount = MAXFLOAT
        loadingImageView?.layer.addAnimation(animation, forKey: nil)
    }
    
    // 结束动画
    func stopLoadingView() {
        loadingImageView?.layer.removeAllAnimations()
    }
    
}