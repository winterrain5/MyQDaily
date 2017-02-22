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
    
    class func promptHudWithShowHUDAddedTo(_ promptView:UIView,message:String) {
        var hud = MBProgressHUD()
        hud = MBProgressHUD.showAdded(to: promptView, animated: true)
        hud.mode = MBProgressHUDMode.text
        hud.bezelView.backgroundColor = UIColor.black
        hud.contentColor = UIColor.white
        hud.animationType = MBProgressHUDAnimation.zoom
        hud.label.text = message
        hud.hide(animated: true , afterDelay: 1.2)
    }
    
    class func showLoadView(_ view:UIView,str:String) {
        var hud = MBProgressHUD()
        hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.bezelView.backgroundColor = UIColor.black
        hud.contentColor = UIColor.white
        hud.animationType = MBProgressHUDAnimation.zoom
       
    }
    
    
}
