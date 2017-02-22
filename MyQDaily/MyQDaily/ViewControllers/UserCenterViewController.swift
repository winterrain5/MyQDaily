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
    fileprivate var customHeaderView:UserCenterHeaderView?
    fileprivate var customNavView:UserCenterNavView?
    fileprivate var tableView:UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupUI()
    }

    fileprivate func setupUI() {
        
        tableView = UITableView()
        tableView?.frame = view.bounds
        tableView?.dataSource = self
        tableView?.delegate = self
        view.addSubview(tableView!)
        
        customHeaderView = UserCenterHeaderView()
        tableView?.setParallaxHeader(customHeaderView!, mode: VGParallaxHeaderMode.topFill, height: KUserHeaderViewH)
        
        
        customNavView = UserCenterNavView.userCenterNavView()
        customNavView?.backgroundColor = UIColor.clear
        customNavView?.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 64)
        view.insertSubview(customNavView!, aboveSubview: tableView!)
        customNavView?.dismissBlock = { ()->() in
            
            self.dismiss(animated: true, completion: nil)
            
        }

        
    }

}

extension UserCenterViewController: UITableViewDataSource,UITableViewDelegate
{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tableView?.shouldPositionParallaxHeader()
        let progress = 1 - (tableView?.parallaxHeader.progress)!
        customNavView?.updateRadiousWithProgress(progress)
        customHeaderView?.updateRadiousWithProgress(progress)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rid = "centerCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: rid)
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: rid)
        }
        cell?.textLabel?.text = "第\(indexPath.row)个cell"
        return cell!
    }
}
