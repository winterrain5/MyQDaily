//
//  RefreshView.swift
//  MyQDaily
//
//  Created by 石冬冬 on 17/1/21.
//  Copyright © 2017年 sdd. All rights reserved.
//

import UIKit
import SnapKit

class RefreshControlView: UIRefreshControl {
    
    private var refreshBackView:CustomRefreshBackView?
    
    override init() {
        super.init()
        
        backgroundColor = UIColor.clearColor()
        tintColor = UIColor.clearColor()
        
        
        refreshBackView = CustomRefreshBackView()
        addSubview(refreshBackView!)
        refreshBackView?.snp_makeConstraints(closure: { (make) -> Void in
            make.bottom.equalTo(self.snp_bottom)
            make.size.equalTo(CGSizeMake(SCREEN_WIDTH,80))
        })
        
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
//        if frame.origin.y == 0  || frame.origin.y == -64 {
//            return
//        }
        
        
        // 是否触发下拉刷新事件 向下拖拽松手时 触发下拉刷新事件
        if refreshing && !loadingFlag{
            loadingFlag = true
            let newRect = change!["new"]
            print("newRect = \(newRect),refreshing = \(refreshing)")
            
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
         addSubview(backImageView!)
        backImageView?.snp_makeConstraints(closure: { (make) -> Void in
            make.left.equalTo(self.snp_left).offset(60)
            make.right.equalTo(self.snp_right).offset(-60)
            make.bottom.equalTo(self.snp_bottom)
            make.height.equalTo(80)
        })
        backImageView?.image = UIImage(named: "reveal_refresh_foreground")
       
        
        loadingImageView = UIImageView()
        loadingImageView?.image = UIImage(named: "reveal_refresh_sun")
        loadingImageView?.frame = CGRectMake(0.3 * SCREEN_WIDTH, 20, 20, 20)
        addSubview(loadingImageView!)
    }
    
    // 外部方法
    
    // 开始动画
    func startLoadingView() {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.toValue = 2 * M_PI
        animation.duration = 0.6
        animation.repeatCount = MAXFLOAT
        loadingImageView?.layer.addAnimation(animation, forKey: nil)
    }
    
    // 结束动画
    func stopLoadingView() {
        loadingImageView?.layer.removeAllAnimations()
    }
    
}