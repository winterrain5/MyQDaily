//
//  UserCenterViewController.swift
//  MyQDaily
//
//  Created by 石冬冬 on 17/1/23.
//  Copyright © 2017年 sdd. All rights reserved.
//

import UIKit

let KUserHeaderViewH:CGFloat = 200
let KNavigationH:CGFloat = 108

class UserCenterViewController: UIViewController {

    // MARK：-内部属性和方法
    private var customHeaderView:UserCenterHeaderView?
    private var customNavView:UserCenterNavView?
    private var tableView:UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        setupUI()
    }

    private func setupUI() {
        
        tableView = UITableView()
        tableView?.frame = view.bounds
        tableView?.dataSource = self
        tableView?.delegate = self
        view.addSubview(tableView!)
        
        customHeaderView = UserCenterHeaderView()
        tableView?.setParallaxHeaderView(customHeaderView!, mode: VGParallaxHeaderMode.TopFill, height: KUserHeaderViewH)
        
        
        customNavView = UserCenterNavView.userCenterNavView()
        customNavView?.backgroundColor = UIColor.clearColor()
        customNavView?.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64)
        view.insertSubview(customNavView!, aboveSubview: tableView!)
        customNavView?.dismissBlock = { ()->() in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }

        
    }

}

extension UserCenterViewController: UITableViewDataSource,UITableViewDelegate
{
    func scrollViewDidScroll(scrollView: UIScrollView) {
        tableView?.shouldPositionParallaxHeader()
        let progress = 1 - (tableView?.parallaxHeader.progress)!
        customNavView?.updateRadiousWithProgress(progress)
        customHeaderView?.updateRadiousWithProgress(progress)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let rid = "centerCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(rid)
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: rid)
        }
        cell?.textLabel?.text = "第\(indexPath.row)个cell"
        return cell!
    }
}
