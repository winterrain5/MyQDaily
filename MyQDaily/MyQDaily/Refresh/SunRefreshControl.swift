//
//  SunRefreshControl.swift
//  MyQDaily
//
//  Created by 石冬冬 on 17/1/23.
//  Copyright © 2017年 sdd. All rights reserved.
//

import UIKit

class SunRefreshControl: UIControl {
    
    // MARK：-内部属性和方法
    
    
    class func refreshControl() -> SunRefreshControl {
        return NSBundle.mainBundle().loadNibNamed("SunRefreshControl", owner: nil, options: nil).last as! SunRefreshControl
    }
   

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: -外部方法
    // 添加scrollView
    func attachToScrollView(scrollView:UIScrollView) {
        
    }
    // 开始刷新
    func beginRefreshing() {
        
    }
    // 结束刷新
    func endRefreshing() {
        
    }
    
}
