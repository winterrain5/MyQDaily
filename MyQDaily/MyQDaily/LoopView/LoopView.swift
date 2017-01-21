//
//  LoopView.swift
//  MyQDaily
//
//  Created by 石冬冬 on 17/1/19.
//  Copyright © 2017年 sdd. All rights reserved.
//

import UIKit
let rid = "loopViewCell"

protocol LoopViewDelegate:NSObjectProtocol {
    func didSelectdidSelectCollectionItem(loopview:LoopView,appView:String)
}

class LoopView: UIView {
    
    // MARK: -内部方法和属性
    var collectionView:UICollectionView = {
        
        let layout = LoopViewLayout()
        let clv = UICollectionView(frame:CGRectMake(0, 0, SCREEN_WIDTH,300), collectionViewLayout:layout)
        clv.registerClass(LoopViewCell.self, forCellWithReuseIdentifier: rid)
        
        return  clv
    }()
    var pageControl:UIPageControl? = {
        let pc = UIPageControl()
        pc.frame = CGRectMake(0,270,0,30)
        pc.pageIndicatorTintColor = UIColor.grayColor()
        pc.currentPageIndicatorTintColor = UIColor.whiteColor()
        return pc
    }()
    var timer:NSTimer?
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        
        newsUrlMutableArray = [AnyObject]()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        addSubview(collectionView)
        addSubview(pageControl!)
        collectionView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    // MARK: - 外部方法和属性
    var newsUrlMutableArray:[AnyObject]?
    var imageArray:[AnyObject]? {
        didSet {
            pageControl?.numberOfPages = (imageArray?.count)!
            
            // 更新视图
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                let path = NSIndexPath(forItem: 1, inSection: 0)
                self.collectionView.scrollToItemAtIndexPath(path, atScrollPosition: UICollectionViewScrollPosition.Left, animated: false)
                
                // 添加定时器
                self.addTimer()
            }
        }
    }
    var titleArray:[AnyObject]?
    weak var delegate:LoopViewDelegate?
   
    deinit {
        removeTimer()
    }
}


extension LoopView: UICollectionViewDataSource,UICollectionViewDelegate
{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (imageArray?.count)!
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(rid, forIndexPath: indexPath) as! LoopViewCell
        cell.imageName = imageArray![indexPath.item ] as? String
        cell.title = titleArray![indexPath.item] as? String
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        
        if ((delegate?.respondsToSelector(Selector("didSelectdidSelectCollectionItem::"))) != nil) {
            print(newsUrlMutableArray![indexPath.item])
            delegate?.didSelectdidSelectCollectionItem(self, appView: newsUrlMutableArray![indexPath.item] as! String)
        }
    }
    
    // 开始拖动是调用
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        scrollViewDidEndDecelerating(scrollView)
    }
    
    // 滚动减速时调用
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        var page = offsetX / scrollView.bounds.size.width
        let temp:CGFloat = CGFloat(collectionView.numberOfItemsInSection(0) - 1)
        if page == 0 {
            collectionView.contentOffset = CGPointMake(page * scrollView.frame.size.width, 0)
        } else if page == temp {
            page = CGFloat((imageArray?.count)! - 1)
            collectionView.contentOffset = CGPointMake(page * scrollView.frame.size.width, 0)
        }
        
        // 设置pageController当前页
        let currentPage = page % CGFloat(imageArray!.count)
        pageControl?.currentPage = Int(currentPage)
        
        // 添加定时器
        addTimer()
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        // 移除定时器
        removeTimer()
    }
    
    /**
     添加定时器
     */
    func addTimer() {
        timer = NSTimer(timeInterval: 4, target: self, selector: Selector("nextImage"), userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer!, forMode: "NSRunLoopCommonModes")
    }
    
    /**
     移除定时器
     */
    func removeTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    /**
     下一张图片
     */
    func nextImage() {
        let offsetX = collectionView.contentOffset.x
        let page = offsetX / collectionView.bounds.size.width
        collectionView.setContentOffset(CGPointMake((page + 1) * collectionView.bounds.size.width, 0), animated: true)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = self.bounds
    }
    
   
    
}

class LoopViewLayout:UICollectionViewFlowLayout {
    override func prepareLayout() {
        // item的大小
        itemSize = (collectionView?.frame.size)!
        // 滚动方向
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        // 设置分页
        collectionView?.pagingEnabled = true
        // 设置最小间距
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        
        // 隐藏水平滚动条
        collectionView?.showsHorizontalScrollIndicator = false
    }
}

class LoopViewCell:UICollectionViewCell {
    
    // MARK: - 内部属性和方法
    private var iconView:UIImageView?
    private var titleLable:UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        iconView = UIImageView()
        contentView.addSubview(iconView!)
        
        titleLable = UILabel()
        titleLable?.textColor = UIColor.whiteColor()
        titleLable?.font = UIFont(name: "Helvetica-Bold", size: 20.0)
        titleLable?.numberOfLines = 3
        contentView.addSubview(titleLable!)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconView?.frame = contentView.bounds
        titleLable?.frame = CGRectMake(20, contentView.bounds.size.height - 110, contentView.bounds.size.width - 40, 110)
    }
    
    // MARK: - 外部属性和方法
    
    /**轮播图url字符串*/
    var imageName:String? {
        didSet {
            let url = NSURL(string: imageName!)
            iconView?.sd_setImageWithURL(url, placeholderImage: UIImage(named: "feedback_placeholder"))
        }
    }
    /**标题*/
    var title:String? {
        didSet {
            titleLable?.text = title
        }
    }

}
