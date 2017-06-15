//
//  JSInfiniteBanner.swift
//  JSInfiniteBanner
//
//  Created by jesse on 2017/6/14.
//  Copyright © 2017年 jesse. All rights reserved.
//

import UIKit

class JSInfiniteBanner: UIView {
    
    let identifier = "JSInfiniteBannerIdentifier"
    var data: [String]!
    var pages = [CGFloat]()
    lazy var pageControl: UIPageControl = {
        let pageControl: UIPageControl = UIPageControl(frame: CGRect(x: 0, y: self.bounds.height - 35, width: self.bounds.width, height: 20))
        pageControl.pageIndicatorTintColor = UIColor.gray
        pageControl.currentPageIndicatorTintColor = UIColor.red
        return pageControl
    }()
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.itemSize = self.bounds.size
        let collectionView: UICollectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(JSInfiniteBannerCell.self, forCellWithReuseIdentifier: self.identifier)
        return collectionView
    }()

    init(frame: CGRect, data: [String]) {
        super.init(frame: frame)
        self.data = data
        uiSet()
        dataSet()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension JSInfiniteBanner {
    
    func uiSet() {
        addSubview(collectionView)
        addSubview(pageControl)
        
    }
    
    func dataSet() {
        collectionView.setContentOffset(CGPoint(x: bounds.width * CGFloat(data.count * 100), y: 0), animated: true)
        pageControl.numberOfPages = data.count
        (0..<data.count).forEach {
            pages.append(CGFloat($0) * bounds.width + bounds.width / 2)
        }
    }
    
}

extension JSInfiniteBanner: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x .truncatingRemainder(dividingBy: bounds.width * CGFloat(data.count))
        if pages.count > 0, offset > pages.last! {
            pageControl.currentPage = 0
        }else {
            for (index, x) in pages.enumerated() {
                if offset < x {
                    pageControl.currentPage = index
                    break
                }
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 201
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! JSInfiniteBannerCell
        cell.url = data[indexPath.row]
        cell.backgroundColor = UIColor.gray
        return cell
    }
    
}
