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
    func didSelectdidSelectCollectionItem(_ loopview:LoopView,appView:String)
}

class LoopView: UIView {
    
    // MARK: -内部方法和属性
    var collectionView:UICollectionView = {
        
        let layout = LoopViewLayout()
        let clv = UICollectionView(frame:CGRect(x: 0, y: 0, width: SCREEN_WIDTH,height: 300), collectionViewLayout:layout)
        clv.register(LoopViewCell.self, forCellWithReuseIdentifier: rid)
        
        return  clv
    }()
    var pageControl:UIPageControl? = {
        let pc = UIPageControl()
        pc.frame = CGRect(x: 0,y: 270,width: 0,height: 30)
        pc.pageIndicatorTintColor = UIColor.gray
        pc.currentPageIndicatorTintColor = UIColor.white
        return pc
    }()
    var timer:Timer?
    
    
    
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
            DispatchQueue.main.async { () -> Void in
                let path = IndexPath(item: 1, section: 0)
                self.collectionView.scrollToItem(at: path, at: UICollectionViewScrollPosition.left, animated: false)
                
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
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (imageArray?.count)!
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: rid, for: indexPath) as! LoopViewCell
        cell.imageName = imageArray![indexPath.item ] as? String
        cell.title = titleArray![indexPath.item] as? String
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        
        if ((delegate?.responds(to: Selector("didSelectdidSelectCollectionItem::"))) != nil) {
            print(newsUrlMutableArray![indexPath.item])
            delegate?.didSelectdidSelectCollectionItem(self, appView: newsUrlMutableArray![indexPath.item] as! String)
        }
    }
    
    // 开始拖动是调用
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollViewDidEndDecelerating(scrollView)
    }
    
    // 滚动减速时调用
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        var page = offsetX / scrollView.bounds.size.width
        let temp:CGFloat = CGFloat(collectionView.numberOfItems(inSection: 0) - 1)
        if page == 0 {
            collectionView.contentOffset = CGPoint(x: page * scrollView.frame.size.width, y: 0)
        } else if page == temp {
            page = CGFloat((imageArray?.count)! - 1)
            collectionView.contentOffset = CGPoint(x: page * scrollView.frame.size.width, y: 0)
        }
        
        // 设置pageController当前页
        let currentPage = page.truncatingRemainder(dividingBy: CGFloat(imageArray!.count))
        pageControl?.currentPage = Int(currentPage)
        
        // 添加定时器
        addTimer()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // 移除定时器
        removeTimer()
    }
    
    /**
     添加定时器
     */
    func addTimer() {
        timer = Timer(timeInterval: 4, target: self, selector: #selector(LoopView.nextImage), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoopMode(rawValue: "NSRunLoopCommonModes"))
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
        collectionView.setContentOffset(CGPoint(x: (page + 1) * collectionView.bounds.size.width, y: 0), animated: true)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = self.bounds
    }
    
   
    
}

class LoopViewLayout:UICollectionViewFlowLayout {
    override func prepare() {
        // item的大小
        itemSize = (collectionView?.frame.size)!
        // 滚动方向
        scrollDirection = UICollectionViewScrollDirection.horizontal
        // 设置分页
        collectionView?.isPagingEnabled = true
        // 设置最小间距
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        
        // 隐藏水平滚动条
        collectionView?.showsHorizontalScrollIndicator = false
    }
}

class LoopViewCell:UICollectionViewCell {
    
    // MARK: - 内部属性和方法
    fileprivate var iconView:UIImageView?
    fileprivate var titleLable:UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUI() {
        iconView = UIImageView()
        contentView.addSubview(iconView!)
        
        titleLable = UILabel()
        titleLable?.textColor = UIColor.white
        titleLable?.font = UIFont(name: "Helvetica-Bold", size: 20.0)
        titleLable?.numberOfLines = 3
        contentView.addSubview(titleLable!)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconView?.frame = contentView.bounds
        titleLable?.frame = CGRect(x: 20, y: contentView.bounds.size.height - 110, width: contentView.bounds.size.width - 40, height: 110)
    }
    
    // MARK: - 外部属性和方法
    
    /**轮播图url字符串*/
    var imageName:String? {
        didSet {
            let url = URL(string: imageName!)
            iconView?.sd_setImage(with: url, placeholderImage: UIImage(named: "feedback_placeholder"))
        }
    }
    /**标题*/
    var title:String? {
        didSet {
            titleLable?.text = title
        }
    }

}
