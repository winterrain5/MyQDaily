//
//  CustomPageView.swift
//  MyQDaily
//
//  Created by 石冬冬 on 17/1/21.
//  Copyright © 2017年 sdd. All rights reserved.
//

import UIKit

protocol CustomPageViewDelegate:NSObjectProtocol
{
    func didClickButtonAtIndex(index:NSInteger)
}

let KTopViewHeight:CGFloat = 64

class CustomPageView: UIView {
    
    // MARK: 内部属性和方法
    private var sliderView:UIView?
    private var buttonArray:[UIButton]?
    private var width:CGFloat?
    private var selectedButton:UIButton?
    private var bottomScrollView:UIScrollView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        buttonArray = [UIButton]()
        // 设置默认颜色
        normalTitleColor = UIColor.grayColor()
        selectedTitleColor = UIColor.blackColor()
        sliderBackgroundColor = UIColor.orangeColor()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    private func setSubViewWithArray() {
    
        for var i = 0; i < titleArray?.count; i++ {
            let title = titleArray![i]
            let btn = UIButton()
            btn.setTitle(title, forState: UIControlState.Normal)
            btn.setTitleColor(normalTitleColor, forState: UIControlState.Normal)
            btn.setTitleColor(selectedTitleColor, forState: .Selected)
            btn.titleLabel?.font = UIFont.systemFontOfSize(18)
            if i == 0 {
                btn.selected = true
                selectedButton = btn
            }
            btn.addTarget(self, action: Selector("subButtonSelected:"), forControlEvents: UIControlEvents.TouchUpInside)
            btn.tag = i
            addSubview(btn)
            buttonArray?.append(btn)
        }
        
        sliderView = UIView()
        sliderView?.backgroundColor = sliderBackgroundColor
        addSubview(sliderView!)
    
    }
    
    private func setBottomScrollView() {
        bottomScrollView = UIScrollView()
        let frame = CGRectMake(0, KTopViewHeight, SCREEN_WIDTH, SCREENH_HEIGHT - KTopViewHeight)
        bottomScrollView?.frame = frame
        addSubview(bottomScrollView!)
        
        for var i = 0; i < VCArray?.count; i++ {
            let vcFrame = CGRectMake(CGFloat(i) * SCREEN_WIDTH, 0, SCREEN_WIDTH, (bottomScrollView?.frame.size.height)!)
            let vc = VCArray![i] as! UIViewController
            vc.view.frame = vcFrame
            fatherVC?.addChildViewController(vc)
            bottomScrollView?.addSubview(vc.view)
        }
        
        bottomScrollView!.contentSize = CGSizeMake(CGFloat((VCArray?.count)!) * SCREEN_WIDTH, 0);
        
        bottomScrollView!.pagingEnabled = true;
        
        bottomScrollView!.showsHorizontalScrollIndicator = false;
        
        bottomScrollView!.showsVerticalScrollIndicator = false;
        
        bottomScrollView!.directionalLockEnabled = true;
        
        bottomScrollView!.bounces = false;
        
        bottomScrollView!.delegate = self;
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        width = SCREEN_WIDTH / CGFloat((buttonArray?.count)! * 3)
        let buttonWidth = SCREEN_WIDTH / CGFloat((buttonArray?.count)!)
        for var i = 0; i < buttonArray?.count; i++ {
            buttonArray![i].frame = CGRectMake(CGFloat(i) * buttonWidth, 15, buttonWidth, KTopViewHeight - 15)
        }
        let buttonx = buttonArray![0].center.x - width! / 2
        sliderView?.frame = CGRectMake(buttonx, KTopViewHeight - 3, width! - 4,3)
    }
    
    @objc private func subButtonSelected(sender:UIButton) {
        // 改变上一个选中的按钮选中状态
        selectedButton?.selected = false
        
        // 改变当前按钮的选中状态
        sender.selected = true
        
        // 重新赋值选中的按钮
        selectedButton = sender
        
        // 底部线条滑动动画
        sliderViewAnimationWithButtonIndex(sender.tag)
        
        // 代理事件
        if delegate?.respondsToSelector(Selector("didClickButtonAtIndex:")) != nil {
            delegate?.didClickButtonAtIndex(sender.tag)
        }
        bottomScrollView?.setContentOffset(CGPointMake(CGFloat(sender.tag) * SCREEN_WIDTH, 0), animated: true)

    }
    
    private func sliderViewAnimationWithButtonIndex(index:NSInteger) {
        UIView.animateWithDuration(0.25) { () -> Void in
            let buttonX = self.buttonArray![index].center.x - (self.width! / 2)
            var tempFrame = self.sliderView?.frame
            tempFrame?.origin.x = buttonX
            self.sliderView?.frame = tempFrame!
        }
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
    func scrollToIndex(index:NSInteger) {
        // 改变上一个选中的按钮选中状态
        selectedButton?.selected = false
        // 改变当前按钮的选中状态
        buttonArray![index].selected = true
        
        // 重新赋值选中的按钮
        selectedButton = buttonArray![index]
        sliderViewAnimationWithButtonIndex(index)
    }
}

extension CustomPageView:UIScrollViewDelegate
{
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / SCREEN_WIDTH)
        sliderViewAnimationWithButtonIndex(index)
    }
}