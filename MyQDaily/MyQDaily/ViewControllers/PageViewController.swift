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

        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        automaticallyAdjustsScrollViewInsets = false
    }
    
    
}


