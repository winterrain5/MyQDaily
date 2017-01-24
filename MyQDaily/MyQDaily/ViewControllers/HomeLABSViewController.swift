//
//  HomeLABSViewController.swift
//  MyQDaily
//
//  Created by 石冬冬 on 17/1/21.
//  Copyright © 2017年 sdd. All rights reserved.
//

import UIKit
import MJRefresh
import MBProgressHUD
class HomeLABSViewController: UITableViewController {

    
    /**model 数组*/
    private lazy var contentArray:NSMutableArray = NSMutableArray()
    /** 是否还有未加载的文章 0：没有 1：有*/
    private var has_more:String?
    /** 拼接 到url 中的last_key*/
    private var last_key:String?
    // tableView滑动y的偏移量
    private var contentOffsetY:CGFloat?
    
    
    private var responseModel:ResponsModel?
    private lazy var feedsArray:[AnyObject] = [AnyObject]()
    
    private var sunRefrshView:YALSunnyRefreshControl = YALSunnyRefreshControl()
    private var refreshFooter:MJRefreshAutoNormalFooter?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()
        
        refreshData()
        
        // 设置下拉刷新
        sunRefrshView.addTarget(self, action: Selector("refreshData"), forControlEvents: UIControlEvents.ValueChanged)
        sunRefrshView.attachToScrollView(tableView)
        
        
        // 设置上拉加载
        refreshFooter = MJRefreshAutoNormalFooter.init(refreshingBlock: { () -> Void in
            self.loadData()
        })
        refreshFooter?.setTitle("加载更多...", forState: MJRefreshState.Refreshing)
        refreshFooter?.setTitle("没有更多内容了", forState: MJRefreshState.NoMoreData)
        tableView.mj_footer = refreshFooter
    }

    // 下拉刷新
    private func refreshData() {
        contentArray.removeAllObjects()
        HomeNewsDataManager.shareInstance.requestHomeLabsDataWithLastKey("0") { (responseObject, error) -> () in
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

                    self.sunRefrshView.endRefreshing()
                    self.refreshFooter?.endRefreshing()
                    

                    self.tableView.reloadData()
                } else {
                    MBProgressHUD.promptHudWithShowHUDAddedTo(self.view, message: "加载失败")
                    return
                }
            }
        }
    }
    
    // 上拉加载
    private func loadData() {
        if has_more == "1" {
            HomeNewsDataManager.shareInstance.requestHomeLabsDataWithLastKey(last_key!, finished: { (responseObject, error) -> () in
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

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentArray.count
    }

 
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let rid = "labsCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(rid) as? HomeLabsCell
        if cell == nil {
            cell = NSBundle.mainBundle().loadNibNamed("HomeLabsCell", owner: nil, options: nil).last as? HomeLabsCell
        }
        let feedModel = contentArray[indexPath.row]
        cell?.feedModel = feedModel as? FeedsModel
        return cell!
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
         return 296
    }
}
