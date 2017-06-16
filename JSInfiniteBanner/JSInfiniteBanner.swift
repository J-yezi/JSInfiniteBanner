//
//  JSInfiniteBanner.swift
//  JSInfiniteBanner
//
//  Created by jesse on 2017/6/14.
//  Copyright © 2017年 jesse. All rights reserved.
//

import UIKit

public class JSInfiniteBanner: UIView {
    
    fileprivate let identifier = "JSInfiniteBannerIdentifier"
    fileprivate let sectionCount: Int = 201
    fileprivate let intervals: TimeInterval = 4
    fileprivate var timer: Timer?
    fileprivate lazy var pageControl: UIPageControl = {
        let pageControl: UIPageControl = UIPageControl(frame: CGRect(x: 0, y: self.bounds.height - 35, width: self.bounds.width, height: 20))
        pageControl.pageIndicatorTintColor = UIColor.gray
        pageControl.currentPageIndicatorTintColor = UIColor.red
        return pageControl
    }()
    fileprivate lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.itemSize = self.bounds.size
        return layout
    }()
    fileprivate lazy var collectionView: UICollectionView = {
        let collectionView: UICollectionView = UICollectionView(frame: self.bounds, collectionViewLayout: self.layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(JSInfiniteBannerCell.self, forCellWithReuseIdentifier: self.identifier)
        return collectionView
    }()
    public var data: [String] = [String]() {
        didSet {
            if data.count > 0 {
                if data.count > 1 {
                    pageControl.isHidden = false
                    startTimer()
                }else {
                    pageControl.isHidden = true
                    stopTimer()
                }
                dataSet()
                collectionView.reloadData()
            }
        }
    }
    
    public init(frame: CGRect, data: [String]) {
        super.init(frame: frame)
        /// 在init方法里面，如果不适用kvc的方法，是不会调用didSet方法
        self.setValue(data, forKey: "data")
        uiSet()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        uiSet()
    }
    
}

extension JSInfiniteBanner {
    
    func uiSet() {
        addSubview(collectionView)
        addSubview(pageControl)
    }
    
    func dataSet() {
        if data.count > 1 {
            collectionView.setContentOffset(CGPoint(x: bounds.width * CGFloat(data.count * (sectionCount - 1) / 2), y: 0), animated: false)
            pageControl.numberOfPages = data.count
        }else {
            collectionView.setContentOffset(CGPoint.zero, animated: false)
        }
    }
    
    func repeatScroll() {
        collectionView.setContentOffset(CGPoint(x: collectionView.contentOffset.x + bounds.width, y: 0), animated: true)
    }
    
    func startTimer() {
        timer = Timer(timeInterval: intervals, target: self, selector: #selector(repeatScroll), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoopMode.commonModes)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
}

extension JSInfiniteBanner: UICollectionViewDelegate, UICollectionViewDataSource {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard data.count > 1 else { return }
        
        let currentPage: Int = Int(((scrollView.contentOffset.x + layout.itemSize.width / 2) / layout.itemSize.width).truncatingRemainder(dividingBy: CGFloat(data.count)))
        pageControl.currentPage = currentPage
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopTimer()
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        startTimer()
    }
    
    /// 因为这种banner有取巧的嫌疑，所有如果用户停止了连续拖动后，将collectionView又设置到中间
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        collectionView.setContentOffset(CGPoint(x: layout.itemSize.width * CGFloat(data.count * (sectionCount - 1) / 2 + pageControl.currentPage), y: 0), animated: false)
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        collectionView.setContentOffset(CGPoint(x: layout.itemSize.width * CGFloat(data.count * (sectionCount - 1) / 2 + pageControl.currentPage), y: 0), animated: false)
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return data.count > 1 ? sectionCount : 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! JSInfiniteBannerCell
        cell.url = data[indexPath.row]
        cell.backgroundColor = UIColor.gray
        return cell
    }
    
}
