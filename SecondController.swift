//
//  SecondController.swift
//  VGParallaxHeader
//
//  Created by 伯驹 黄 on 2017/1/20.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class SecondController: UITableViewController {

    var arrayDataSource: ArrayDataSource<String>?

    let headerView = HeaderView()

    override func viewDidLoad() {
        super.viewDidLoad()

        headerView.backgroundColor = UIColor(red: 0.59, green: 0.85, blue: 0.27, alpha: 1)
        tableView.parallaxHeaderView(headerView, mode: .topFill, height: 200)

        let photos = (0 ... 20).map { $0.description }
        arrayDataSource = ArrayDataSource(items: photos, cellIdentifier: "cell") { cell, item in
            cell.textLabel?.text = item
        }
        tableView.dataSource = arrayDataSource
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        //        automaticallyAdjustsScrollViewInsets = false
        edgesForExtendedLayout = [] // 解决tabbar遮挡tableview,但是会导致选中这个页面时tabbar变灰，在Appdelegate做window?.backgroundColor = UIColor.white，即可修复
        //        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let ratio = fmaxf(0, Float(scrollView.parallaxHeader!.progress) - 1)
        let firstColor = UIColor(red: 0.59, green: 0.85, blue: 0.27, alpha: 1)
        let secondColor = UIColor(red: 0.86, green: 0.09, blue: 0.13, alpha: 1)
        headerView.backgroundColor = UIColor(forFadeBetweenFirstColor: firstColor, secondColor: secondColor, atRatio: CGFloat(ratio))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        print("🍀")
    }
}
