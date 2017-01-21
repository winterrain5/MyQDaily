//
//  SuspensionView.swift
//  MyQDaily
//
//  Created by 石冬冬 on 17/1/18.
//  Copyright © 2017年 sdd. All rights reserved.
//

import UIKit
import pop
protocol SuspensionViewDelegate:NSObjectProtocol
{
    func popUpMenu()
    func closeMenu()
    func backHome()
    func backToMenuView()
}

class SuspensionView: UIView {

    // 内部方法和属性
    
    private var suspensionButton:UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addButton(frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
         super.layoutSubviews()
        
        suspensionButton?.frame = CGRectMake(0, 0, frame.size.width, frame.size.height)
        var  imageName = ""
        if style == .QDaily { // Qlogo样式
            imageName = "c_Qdaily button_54x54_"
        } else if style == .Close{ // 关闭样式
            imageName = "c_close button_54x54_"
        } else if style == .NavBack{ // 返回样式1
            imageName = "navigation_back_round_normal"
        } else if style == .HomeBack{ // 返回样式2
            imageName = "homeBackButton"
        }

        suspensionButton?.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
    }
    
    func addButton(frame:CGRect) {
        suspensionButton = UIButton()
        
        suspensionButton?.addTarget(self, action: Selector("clickSuspensionButton:"), forControlEvents: UIControlEvents.TouchUpInside)
        addSubview(suspensionButton!)
    }
    
    /*
    QDaily
    case Close
    case NavBack
    case HomeBack
    */
    
    @objc func clickSuspensionButton(sender:UIButton) {
        sender.selected = !sender.selected
        
        if style == .QDaily || style == .Close {
            
            // 加判断,防止连击时出现界面逻辑交互混乱
            if 0 == sender.layer.frame.origin.y {
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                        self.suspensionButtonAnimationWithoffsetY(80)
                    }, completion: { (finished) -> Void in
                        
                        self.popAnimationWithOffset(-80, beginTime: 0)
                        
                        // 弹出菜单界面
                        if self.style == .QDaily {
                            self.suspensionButton!.setImage(UIImage(named: "c_close button_54x54_"), forState: UIControlState.Normal)
                            // 重新设置按钮的tag
                            self.style = .Close
                            
                            // 弹出菜单的代理
                            if (self.delegate?.respondsToSelector(Selector("popUpMenu")) != nil) {
                                self.delegate?.popUpMenu()
                            }
                            return
                            
                            //
                        }
                        
                        // 关闭菜单界面
                        if self.style == .Close {
                            self.suspensionButton!.setImage(UIImage(named: "c_Qdaily button_54x54_"), forState: UIControlState.Normal)
                            // 重新设置按钮的tag
                            self.style = .QDaily
                            // 关闭菜单代理
                            if (self.delegate?.respondsToSelector(Selector("closeMenu")) != nil) {
                                self.delegate?.closeMenu()
                            }
                            return
                        }
                })
            }
            
        }
        
        // 返回首页
        if style == .NavBack {
            style = .QDaily
            if (self.delegate?.respondsToSelector(Selector("backHome")) != nil) {
                self.delegate?.backHome()
            }
            return
        }
        
        // 返回到MenuView
        if style == .HomeBack{
            if (self.delegate?.respondsToSelector(Selector("backToMenuView")) != nil) {
                self.delegate?.backToMenuView()
            }
            return
        }
    }
    
    // pop动画
    private func popAnimationWithOffset(offset: CGFloat, beginTime: CGFloat) {
        let popSpring = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
        popSpring.toValue = (self.suspensionButton?.center.y)! + offset
        popSpring.beginTime = CACurrentMediaTime() + Double(beginTime)
        popSpring.springBounciness = 10.0
        popSpring.springSpeed = 18
        self.suspensionButton?.pop_addAnimation(popSpring, forKey: "positionY")
        
    }
    
    private func suspensionButtonAnimationWithoffsetY(offsetY: CGFloat) {
        var tempFrame = self.suspensionButton?.layer.frame
        tempFrame?.origin.y += offsetY
        self.suspensionButton?.layer.frame = tempFrame!
    }
    
    // MARK: -外部方法和属性
    weak var delegate:SuspensionViewDelegate?
    
    enum buttonStyle : Int {
        case QDaily = 1
        case Close
        case NavBack
        case HomeBack
    }
    
    var style:buttonStyle = .QDaily
}
