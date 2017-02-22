//
//  NewsClassificationView.swift
//  MyQDaily
//
//  Created by 石冬冬 on 17/1/20.
//  Copyright © 2017年 sdd. All rights reserved.
//

import UIKit
import pop

class NewsClassificationView: UIView {
    
    let rid = "classificationCell"
    // 新闻分类菜单
    fileprivate var tableView:UITableView?
    // 悬浮按钮
    fileprivate var suspensionView:SuspensionView?
    
    //
    fileprivate var titleArray:[String] = {
        let array =  ["皇家马德里",
            "阿森纳",
            "曼联",
            "巴萨罗那",
            "多特蒙德",
            "马德里竞技",
            "曼城"]
        return array
    }()
    /**菜单cell图片数组*/
    fileprivate var imageArray:[String] = {
        let array = ["menu_about",
            "menu_category",
            "menu_column",
            "menu_lab",
            "menu_noti",
            "menu_user",
            "menu_home"]
        return array
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    fileprivate func setupUI() {
        
        
        tableView = UITableView()
        tableView?.frame = CGRect(x: 0, y: 0,width: SCREEN_WIDTH , height: SCREENH_HEIGHT - KHeaderViewH)
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: rid)
        tableView?.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView?.backgroundColor = UIColor.clear
        tableView?.dataSource = self
        tableView?.delegate = self
        addSubview(tableView!)
        
        suspensionView = SuspensionView()
        suspensionView?.frame = CGRect(x: SCREEN_WIDTH, y: SCREENH_HEIGHT - KHeaderViewH - 70, width: 54, height: 54)
        suspensionView?.style = .homeBack
        suspensionView?.delegate = self
        insertSubview(suspensionView!, aboveSubview: tableView!)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: 外部方法
    
    typealias newsClassificationViewBlock = () -> Void
    
    var backBlock:newsClassificationViewBlock?
    
    func popAnimationWithView(_ view:UIView, offset:CGFloat, speed:CGFloat) {
        let popSpring = POPSpringAnimation(propertyNamed:kPOPLayerPositionX)
        popSpring?.toValue = view.center.x + offset;
        popSpring?.beginTime = CACurrentMediaTime() + 0.2;
        popSpring?.springBounciness = 8.0;
        popSpring?.springSpeed = speed;
        view.pop_add(popSpring, forKey: "positionX")
    }
    
    func popupSuspensionView() {
        
        popAnimationWithView(suspensionView!, offset: -SCREEN_WIDTH + 10, speed: 20)
        
    }
    func hideSuspensionView() {
        UIView.animate(withDuration: 0.15, animations: { () -> Void in
            var tempFrame = self.suspensionView?.frame
            tempFrame?.origin.x  = SCREEN_WIDTH
            self.suspensionView?.frame = tempFrame!
        }) 
    }
}

extension NewsClassificationView:SuspensionViewDelegate,UITableViewDataSource,UITableViewDelegate
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (titleArray.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: rid)
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: rid)
        }
        cell?.textLabel?.text = titleArray[indexPath.row]
        let imageStr = imageArray[indexPath.row]
        cell?.imageView?.image = UIImage(named:imageStr)
        cell?.textLabel?.textColor = UIColor.darkGray
        cell?.backgroundColor = UIColor.clear
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    // 返回到menuView
    func backToMenuView() {
        
        if backBlock != nil {
            backBlock!()
        }
        
    }
    
    
}
