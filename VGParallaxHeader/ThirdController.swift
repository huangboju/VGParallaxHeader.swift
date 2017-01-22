//
//  SecondController.swift
//  VGParallaxHeader
//
//  Created by 伯驹 黄 on 2017/1/20.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class ThirdController: UIViewController {
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: self.view.frame)
        scrollView.backgroundColor = .white
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: 3000)
        return scrollView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.lightGray
        view.addSubview(scrollView)
        
        let stickyLabel = UILabel(frame: .zero)
        stickyLabel.backgroundColor = UIColor(red: 1, green: 0.749, blue: 0.976, alpha: 1)
        stickyLabel.textAlignment = .center
        stickyLabel.text = "Say hello to Sticky View :)"
        scrollView.parallaxHeaderView(HeaderView(), mode: .center, height: 200)
        scrollView.parallaxHeader?.stickyViewPosition = .top
        scrollView.parallaxHeader?.setStickyView(stickyView: stickyLabel, height: 40)
        scrollView.parallaxHeader?.backgroundColor = UIColor.lightGray
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
