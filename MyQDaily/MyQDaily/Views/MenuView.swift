//
//  MenuView.swift
//  MyQDaily
//
//  Created by 石冬冬 on 17/1/20.
//  Copyright © 2017年 sdd. All rights reserved.
//

import UIKit
import pop

let Krid = "menuCell"
let KHeaderViewH:CGFloat = 200

class MenuView: UIView {
    
    // MARK: -内部方法
    /**模糊效果层*/
    private var blurEffectView:UIVisualEffectView = {
        let effect = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
        let blurV = UIVisualEffectView(effect: effect)
        return blurV
    }()
    /**上半部分设置按钮的父view*/
    private var haderView:UIView?
    /**下半部分菜单的父view*/
    private var footerView:UIView?
    
    private var menuTableView:UITableView?
    /**新闻分类菜单界面*/
    private var newsClassificationView:NewsClassificationView?
    
    /**菜单cell图片数组*/
    private var imageArray:[String] = {
        let array = ["menu_about",
            "menu_category",
            "menu_column",
            "menu_lab",
            "menu_noti",
            "menu_user",
            "menu_home"]
        return array
        
    }()
    /**菜单cell标题数组*/
    private var titleArray:[String] = {
        let array = ["关于我们",
            "新闻分类",
            "栏目中心",
            "好奇心研究所",
            "我的消息",
            "个人中心",
            "首页"]
        return array
        
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        blurEffectView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT)
        addSubview(blurEffectView)
        
        self.haderView = UIView()
        self.haderView?.backgroundColor = UIColor.clearColor()
        self.haderView?.frame = CGRectMake(0, -KHeaderViewH, SCREEN_WIDTH, KHeaderViewH)
        addSubview(self.haderView!)
        
        footerView = UIView()
        footerView?.backgroundColor = UIColor.clearColor()
        footerView?.frame = CGRectMake(0, SCREENH_HEIGHT, SCREEN_WIDTH, SCREENH_HEIGHT - KHeaderViewH)
        addSubview(footerView!)
        
        menuTableView = UITableView(frame: CGRectMake(0, 0, 190, SCREENH_HEIGHT - KHeaderViewH - 80), style: UITableViewStyle.Plain)
        menuTableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: Krid)
        menuTableView?.backgroundColor = UIColor.clearColor()
        menuTableView?.dataSource = self
        menuTableView?.delegate = self
        
        
        footerView?.addSubview(menuTableView!)
        
        // 设置button
        addHeadViewSubViews()
    }
    
    private func addHeadViewSubViews() {
        let textField = UITextField()
        textField.placeholder = "搜索"
        textField.frame = CGRectMake(30, 50, SCREEN_WIDTH - 60, 34)
        let imageView = UIImageView(image: UIImage(named: "search_icon"))
        textField.leftView = imageView
        textField.leftViewMode = UITextFieldViewMode.Always
        textField.backgroundColor = UIColor.whiteColor()
        textField.alpha = 0.8
        textField.layer.cornerRadius = 3
        textField.layer.masksToBounds = true
        textField.font = UIFont.systemFontOfSize(15)
        textField.delegate = self
        self.haderView?.addSubview(textField)
        
        let iconNameArray:[String] = ["sidebar_setting","sidebar_switchNight","sidebar_offline","sidebar_share"]
        let titleArray:[String] = ["设置","夜间","离线","推荐"]
        
        let width:CGFloat = 60
        let height:CGFloat = 50
        let margin:CGFloat = 25
        for i in 0...3 {
            let btn = UIButton()
            let x = margin * CGFloat(i + 1) + width * CGFloat(i)
            let imageStr = iconNameArray[i] as String
            btn.setImage(UIImage(named: imageStr), forState: UIControlState.Normal)
            btn.backgroundColor = UIColor.clearColor()
            btn.frame = CGRectMake(x, CGRectGetMaxY(textField.frame) + 25, width, height)
            self.haderView?.addSubview(btn)
        }
        
        for i in 0...3 {
            let label = UILabel()
            let x = margin * CGFloat(i + 1) + width * CGFloat(i)
            let lableStr = titleArray[i] as String
            label.backgroundColor = UIColor.clearColor()
            label.frame = CGRectMake(x, CGRectGetMaxY(textField.frame) + 60, width, height)
            label.text = lableStr
            label.font = UIFont.systemFontOfSize(13)
            label.textColor = UIColor.darkGrayColor()
            label.textAlignment = NSTextAlignment.Center
            self.haderView?.addSubview(label)
        }
        
    }
    
    
    // pop动画
    private func popAnimationWithView(view: UIView, offset:CGFloat, speed:CGFloat) {
        let popSpring = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
        popSpring.toValue = view.center.y + offset;
        popSpring.beginTime = CACurrentMediaTime();
        popSpring.springBounciness = 11.0;
        popSpring.springSpeed = speed;
        view.pop_addAnimation(popSpring, forKey: "positionY")
    }
    
    // 改变headerView的Y值
    private func headerViewOffsetY(offsetY:CGFloat) {
        var tempFrame = haderView?.frame
        tempFrame?.origin.y = offsetY
        haderView?.frame = tempFrame!
    }
    
    // 改变footerView的Y值
    private func footerViewOffsetY(offsetY:CGFloat) {
        var tempFrame = footerView?.frame
        tempFrame?.origin.y = offsetY
        footerView?.frame = tempFrame!
    }
    
    // MARK: 外部方法
    /**
    弹出菜单界面
    */
    func popupMunuViewAnimation() {
        // 显示menuView
        hidden = false
        
        if -KHeaderViewH == self.haderView?.layer.frame.origin.y {
            self.popAnimationWithView(self.haderView!, offset: KHeaderViewH, speed: 15)
        }
        if SCREENH_HEIGHT == self.footerView?.layer.frame.origin.y {
            self.popAnimationWithView(footerView!, offset: -(SCREENH_HEIGHT - KHeaderViewH), speed: 15)
        }
    }
    
    /**
     隐藏菜单
     */
    func hideMenuViewAnimation() {
        UIView.animateWithDuration(0.1, animations: { () -> Void in
                self.headerViewOffsetY(-KHeaderViewH)
                self.footerViewOffsetY(SCREENH_HEIGHT)
            }) { (finished) -> Void in
                // 隐藏menuView
                self.hidden = true
        }
    }
    
    // 隐藏新闻分类菜单
    func hideNewsClassificationViewAnimation () {
        
    }
}

extension MenuView: UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return imageArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(Krid)
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: Krid)
        }
        
        cell?.textLabel?.text = titleArray[indexPath.row]
        cell?.textLabel?.textColor = UIColor.darkGrayColor()
        cell?.backgroundColor = UIColor.clearColor()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        cell?.selectionStyle = UITableViewCellSelectionStyle.None
        cell?.imageView?.image = UIImage(named:imageArray[indexPath.row])
        if indexPath.row == 1 {
            cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        return cell!
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    // MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(textField: UITextField) {
        print("asdf")
    }
}
