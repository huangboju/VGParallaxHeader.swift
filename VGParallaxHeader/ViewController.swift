//
//  ViewController.swift
//  VGParallaxHeader
//
//  Created by 伯驹 黄 on 2017/1/19.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class ViewController: UITableViewController {

    var arrayDataSource: ArrayDataSource<String>?

    override func viewDidLoad() {
        super.viewDidLoad()

        let stickyLabel = UILabel(frame: .zero)
        stickyLabel.backgroundColor = UIColor(red: 1, green: 0.749, blue: 0.976, alpha: 1)
        stickyLabel.textAlignment = .center
        stickyLabel.text = "Say hello to Sticky View :)"
        tableView.parallaxHeaderView(HeaderView(), mode: .fill, height: 200, maxOffsetY: 120)
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(SecondController(), animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
