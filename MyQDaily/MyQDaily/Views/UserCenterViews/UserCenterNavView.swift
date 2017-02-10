//
//  UserCenterNavView.swift
//  MyQDaily
//
//  Created by 石冬冬 on 17/1/24.
//  Copyright © 2017年 sdd. All rights reserved.
//

import UIKit

class UserCenterNavView: UIView {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    class func userCenterNavView() -> UserCenterNavView {
        return NSBundle.mainBundle().loadNibNamed("UserCenterNavView", owner: nil, options: nil).last as! UserCenterNavView
    }
    
    func updateRadiousWithProgress(progress: CGFloat) {
        titleLabel.textColor = UIColor.init(white: (1-progress), alpha: 1)
        backButton.titleLabel?.textColor = UIColor.init(white: (1-progress), alpha: 1)
        if progress > 0.7 {
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.backgroundColor = UIColor.whiteColor()
            })
        }
        
        if progress < 0.7 && progress > 0 {
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.backgroundColor = UIColor.clearColor()
            })
        }
        
    }

    @IBAction func backBtnClick(sender: UIButton) {
        if dismissBlock != nil {
            dismissBlock!()
        }
    }
    
    typealias dismissControllerBlock = ()->()
    var dismissBlock:dismissControllerBlock?
}
