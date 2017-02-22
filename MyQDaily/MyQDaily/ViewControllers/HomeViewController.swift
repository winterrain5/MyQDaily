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

let  SCREEN_WIDTH  = UIScreen.main.bounds.size.width//屏幕宽度
let  SCREENH_HEIGHT = UIScreen.main.bounds.size.height//屏幕高度

class HomeViewController: UITableViewController {

    // MARK: -属性
//    private var homeNewsTableView:UITableView?
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
    fileprivate lazy var bannersArray:[AnyObject] = [AnyObject]()
    fileprivate lazy var imageArray:[AnyObject] = [AnyObject]()

    
    // 刷新控件
    fileprivate var refreshHeader:MJRefreshNormalHeader?
    fileprivate var refreshFooter:MJRefreshAutoNormalFooter?
    fileprivate var sunRefrshView:YALSunnyRefreshControl = YALSunnyRefreshControl()
    fileprivate var cell:HomeNewsCell?
    
   
    fileprivate var loopView:LoopView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentArray = NSMutableArray()
        self.view.backgroundColor = UIColor.white
        
        refreshData()
        // 设置下拉刷新
        sunRefrshView.addTarget(self, action: #selector(HomeViewController.refreshData), for: UIControlEvents.valueChanged)
        sunRefrshView.attach(to: self.tableView)
        
        
        // 设置上拉加载
        refreshFooter = MJRefreshAutoNormalFooter.init(refreshingBlock: { () -> Void in
            self.loadData()
        })
        refreshFooter?.setTitle("加载更多...", for: MJRefreshState.refreshing)
        refreshFooter?.setTitle("没有更多内容了", for: MJRefreshState.noMoreData)
        tableView.mj_footer = refreshFooter
        
        
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
    }
 
    // 上拉加载
    fileprivate func loadData() {
        
        if has_more == "1" {
            HomeNewsDataManager.shareInstance.requestHomeNewDataWihtLastKey(last_key!, finished: { (responseObject, error) -> () in
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
    
    // 下拉刷新
   @objc fileprivate func refreshData() {
        print("1111")
        // 清空数据
        contentArray?.removeAllObjects()
        HomeNewsDataManager.shareInstance.requestHomeNewDataWihtLastKey("0") { (responseObject, error) -> () in
            
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
                    
                    // 获取banner数组
                    self.bannersArray = BannerModel.mj_objectArray(withKeyValuesArray: tempDict["banners"]) as [AnyObject]
                    
                    self.sunRefrshView.endRefreshing()
                    
                    self.tableView.reloadData()
                    
                    // 添加轮播图
                    self.addLoopView()
                } else {
                    MBProgressHUD.promptHudWithShowHUDAddedTo(self.view, message: "加载失败")
                    return
                }
            }
            
        }
    }
    
    fileprivate func addLoopView() {
        
        let imageArray = NSMutableArray()
        let titleArry = NSMutableArray()
        let newsUrlArray = NSMutableArray()
        for banberModel in bannersArray {
            let model = banberModel as! BannerModel
            imageArray.add((model.post?.image)!)
            titleArry.add((model.post?.title)!)
            newsUrlArray.add((model.post?.appview)!)
        }
        
        loopView = LoopView()
        loopView?.delegate = self
        loopView?.titleArray = titleArry as [AnyObject]
        loopView?.imageArray = imageArray as [AnyObject]
        loopView?.newsUrlMutableArray = newsUrlArray as [AnyObject]
        
        loopView?.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 300)
        
        tableView.tableHeaderView = loopView
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (contentArray!.count)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let rid = "homeCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: rid) as? HomeNewsCell
        if cell == nil {
            cell = HomeNewsCell.init(style: UITableViewCellStyle.default, reuseIdentifier: rid)
        }
        if (contentArray?.count)! > 0 {
            let feedModel = contentArray?[indexPath.row]
            cell?.feedModel = feedModel as? FeedsModel
        }
        
        self.cell = cell
        cell!.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
override     
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if cell?.cellType == "0" {
            return 360
        } else if cell?.cellType == "2" {
            return 360
        } else  {
            return 130
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let feedModel = contentArray?[indexPath.row] as! FeedsModel
        let appView = feedModel.post?.appview
        let readVc = ReaderViewController()
        readVc.newsUrl = appView
        readVc.readerViewType = 2
        self.navigationController?.pushViewController(readVc, animated: true)
    }
    
    // MARK: -loopViewDelegate
    func didSelectdidSelectCollectionItem(_ loopview: LoopView, appView: String) {
        let readVc = ReaderViewController()
        readVc.newsUrl = appView
        readVc.readerViewType = 1
        self.navigationController?.pushViewController(readVc, animated: true)
    }

}


extension HomeViewController:LoopViewDelegate
{
    
  
}
