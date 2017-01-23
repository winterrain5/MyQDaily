//
//  HomeViewController.swift
//  MyQDaily
//
//  Created by 石冬冬 on 17/1/17.
//  Copyright © 2017年 sdd. All rights reserved.
//

import UIKit
import MBProgressHUD
import MJRefresh

let  SCREEN_WIDTH  = UIScreen.mainScreen().bounds.size.width//屏幕宽度
let  SCREENH_HEIGHT = UIScreen.mainScreen().bounds.size.height//屏幕高度

class HomeViewController: UITableViewController {

    // MARK: -属性
//    private var homeNewsTableView:UITableView?
    /**model 数组*/
    private lazy var contentArray:NSMutableArray = {
        let array = NSMutableArray()
        return array
    }()
    /** 是否还有未加载的文章 0：没有 1：有*/
    private var has_more:String?
    /** 拼接 到url 中的last_key*/
    private var last_key:String?
    // tableView滑动y的偏移量
    private var contentOffsetY:CGFloat?
    
    
    private var responseModel:ResponsModel?
    private lazy var feedsArray:[AnyObject] = {
    
        let array = [AnyObject]()
        return array
        
    }()
    private lazy var bannersArray:[AnyObject] = {
        
        let array = [AnyObject]()
        return array
    }()

    private lazy var imageArray:[AnyObject] = {
        
        let array = [AnyObject]()
        return array
    }()

    
    // 刷新控件
    private var refreshHeader:MJRefreshNormalHeader?
    private var refreshFooter:MJRefreshAutoNormalFooter?
    private var cell:HomeNewsCell?
    
    private var suspensionView:SuspensionView?
    private var loopView:LoopView?
    private var menuView:MenuView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
    
        contentArray = NSMutableArray()
        feedsArray = [AnyObject]()
        bannersArray = [AnyObject]()
        imageArray = [AnyObject]()
        
        setupUI()
        
        refreshData()
        
        // 设置下拉刷新
        let refreshV = RefreshControlView()
        refreshControl = refreshV
        refreshControl?.addTarget(self, action: Selector("refreshData"), forControlEvents: UIControlEvents.ValueChanged)
        
        
        // 设置上拉加载
        refreshFooter = MJRefreshAutoNormalFooter.init(refreshingBlock: { () -> Void in
            self.loadData()
        })
        refreshFooter?.setTitle("加载更多...", forState: MJRefreshState.Refreshing)
        refreshFooter?.setTitle("没有更多内容了", forState: MJRefreshState.NoMoreData)
        tableView.mj_footer = refreshFooter
        
        
     
    }
    
    override func viewWillAppear(animated: Bool) {
         super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: true)
