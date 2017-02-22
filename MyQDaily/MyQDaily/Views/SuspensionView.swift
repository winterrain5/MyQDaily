//
//  SuspensionView.swift
//  MyQDaily
//
//  Created by 石冬冬 on 17/1/18.
//  Copyright © 2017年 sdd. All rights reserved.
//

import UIKit
import pop
@objc protocol SuspensionViewDelegate:NSObjectProtocol
{
    @objc optional func popUpMenu()
    @objc optional func closeMenu()
    @objc optional func backHome()
    @objc optional func backToMenuView()
}

class SuspensionView: UIView {

    // 内部方法和属性
    
    fileprivate var suspensionButton:UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addButton(frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
         super.layoutSubviews()
        
        suspensionButton?.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        var  imageName = ""
        if style == .qDaily { // Qlogo样式
            imageName = "c_Qdaily button_54x54_"
        } else if style == .close{ // 关闭样式
            imageName = "c_close button_54x54_"
        } else if style == .navBack{ // 返回样式1
            imageName = "navigation_back_round_normal"
        } else if style == .homeBack{ // 返回样式2
            imageName = "homeBackButton"
        }

        suspensionButton?.setImage(UIImage(named: imageName), for: UIControlState())
    }
    
    func addButton(_ frame:CGRect) {
        suspensionButton = UIButton()
        
        suspensionButton?.addTarget(self, action: #selector(SuspensionView.clickSuspensionButton(_:)), for: UIControlEvents.touchUpInside)
        addSubview(suspensionButton!)
    }
    
    /*
    QDaily
    case Close
    case NavBack
    case HomeBack
    */
    
    @objc func clickSuspensionButton(_ sender:UIButton) {
        sender.isSelected = !sender.isSelected
        
        if style == .qDaily || style == .close {
            
            // 加判断,防止连击时出现界面逻辑交互混乱
            if 0 == sender.layer.frame.origin.y {
                UIView.animate(withDuration: 0.1, animations: { () -> Void in
                        self.suspensionButtonAnimationWithoffsetY(80)
                    }, completion: { (finished) -> Void in
                        
                        self.popAnimationWithOffset(-80, beginTime: 0)
                        
                        // 弹出菜单界面
                        if self.style == .qDaily {
                            self.suspensionButton!.setImage(UIImage(named: "c_close button_54x54_"), for: UIControlState())
                            // 重新设置按钮的tag
                            self.style = .close
                            
                            // 弹出菜单的代理
                            if (self.delegate?.responds(to: #selector(SuspensionViewDelegate.popUpMenu)) != nil) {
                                self.delegate?.popUpMenu!()
                            }
                            return
                            
                            //
                        }
                        
                        // 关闭菜单界面
                        if self.style == .close {
                            self.suspensionButton!.setImage(UIImage(named: "c_Qdaily button_54x54_"), for: UIControlState())
                            // 重新设置按钮的tag
                            self.style = .qDaily
                            // 关闭菜单代理
                            if (self.delegate?.responds(to: #selector(SuspensionViewDelegate.closeMenu)) != nil) {
                                self.delegate?.closeMenu!()
                            }
                            return
                        }
                })
            }
            
        }
        
        // 返回首页
        if style == .navBack {
            style = .qDaily
            if (self.delegate?.responds(to: #selector(SuspensionViewDelegate.backHome)) != nil) {
                self.delegate?.backHome!()
            }
            return
        }
        
        // 返回到MenuView
        if style == .homeBack{
            if (self.delegate?.responds(to: #selector(SuspensionViewDelegate.backToMenuView)) != nil) {
                self.delegate?.backToMenuView!()
            }
            return
        }
    }
    
    // pop动画
    fileprivate func popAnimationWithOffset(_ offset: CGFloat, beginTime: CGFloat) {
        let popSpring = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
        popSpring?.toValue = (self.suspensionButton?.center.y)! + offset
        popSpring?.beginTime = CACurrentMediaTime() + Double(beginTime)
        popSpring?.springBounciness = 10.0
        popSpring?.springSpeed = 18
        self.suspensionButton?.pop_add(popSpring, forKey: "positionY")
        
    }
    
    fileprivate func suspensionButtonAnimationWithoffsetY(_ offsetY: CGFloat) {
        var tempFrame = self.suspensionButton?.layer.frame
        tempFrame?.origin.y += offsetY
        self.suspensionButton?.layer.frame = tempFrame!
    }
    
    // MARK: -外部方法和属性
    weak var delegate:SuspensionViewDelegate?
    
    enum buttonStyle : Int {
        case qDaily = 1
        case close
        case navBack
        case homeBack
    }
    
    var style:buttonStyle = .qDaily
}
