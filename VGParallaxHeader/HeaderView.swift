//
//  HeaderView.swift
//  VGParallaxHeader
//
//  Created by 伯驹 黄 on 2017/1/20.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class HeaderView: UIView {
    init(image: UIImage? = nil) {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200))
        backgroundColor = UIColor(red: 1, green: 0.5, blue: 1, alpha: 1)

        if let image = image {
            let imageView = UIImageView(image: image)
            addSubview(imageView)
            imageView.contentMode = .scaleAspectFill
            // autoresizingMask http://www.cnblogs.com/GarveyCalvin/p/4165151.html
            //            imageView.autoresizingMask = [
            //                .flexibleLeftMargin,
            //                .flexibleRightMargin,
            //                .flexibleTopMargin,
            //                .flexibleBottomMargin,
            //                .flexibleHeight,
            //                .flexibleWidth
            //            ]
            // 使用上面的方法也能实现图片下拉放大，但是图片缩放比例不对
            imageView.autoPinEdgesToSuperviewEdges()
        }

        let descLable = UILabel()
        descLable.text = "My position is fixed"
        descLable.textAlignment = .center
        descLable.font = UIFont.systemFont(ofSize: 14)
        descLable.textColor = .white
        addSubview(descLable)

        descLable.autoAlignAxis(.vertical, toSameAxisOf: self)
        descLable.autoPinEdge(.leading, to: .leading, of: self, withOffset: 15)
        descLable.autoPinEdge(.top, to: .top, of: self, withOffset: 50)

        let textLabel = UILabel()
        textLabel.text = "Hello Ladier..."
        textLabel.textAlignment = .center
        textLabel.font = UIFont.systemFont(ofSize: 30)
        textLabel.textColor = .white
        addSubview(textLabel)

        textLabel.autoCenterInSuperview()
        textLabel.autoPinEdge(.leading, to: .leading, of: descLable)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
