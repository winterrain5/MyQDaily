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
    fileprivate var blurEffectView:UIVisualEffectView = {
        let effect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        let blurV = UIVisualEffectView(effect: effect)
        return blurV
    }()
    /**上半部分设置按钮的父view*/
    fileprivate var haderView:UIView?
    /**下半部分菜单的父view*/
    fileprivate var footerView:UIView?
    
    fileprivate var menuTableView:UITableView?
    /**新闻分类菜单界面*/
    fileprivate var newsClassificationView:NewsClassificationView?
    
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
    /**菜单cell标题数组*/
    fileprivate var titleArray:[String] = {
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
    
    
    fileprivate func setupUI() {
        blurEffectView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREENH_HEIGHT)
        addSubview(blurEffectView)
        
        // 头视图
        self.haderView = UIView()
        self.haderView?.backgroundColor = UIColor.clear
        self.haderView?.frame = CGRect(x: 0, y: -KHeaderViewH, width: SCREEN_WIDTH, height: KHeaderViewH)
        addSubview(self.haderView!)
        
        // 菜单view的父view
        footerView = UIView()
        footerView?.backgroundColor = UIColor.clear
        footerView?.frame = CGRect(x: 0, y: SCREENH_HEIGHT, width: SCREEN_WIDTH, height: SCREENH_HEIGHT - KHeaderViewH)
        addSubview(footerView!)
        
        // 菜单view
        menuTableView = UITableView(frame: CGRect(x: 0, y: 0, width: 190, height: SCREENH_HEIGHT - KHeaderViewH - 80), style: UITableViewStyle.plain)
        menuTableView?.register(UITableViewCell.self, forCellReuseIdentifier: Krid)
        menuTableView?.backgroundColor = UIColor.clear
        menuTableView?.dataSource = self
        menuTableView?.delegate = self
        footerView?.addSubview(menuTableView!)
        
        // 设置button
        addHeadViewSubViews()
        
        // 新闻分类view
        newsClassificationView = NewsClassificationView()
        newsClassificationView?.frame = CGRect(x: SCREEN_WIDTH, y: KHeaderViewH, width: SCREEN_WIDTH, height: SCREENH_HEIGHT - KHeaderViewH)
        // 隐藏自己 返回到menuView
        newsClassificationView?.backBlock = { ()-> Void
            in
            if self.hideNewsClassificationViewBlock != nil {
                self.hideNewsClassificationViewBlock!()
            }
        }
        addSubview(newsClassificationView!)
    }
    
    fileprivate func addHeadViewSubViews() {
        let textField = UITextField()
        textField.placeholder = "搜索"
        textField.frame = CGRect(x: 30, y: 50, width: SCREEN_WIDTH - 60, height: 34)
        let imageView = UIImageView(image: UIImage(named: "search_icon"))
        textField.leftView = imageView
        textField.leftViewMode = UITextFieldViewMode.always
        textField.backgroundColor = UIColor.white
        textField.alpha = 0.8
        textField.layer.cornerRadius = 3
        textField.layer.masksToBounds = true
        textField.font = UIFont.systemFont(ofSize: 15)
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
            btn.setImage(UIImage(named: imageStr), for: UIControlState())
            btn.backgroundColor = UIColor.clear
            btn.frame = CGRect(x: x, y: textField.frame.maxY + 25, width: width, height: height)
            self.haderView?.addSubview(btn)
        }
        
        for i in 0...3 {
            let label = UILabel()
            let x = margin * CGFloat(i + 1) + width * CGFloat(i)
            let lableStr = titleArray[i] as String
            label.backgroundColor = UIColor.clear
            label.frame = CGRect(x: x, y: textField.frame.maxY + 60, width: width, height: height)
            label.text = lableStr
            label.font = UIFont.systemFont(ofSize: 13)
            label.textColor = UIColor.darkGray
            label.textAlignment = NSTextAlignment.center
            self.haderView?.addSubview(label)
        }
        
    }
    
    
    // pop动画
    
    
    // 弹出新闻分类菜单
    fileprivate func popupNewsCLassificatioViewAnimation() {
        UIView.animate(withDuration: 0.15, animations: { () -> Void in
                self.changeMenuTableViewOffsetX(-SCREEN_WIDTH)
            }, completion: { (finished) -> Void in
                let popSpring = POPSpringAnimation(propertyNamed: kPOPLayerPositionX)!
                popSpring.toValue = (self.newsClassificationView?.center.x)! - SCREEN_WIDTH
                popSpring.beginTime = CACurrentMediaTime()
                popSpring.springSpeed = 15
                popSpring.springBounciness = 8
                self.newsClassificationView?.pop_add(popSpring, forKey: "positionX")
        }) 
        
    }
    
    // 隐藏新闻分类菜单
    func hideNewsClassificationViewAnimation () {
        newsClassificationView?.hideSuspensionView()
        UIView.animate(withDuration: 0.15, animations: { () -> Void in
                UIView.animate(withDuration: 0.15, animations: { () -> Void in
                    self.changeNewsClassificationViewOffsetX(SCREEN_WIDTH)
                })
            }, completion: { (finished) -> Void in
                UIView.animate(withDuration: 0.15, animations: { () -> Void in
                        self.changeMenuTableViewOffsetX(10)
                    }, completion: { (_) -> Void in
                        UIView.animate(withDuration: 0.15, animations: { () -> Void in
                                self.changeMenuTableViewOffsetX(-5)
                            }, completion: { (_) -> Void in
                                UIView.animate(withDuration: 0.1, animations: { () -> Void in
                                    self.changeMenuTableViewOffsetX(0)
                                })
                        })
                })
        }) 
    }
    
    // 改变menuTableView的x值
    fileprivate func changeMenuTableViewOffsetX(_ offsetX: CGFloat) {
        var tempFrame = self.menuTableView?.frame
        tempFrame?.origin.x = offsetX
        self.menuTableView?.frame = tempFrame!
    }
    
    // 改变newsClassificationView的x值
    fileprivate func changeNewsClassificationViewOffsetX(_ offsetX: CGFloat) {
        var tempFrame = self.newsClassificationView?.frame
        tempFrame?.origin.x = offsetX
        self.newsClassificationView?.frame = tempFrame!
    }
    
    fileprivate func popAnimationWithView(_ view: UIView, offset:CGFloat, speed:CGFloat) {
        let popSpring = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
        popSpring?.toValue = view.center.y + offset;
        popSpring?.beginTime = CACurrentMediaTime();
        popSpring?.springBounciness = 11.0;
        popSpring?.springSpeed = speed;
        view.pop_add(popSpring, forKey: "positionY")
    }
    
    // 改变headerView的Y值
    fileprivate func headerViewOffsetY(_ offsetY:CGFloat) {
        var tempFrame = haderView?.frame
        tempFrame?.origin.y = offsetY
        haderView?.frame = tempFrame!
    }
    
    // 改变footerView的Y值
    fileprivate func footerViewOffsetY(_ offsetY:CGFloat) {
        var tempFrame = footerView?.frame
        tempFrame?.origin.y = offsetY
        footerView?.frame = tempFrame!
    }
    
    // MARK: 外部方法
    typealias cellDidSelectBlock = (_ methodName:String)->Void
    
    typealias menuViewBlcok = () -> Void
    
    var cellBlock:cellDidSelectBlock?
    
    var popupNewsClassificationViewBlock:menuViewBlcok?
    var hideNewsClassificationViewBlock:menuViewBlcok?
    
    var mehtodNameArray:[String] = {
        let array = ["aboutUs","newsClassification","paogramaCenter","curiosityResearch","myMessage","userCenter","homePage"]
        return array
    }()
    /**
    弹出菜单界面
    */
    func popupMunuViewAnimation() {
        // 显示menuView
        isHidden = false
        
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
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.headerViewOffsetY(-KHeaderViewH)
                self.footerViewOffsetY(SCREENH_HEIGHT)
            }, completion: { (finished) -> Void in
                // 隐藏menuView
                self.isHidden = true
        }) 
    }
    
  
}

extension MenuView: UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return imageArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: Krid)
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: Krid)
        }
        
        cell?.textLabel?.text = titleArray[indexPath.row]
        cell?.textLabel?.textColor = UIColor.darkGray
        cell?.backgroundColor = UIColor.clear
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        cell?.imageView?.image = UIImage(named:imageArray[indexPath.row])
        if indexPath.row == 1 {
            cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)! as UITableViewCell
        if cell.textLabel?.text == "新闻分类" {
            popupNewsCLassificatioViewAnimation()
            newsClassificationView?.popupSuspensionView()
            if popupNewsClassificationViewBlock != nil {
                self.popupNewsClassificationViewBlock!()
            }
        } else {
            if cellBlock != nil {
                cellBlock!(mehtodNameArray[indexPath.row])
            }
        }
       

    }
    
    // MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("asdf")
    }
}
