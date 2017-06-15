//
//  ViewController.swift
//  Example
//
//  Created by jesse on 2017/6/15.
//  Copyright © 2017年 jesse. All rights reserved.
//

import UIKit
import JSInfiniteBanner

class ViewController: UIViewController {

    var bannber: JSInfiniteBanner!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannber = JSInfiniteBanner(frame: CGRect(x: 0, y: 20, width: view.bounds.width, height: 200), data: ["http://pic130.nipic.com/file/20170518/12398452_110125003000_2.jpg", "http://pic129.nipic.com/file/20170508/21897230_112747358000_2.jpg", "http://pic129.nipic.com/file/20170513/24778557_175703312000_2.jpg", "http://pic129.nipic.com/file/20170515/24480651_125442112000_2.jpg"])
        view.addSubview(bannber)
    }


}

