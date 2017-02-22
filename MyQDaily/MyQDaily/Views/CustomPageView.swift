//
//  CustomPageView.swift
//  MyQDaily
//
//  Created by 石冬冬 on 17/1/21.
//  Copyright © 2017年 sdd. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


protocol CustomPageViewDelegate:NSObjectProtocol
{
   func didClickButtonAtIndex(_ index:NSInteger)
}

let KTopViewHeight:CGFloat = 64

class CustomPageView: UIView {
    
    // MARK: 内部属性和方法
    fileprivate var sliderView:UIView?
    fileprivate var buttonArray:[UIButton]?
    fileprivate var width:CGFloat?
    fileprivate var selectedButton:UIButton?
    fileprivate var bottomScrollView:UIScrollView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        buttonArray = [UIButton]()
        // 设置默认颜色
        normalTitleColor = UIColor.gray
        selectedTitleColor = UIColor.black
        sliderBackgroundColor = UIColor.orange
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    fileprivate func setSubViewWithArray() {
    
        for (index,element) in (titleArray?.enumerated())! {
            let title = element
            let btn = UIButton()
            btn.setTitle(title, for: UIControlState())
            btn.setTitleColor(normalTitleColor, for: UIControlState())
            btn.setTitleColor(selectedTitleColor, for: .selected)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
            if index == 0 {
                btn.isSelected = true
                selectedButton = btn
            }
            btn.addTarget(self, action: #selector(CustomPageView.subButtonSelected(_:)), for: UIControlEvents.touchUpInside)
            btn.tag = index
            addSubview(btn)
            buttonArray?.append(btn)
        }
       
        
        sliderView = UIView()
        sliderView?.backgroundColor = sliderBackgroundColor
        addSubview(sliderView!)
    
    }
    
    fileprivate func setBottomScrollView() {
        bottomScrollView = UIScrollView()
        let frame = CGRect(x: 0, y: KTopViewHeight, width: SCREEN_WIDTH, height: SCREENH_HEIGHT - KTopViewHeight)
        bottomScrollView?.frame = frame
        addSubview(bottomScrollView!)
        for (i,element) in (VCArray?.enumerated())! {
            let vcFrame = CGRect(x: CGFloat(i) * SCREEN_WIDTH, y: 0, width: SCREEN_WIDTH, height: (bottomScrollView?.frame.size.height)!)
            let vc = element as! UIViewController
            vc.view.frame = vcFrame
            fatherVC?.addChildViewController(vc)
            bottomScrollView?.addSubview(vc.view)
        }
       
        
        bottomScrollView!.contentSize = CGSize(width: CGFloat((VCArray?.count)!) * SCREEN_WIDTH, height: 0);
        
        bottomScrollView!.isPagingEnabled = true;
        
        bottomScrollView!.showsHorizontalScrollIndicator = false;
        
        bottomScrollView!.showsVerticalScrollIndicator = false;
        
        bottomScrollView!.isDirectionalLockEnabled = true;
        
        bottomScrollView!.bounces = false;
        
        bottomScrollView!.delegate = self;
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        width = SCREEN_WIDTH / CGFloat((buttonArray?.count)! * 3)
        let buttonWidth = SCREEN_WIDTH / CGFloat((buttonArray?.count)!)
        for (i, element) in (buttonArray?.enumerated())! {
            
            element.frame = CGRect(x: CGFloat(i) * buttonWidth, y: 15, width: buttonWidth, height: KTopViewHeight - 15)
        }
       
        let buttonx = buttonArray![0].center.x - width! / 2
        sliderView?.frame = CGRect(x: buttonx, y: KTopViewHeight - 3, width: width! - 4,height: 3)
    }
    
    @objc fileprivate func subButtonSelected(_ sender:UIButton) {
        // 改变上一个选中的按钮选中状态
        selectedButton?.isSelected = false
        
        // 改变当前按钮的选中状态
        sender.isSelected = true
        
        // 重新赋值选中的按钮
        selectedButton = sender
        
        // 底部线条滑动动画
        sliderViewAnimationWithButtonIndex(sender.tag)
        
        // 代理事件
        
        delegate?.didClickButtonAtIndex(sender.tag)
       
        bottomScrollView?.setContentOffset(CGPoint(x: CGFloat(sender.tag) * SCREEN_WIDTH, y: 0), animated: true)

    }
    
    fileprivate func sliderViewAnimationWithButtonIndex(_ index:NSInteger) {
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            let buttonX = self.buttonArray![index].center.x - (self.width! / 2)
            var tempFrame = self.sliderView?.frame
            tempFrame?.origin.x = buttonX
            self.sliderView?.frame = tempFrame!
        }) 
    }
    
    // 外部方法和属性
    
    /**底部线条颜色*/
    var sliderBackgroundColor:UIColor?
    /**未选中标题颜色*/
    var normalTitleColor:UIColor?
    /**选中标题颜色*/
    var selectedTitleColor:UIColor?
    /**标题数组*/
    var titleArray:[String]? {
        didSet {
            setSubViewWithArray()
        }
    }
    /**控制器数组*/
    var VCArray:NSMutableArray? {
        didSet {
            setBottomScrollView()
        }
    }
    weak  var delegate:CustomPageViewDelegate?
    var fatherVC:UIViewController? {
        didSet {
            bottomScrollView?.removeFromSuperview()
            setBottomScrollView()
        }
    }
    func scrollToIndex(_ index:NSInteger) {
        // 改变上一个选中的按钮选中状态
        selectedButton?.isSelected = false
        // 改变当前按钮的选中状态
        buttonArray![index].isSelected = true
        
        // 重新赋值选中的按钮
        selectedButton = buttonArray![index]
        sliderViewAnimationWithButtonIndex(index)
    }
}

extension CustomPageView:UIScrollViewDelegate
{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / SCREEN_WIDTH)
        sliderViewAnimationWithButtonIndex(index)
    }
}
