//
//  PageViewController.swift
//  MyQDaily
//
//  Created by 石冬冬 on 17/1/21.
//  Copyright © 2017年 sdd. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {

    fileprivate var pageView:CustomPageView?
    
    fileprivate var suspensionView:SuspensionView?
    fileprivate var menuView:MenuView?
    
    fileprivate lazy var subViewControllers:NSMutableArray = {
        var array = NSMutableArray()
        let VC1 = HomeViewController()
        let VC2 = HomeLABSViewController()
        array.add(VC1)
        array.add(VC2)
        return array
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        let array:[String] = ["NEWS","LABS"]
        pageView = CustomPageView()
        pageView!.titleArray = array
        pageView?.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREENH_HEIGHT)
        pageView?.VCArray = subViewControllers
        pageView?.fatherVC = self
        view.addSubview(pageView!)

        setupUI()
    }
    
    fileprivate func setupUI() {
        
        
        suspensionView = SuspensionView()
        suspensionView?.frame = CGRect(x: 10, y: SCREENH_HEIGHT - 70, width: 54, height: 54)
        suspensionView?.delegate  = self
        suspensionView?.style = .qDaily
        
        menuView = MenuView()
        menuView?.cellBlock = {(methodName:String) -> Void
            in
            self.suspensionView?.style = .close
            let method = NSSelectorFromString(methodName)
            self.perform(method)
            self.menuView?.removeFromSuperview()
        }
        menuView?.popupNewsClassificationViewBlock = {()->Void in
            self.suspensionView?.style = .homeBack
            self.changgeSuspensionViewOffsetX(-SCREEN_WIDTH - 100)
            
        }
        menuView?.hideNewsClassificationViewBlock = {()-> Void in
            self.menuView?.hideNewsClassificationViewAnimation()
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    self.changgeSuspensionViewOffsetX(15)
                }, completion: { (_) -> Void in
                    UIView.animate(withDuration: 0.15, animations: { () -> Void in
                            self.changgeSuspensionViewOffsetX(5)
                        }, completion: { (_) -> Void in
                            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                                self.changgeSuspensionViewOffsetX(10)
                            })
                    })
            })
            
        }
        menuView?.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        automaticallyAdjustsScrollViewInsets = false
        let window = UIApplication.shared.keyWindow
        window!.addSubview(suspensionView!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        suspensionView?.removeFromSuperview()
    }
    
    // 改变悬浮按钮的x值
    fileprivate func changgeSuspensionViewOffsetX(_ offsetX: CGFloat) {
        var tempFrame = self.suspensionView?.frame
        tempFrame?.origin.x = offsetX
        self.suspensionView?.frame = tempFrame!
    }
    
    
    func aboutUs() {
        print("\(#function)")
    }
    
    func newsClassification() {
        print("\(#function)")

    }
    
    func paogramaCenter() {
        print("\(#function)")

    }
    
    func curiosityResearch() {
        print("\(#function)")

    }
    
    func myMessage() {
        print("\(#function)")

    }
    
    func userCenter() {
        let vc = UserCenterViewController()
       
        present(vc, animated: true, completion: nil)
        
        menuView?.hideMenuViewAnimation()
        print("\(#function)")

    }
    
    func homePage() {
        print("\(#function)")

    }
}

extension PageViewController:SuspensionViewDelegate
{
    // MARK: SuspensionViewDelegate
    func popUpMenu() {
        let window = UIApplication.shared.keyWindow
        window!.insertSubview(menuView!, belowSubview:suspensionView!)
        menuView?.popupMunuViewAnimation()
    }
    func closeMenu() {
        menuView?.hideMenuViewAnimation()
    }
    func backToMenuView() {
        suspensionView?.style = .qDaily
        menuView?.hideMenuViewAnimation()
        
    }
   
}

