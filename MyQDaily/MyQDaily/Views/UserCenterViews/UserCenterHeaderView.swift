//
//  userCenterHeaderView.swift
//  MyQDaily
//
//  Created by 石冬冬 on 17/1/24.
//  Copyright © 2017年 sdd. All rights reserved.
//

import UIKit
import QuartzCore
class UserCenterHeaderView: UIView {

    fileprivate var backgroundImageView:UIImageView?
    fileprivate var avatarImageView:UIImageView?
    fileprivate var desclael:UILabel?
    fileprivate var blurView:FXBlurView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUI() {
        
        backgroundImageView = UIImageView()
        addSubview(backgroundImageView!)
       
        backgroundImageView?.image = UIImage(named: "1")
        backgroundImageView?.contentMode = UIViewContentMode.scaleAspectFill
        
        
        blurView = FXBlurView()
        blurView?.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: KUserHeaderViewH)
        blurView?.blurRadius = 0
        backgroundImageView?.addSubview(blurView!)
       
    }
    
    func updateRadiousWithProgress(_ progress: CGFloat) {
        print(progress)
        if progress < 0 {
            return
        }
        blurView?.blurRadius = progress * 100
    }
   
}
