//
//  MBProgressHUD+Extension.swift
//  MyQDaily
//
//  Created by 石冬冬 on 17/1/18.
//  Copyright © 2017年 sdd. All rights reserved.
//

import Foundation
import MBProgressHUD

extension MBProgressHUD {
    
    class func promptHudWithShowHUDAddedTo(promptView:UIView,message:String) {
        var hud = MBProgressHUD()
        hud = MBProgressHUD.showHUDAddedTo(promptView, animated: true)
        hud.mode = MBProgressHUDMode.Text
        hud.bezelView.backgroundColor = UIColor.blackColor()
        hud.contentColor = UIColor.whiteColor()
        hud.animationType = MBProgressHUDAnimation.Zoom
        hud.label.text = message
        hud.hideAnimated(true , afterDelay: 1.2)
    }
    
    class func showLoadView(view:UIView,str:String) {
        var hud = MBProgressHUD()
        hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.mode = MBProgressHUDMode.Indeterminate
        hud.bezelView.backgroundColor = UIColor.blackColor()
        hud.contentColor = UIColor.whiteColor()
        hud.animationType = MBProgressHUDAnimation.Zoom
       
    }
    
    
}
