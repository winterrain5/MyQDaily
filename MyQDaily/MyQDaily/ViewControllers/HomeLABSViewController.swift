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
    fileprivate var contentArray:NSMutableArray?
    /** 是否还有未加载的文章 0：没有 1：有*/
    fileprivate var has_more:String?
    /** 拼接 到url 中的last_key*/
    fileprivate var last_key:String?
    // tableView滑动y的偏移量
    fileprivate var contentOffsetY:CGFloat?
    
    
    fileprivate var responseModel:ResponsModel?
    fileprivate lazy var feedsArray:[AnyObject] = [AnyObject]()
    
    fileprivate var sunRefrshView:YALSunnyRefreshControl = YALSunnyRefreshControl()
    fileprivate var refreshFooter:MJRefreshAutoNormalFooter?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        contentArray = NSMutableArray()
        refreshData()
        
        // 设置下拉刷新
        sunRefrshView.addTarget(self, action: #selector((refreshData)), for: .valueChanged)
        sunRefrshView.attach(to: tableView)
        
        
        // 设置上拉加载
        refreshFooter = MJRefreshAutoNormalFooter.init(refreshingBlock: { () -> Void in
            self.loadData()
        })
        refreshFooter?.setTitle("加载更多...", for: MJRefreshState.refreshing)
        refreshFooter?.setTitle("没有更多内容了", for: MJRefreshState.noMoreData)
        tableView.mj_footer = refreshFooter
    }

    // 下拉刷新
    @objc fileprivate func refreshData() {
        contentArray?.removeAllObjects()
        HomeNewsDataManager.shareInstance.requestHomeLabsDataWithLastKey("0") { (responseObject, error) -> () in
            if (error != nil) {
                MBProgressHUD.promptHudWithShowHUDAddedTo(self.view, message: "加载失败")
                return
            } else {
                
                if let tempDict = responseObject {
                    // 处理数据
                    self.responseModel = ResponsModel.mj_object(withKeyValues: tempDict)
                    self.last_key = self.responseModel?.last_key
                    self.has_more = self.responseModel?.has_more
                    
                    // 获取feed数组
                    self.feedsArray = FeedsModel.mj_objectArray(withKeyValuesArray: tempDict["feeds"]) as [AnyObject]
                    self.contentArray?.addObjects(from: self.feedsArray)

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
    fileprivate func loadData() {
        if has_more == "1" {
            HomeNewsDataManager.shareInstance.requestHomeLabsDataWithLastKey(last_key!, finished: { (responseObject, error) -> () in
                // 处理数据
                
                // 处理数据
                self.responseModel = ResponsModel.mj_object(withKeyValues: responseObject)
                self.last_key = self.responseModel?.last_key
                self.has_more = self.responseModel?.has_more
                
                // 获取feed数组
                self.feedsArray = FeedsModel.mj_objectArray(withKeyValuesArray: responseObject!["feeds"]) as [AnyObject]
                for feedModel in self.feedsArray {
                    let model = feedModel as! FeedsModel
                    self.contentArray?.insert(model, at: (self.contentArray?.count)!)
                }
                
                self.refreshFooter?.endRefreshing()
                
                self.tableView.reloadData()
                
                
            })
        } else if has_more == "0" {
            refreshFooter?.state = MJRefreshState.noMoreData
            
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentArray!.count
    }

 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let rid = "labsCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: rid) as? HomeLabsCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("HomeLabsCell", owner: nil, options: nil)?.last as? HomeLabsCell
        }
        if (contentArray?.count)! > 0 {
            let feedModel = contentArray?[indexPath.row]
            cell?.feedModel = feedModel as? FeedsModel
        }
        
        return cell!
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 296
    }
}
