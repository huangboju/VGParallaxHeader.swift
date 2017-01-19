//
//  ViewController.swift
//  VGParallaxHeader
//
//  Created by 伯驹 黄 on 2017/1/19.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var arrayDataSource: ArrayDataSource<String>?

    private lazy var headerView: UIView = {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200))
        let textLabel = UILabel(frame: CGRect(x: 0, y: 80, width: self.view.frame.width, height: 50))
        textLabel.text = "Hello Ladier..."
        textLabel.textAlignment = .center
        textLabel.font = UIFont.systemFont(ofSize: 30)
        textLabel.textColor = .white
        headerView.addSubview(textLabel)
        headerView.backgroundColor = UIColor(red: 1, green: 0.5, blue: 1, alpha: 1)
        return headerView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        let stickyLabel = UILabel(frame: .zero)
        stickyLabel.backgroundColor = UIColor(red: 1, green: 0.749, blue: 0.976, alpha: 1)
        stickyLabel.textAlignment = .center
        stickyLabel.text = "Say hello to Sticky View :)"

        tableView.parallaxHeaderView(headerView, mode: .fill, height: 200)
        tableView.parallaxHeader?.stickyViewPosition = .top
        tableView.parallaxHeader?.setStickyView(stickyView: stickyLabel, height: 40)

        tableView.tableFooterView = UIView()

        let photos = (0 ... 20).map { $0.description }
        arrayDataSource = ArrayDataSource(items: photos, cellIdentifier: "cell") { (cell, item) in
            cell.textLabel?.text = item
        }
        tableView.dataSource = arrayDataSource
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tableView.shouldPositionParallaxHeader()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