//        automaticallyAdjustsScrollViewInsets = false
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        suspensionView?.removeFromSuperview()
    }
    
  
    
     private func setupUI() {
        
        
        suspensionView = SuspensionView()
        let window = UIApplication.sharedApplication().keyWindow
        window!.addSubview(suspensionView!)
        suspensionView?.frame = CGRectMake(10, SCREENH_HEIGHT - 70, 54, 54)
        suspensionView?.delegate  = self
        suspensionView?.style = .QDaily
        
        menuView = MenuView()
        menuView?.frame = view.bounds
    }
    
    // 上拉加载
    private func loadData() {
        
        if has_more == "1" {
            HomeNewsDataManager.shareInstance.requestHomeNewDataWihtLastKey(last_key!, finished: { (responseObject, error) -> () in
                // 处理数据
                
                // 处理数据
                self.responseModel = ResponsModel.mj_objectWithKeyValues(responseObject)
                self.last_key = self.responseModel?.last_key
                self.has_more = self.responseModel?.has_more
                
                // 获取feed数组
                self.feedsArray = FeedsModel.mj_objectArrayWithKeyValuesArray(responseObject!["feeds"]) as [AnyObject]
                for feedModel in self.feedsArray {
                    let model = feedModel as! FeedsModel
                    self.contentArray.insertObject(model, atIndex: self.contentArray.count)
                }
                
                print(self.contentArray)
                self.refreshFooter?.endRefreshing()
                
                self.tableView.reloadData()
                
                
            })
        } else if has_more == "0" {
            refreshFooter?.state = MJRefreshState.NoMoreData
                
            }
    }
    
    // 下拉刷新
   @objc private func refreshData() {
        
        // 清空数据
        contentArray.removeAllObjects()
        MBProgressHUD.showLoadView(view, str: "加载中")
        HomeNewsDataManager.shareInstance.requestHomeNewDataWihtLastKey("0") { (responseObject, error) -> () in
            
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            if (error != nil) {
                MBProgressHUD.promptHudWithShowHUDAddedTo(self.view, message: "加载失败")
                return
            } else {
                
                if let tempDict = responseObject {
                    // 处理数据
                    self.responseModel = ResponsModel.mj_objectWithKeyValues(tempDict)
                    self.last_key = self.responseModel?.last_key
                    self.has_more = self.responseModel?.has_more
                    
                    // 获取feed数组
                    self.feedsArray = FeedsModel.mj_objectArrayWithKeyValuesArray(tempDict["feeds"]) as [AnyObject]
                    self.contentArray.addObjectsFromArray(self.feedsArray)
                    
                    // 获取banner数组
                    self.bannersArray = BannerModel.mj_objectArrayWithKeyValuesArray(tempDict["banners"]) as [AnyObject]
                    
                    self.refreshControl?.endRefreshing()
                    self.refreshFooter?.endRefreshing()
                    
                    // 添加轮播图
                    self.addLoopView()
                    
                    self.tableView.reloadData()
                } else {
                    MBProgressHUD.promptHudWithShowHUDAddedTo(self.view, message: "加载失败")
                    return
                }
            }
            
        }
    }
    
    private func addLoopView() {
        
        let imageArray = NSMutableArray()
        let titleArry = NSMutableArray()
        let newsUrlArray = NSMutableArray()
        for banberModel in bannersArray {
            let model = banberModel as! BannerModel
            imageArray.addObject((model.post?.image)!)
            titleArry.addObject((model.post?.title)!)
            newsUrlArray.addObject((model.post?.appview)!)
        }
        
        loopView = LoopView()
        loopView?.delegate = self
        loopView?.titleArray = titleArry as [AnyObject]
        loopView?.imageArray = imageArray as [AnyObject]
        loopView?.newsUrlMutableArray = newsUrlArray as [AnyObject]
        
        loopView?.frame = CGRectMake(0, 0, SCREEN_WIDTH, 300)
        
        tableView.tableHeaderView = loopView
    }
    
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (contentArray.count)
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let feedModel = contentArray[indexPath.row]
        
        let rid = "homeCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(rid) as? HomeNewsCell
        if cell == nil {
            cell = HomeNewsCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: rid)
        }
        
        cell?.feedModel = feedModel as? FeedsModel
        self.cell = cell
        cell!.selectionStyle = UITableViewCellSelectionStyle.None
        return cell!
    }
override     
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if cell?.cellType == "0" {
            return 360
        } else if cell?.cellType == "2" {
            return 360
        } else  {
            return 130
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let feedModel = contentArray[indexPath.row] as! FeedsModel
        let appView = feedModel.post?.appview
        let readVc = ReaderViewController()
        readVc.newsUrl = appView
        readVc.readerViewType = 2
        self.navigationController?.pushViewController(readVc, animated: true)
    }
    
    // MARK: -loopViewDelegate
    func didSelectdidSelectCollectionItem(loopview: LoopView, appView: String) {
        let readVc = ReaderViewController()
        readVc.newsUrl = appView
        readVc.readerViewType = 1
        self.navigationController?.pushViewController(readVc, animated: true)
    }

}


extension HomeViewController:LoopViewDelegate,SuspensionViewDelegate
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
    func backHome() {
        
    }
    func backToMenuView() {
        
    }
}