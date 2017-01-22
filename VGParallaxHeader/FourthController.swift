//
//  FourthController.swift
//  VGParallaxHeader
//
//  Created by 伯驹 黄 on 2017/1/20.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class FourthController: UIViewController, UIScrollViewDelegate {

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: self.view.frame)
        scrollView.backgroundColor = .white
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: 3000)
        return scrollView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        view.addSubview(scrollView)
        
        let stickyLabel = UILabel(frame: .zero)
        stickyLabel.backgroundColor = UIColor(red: 1, green: 0.749, blue: 0.976, alpha: 1)
        stickyLabel.textAlignment = .center
        stickyLabel.text = "Say hello to Sticky View :)"
        scrollView.parallaxHeaderView(HeaderView(image: UIImage(named: "Grumpy-Cat")), mode: .fill, height: 230, maxOffsetY: 120)
        scrollView.parallaxHeader?.stickyViewPosition = .bottom
        scrollView.parallaxHeader?.setStickyView(stickyView: stickyLabel, height: 40)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.parallaxHeader?.stickyView?.alpha = scrollView.parallaxHeader!.progress
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
