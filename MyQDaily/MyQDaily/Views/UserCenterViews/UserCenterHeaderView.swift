//
//  userCenterHeaderView.swift
//  MyQDaily
//
//  Created by 石冬冬 on 17/1/24.
//  Copyright © 2017年 sdd. All rights reserved.
//

import UIKit
import SnapKit
import QuartzCore
class UserCenterHeaderView: UIView {

    private var backgroundImageView:UIImageView?
    private var avatarImageView:UIImageView?
    private var desclael:UILabel?
    private var blurView:FXBlurView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        backgroundImageView = UIImageView()
        addSubview(backgroundImageView!)
        backgroundImageView?.snp_makeConstraints(closure: { (make) -> Void in
            make.left.equalTo(self.snp_left)
            make.right.equalTo(self.snp_right)
            make.top.equalTo(self.snp_top)
            make.bottom.equalTo(self.snp_bottom)
        })
        backgroundImageView?.image = UIImage(named: "1")
        backgroundImageView?.contentMode = UIViewContentMode.ScaleAspectFill
        
        
        blurView = FXBlurView()
        blurView?.frame = CGRectMake(0, 0, SCREEN_WIDTH, KUserHeaderViewH)
        blurView?.blurRadius = 0
        backgroundImageView?.addSubview(blurView!)
        blurView?.snp_makeConstraints(closure: { (make) -> Void in
            make.left.equalTo(self.snp_left)
            make.right.equalTo(self.snp_right)
            make.top.equalTo(self.snp_top)
            make.bottom.equalTo(self.snp_bottom)
        })
    }
    
    func updateRadiousWithProgress(progress: CGFloat) {
        print(progress)
        if progress < 0 {
            return
        }
        blurView?.blurRadius = progress * 100
    }
   
}
