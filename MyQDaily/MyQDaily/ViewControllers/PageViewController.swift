//
//  PageViewController.swift
//  MyQDaily
//
//  Created by 石冬冬 on 17/1/21.
//  Copyright © 2017年 sdd. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {

    private var pageView:CustomPageView?
    
    private var suspensionView:SuspensionView?
    private var menuView:MenuView?
    
    private lazy var subViewControllers:NSMutableArray = {
        var array = NSMutableArray()
        let VC1 = HomeViewController()
        let VC2 = HomeLABSViewController()
        array.addObject(VC1)
        array.addObject(VC2)
        return array
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()
        let array:[String] = ["NEWS","LABS"]
        pageView = CustomPageView()
        pageView!.titleArray = array
        pageView?.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT)
        pageView?.VCArray = subViewControllers
        pageView?.fatherVC = self
        view.addSubview(pageView!)

        setupUI()
    }
    
    private func setupUI() {
        
        
        suspensionView = SuspensionView()
        suspensionView?.frame = CGRectMake(10, SCREENH_HEIGHT - 70, 54, 54)
        suspensionView?.delegate  = self
        suspensionView?.style = .QDaily
        
        menuView = MenuView()
        menuView?.cellBlock = {(methodName:String) -> Void
            in
            self.suspensionView?.style = .Close
            let method = NSSelectorFromString(methodName)
            self.performSelector(method)
            self.menuView?.removeFromSuperview()
        }
        menuView?.popupNewsClassificationViewBlock = {()->Void in
            self.suspensionView?.style = .HomeBack
            self.changgeSuspensionViewOffsetX(-SCREEN_WIDTH - 100)
            
        }
        menuView?.hideNewsClassificationViewBlock = {()-> Void in
            self.menuView?.hideNewsClassificationViewAnimation()
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.changgeSuspensionViewOffsetX(15)
                }, completion: { (_) -> Void in
                    UIView.animateWithDuration(0.15, animations: { () -> Void in
                            self.changgeSuspensionViewOffsetX(5)
                        }, completion: { (_) -> Void in
                            UIView.animateWithDuration(0.1, animations: { () -> Void in
                                self.changgeSuspensionViewOffsetX(10)
                            })
                    })
            })
            
        }
        menuView?.frame = view.bounds
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        automaticallyAdjustsScrollViewInsets = false
        let window = UIApplication.sharedApplication().keyWindow
        window!.addSubview(suspensionView!)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
        suspensionView?.removeFromSuperview()
    }
    
    // 改变悬浮按钮的x值
    private func changgeSuspensionViewOffsetX(offsetX: CGFloat) {
        var tempFrame = self.suspensionView?.frame
        tempFrame?.origin.x = offsetX
        self.suspensionView?.frame = tempFrame!
    }
    
    
    func aboutUs() {
        print("\(__FUNCTION__)")
    }
    
    func newsClassification() {
        print("\(__FUNCTION__)")

    }
    
    func paogramaCenter() {
        print("\(__FUNCTION__)")

    }
    
    func curiosityResearch() {
        print("\(__FUNCTION__)")

    }
    
    func myMessage() {
        print("\(__FUNCTION__)")

    }
    
    func userCenter() {
        print("\(__FUNCTION__)")

    }
    
    func homePage() {
        print("\(__FUNCTION__)")

    }
}

extension PageViewController:SuspensionViewDelegate
{
    // MARK: SuspensionViewDelegate
    func popUpMenu() {
        let window = UIApplication.sharedApplication().keyWindow
        window!.insertSubview(menuView!, belowSubview:suspensionView!)
        menuView?.popupMunuViewAnimation()
    }
    func closeMenu() {
        menuView?.hideMenuViewAnimation()
    }
    func backToMenuView() {
        suspensionView?.style = .QDaily
        menuView?.hideMenuViewAnimation()
        
    }
   
}

