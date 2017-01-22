//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import UIKit
import PureLayout

enum VGParallaxHeaderMode {
    case center
    case fill /// 拉伸效果，上滑时会跟随UIScrollView偏移
    case top
    case topFill /// 拉伸效果，上滑时不会跟随UIScrollView偏移
}

enum VGParallaxHeaderStickyViewPosition {
    case bottom, top
}

enum VGParallaxHeaderShadowBehaviour {
    case vhidden, appearing, disappearing, always
}

extension UIScrollView {
    
    func parallaxHeaderView(_ view: UIView, mode: VGParallaxHeaderMode, height: CGFloat, shadowBehaviour: VGParallaxHeaderShadowBehaviour) {
        parallaxHeaderView(view, mode: mode, height: height)
    }
    
    func parallaxHeaderView(_ view: UIView, mode: VGParallaxHeaderMode, height: CGFloat, maxOffsetY: CGFloat = .infinity) {
        parallaxHeader = VGParallaxHeader(scrollView: self, contentView: view, mode: mode, height: height, maxOffsetY: maxOffsetY)
        
        shouldPositionParallaxHeader()
        
        // If UIScrollView adjust inset
        if !parallaxHeader!.insideTableView {
            var selfContentInset = contentInset
            selfContentInset.top += height
            
            contentInset = selfContentInset
            contentOffset = CGPoint(x: 0, y: -selfContentInset.top)
        }
        
        // Watch for inset changes
        if let parallaxHeader = parallaxHeader {
            addObserver(parallaxHeader, forKeyPath: "contentInset", options: .new, context: nil)
            addObserver(parallaxHeader, forKeyPath: "contentOffset", options: [.new, .old], context: nil)
        }
    }
    
    func updateParallaxHeaderViewHeight(height: CGFloat) {
        var newContentInset: CGFloat = 0
        var selfContentInset = contentInset
        guard let headerHeight = parallaxHeader?.headerHeight else {
            return
        }
        if height < headerHeight {
            newContentInset = headerHeight - height
            selfContentInset.top -= newContentInset
        } else {
            newContentInset = height - headerHeight
            selfContentInset.top += newContentInset
        }
        
        contentInset = selfContentInset
        contentOffset = CGPoint(x: 0, y: -selfContentInset.top)
        
        parallaxHeader?.headerHeight = height
        parallaxHeader?.setNeedsLayout()
    }
    
    fileprivate func shouldPositionParallaxHeader() {
        if parallaxHeader!.insideTableView {
            positionTableViewParallaxHeader()
        } else {
            positionScrollViewParallaxHeader()
        }
    }
    
    func positionTableViewParallaxHeader() {
        let y = contentOffset.y
        let scaleProgress = fmaxf(0, (1 - (Float((contentOffset.y + parallaxHeader!.originalTopInset) / parallaxHeader!.originalHeight))))
        parallaxHeader?.progress = CGFloat(scaleProgress)
        
        if y < parallaxHeader!.maxOffsetY {
            contentOffset.y = parallaxHeader!.maxOffsetY
            return
        }
        
        if y < parallaxHeader!.originalHeight {
            // We can move height to if here because its uitableview
            var height = -y + parallaxHeader!.originalHeight
            // Im not 100% sure if this will only speed up VGParallaxHeaderModeCenter
            // but on other modes it can be visible. 0.5px
            if parallaxHeader!.mode == .center {
                height = round(height)
            }
            // This is where the magic is happening
            parallaxHeader?.containerView?.frame = CGRect(x: 0, y: y, width: frame.width, height: height)
        }
    }
    
    func positionScrollViewParallaxHeader() {
        let y = contentOffset.y
        let height = -y
        let scaleProgress = fmaxf(0, Float((height / (parallaxHeader!.originalHeight + parallaxHeader!.originalTopInset))))
        parallaxHeader?.progress = CGFloat(scaleProgress)
        
        if y < parallaxHeader!.maxOffsetY {
            contentOffset.y = parallaxHeader!.maxOffsetY
            return
        }
        
        if y < 0 {
            // This is where the magic is happening
            parallaxHeader?.frame = CGRect(x: 0, y: y, width: frame.width, height: height)
        }
    }
    
    struct AssociatedKeys {
        static var UIScrollViewVGParallaxHeader = "UIScrollViewVGParallaxHeader"
    }
    
    var parallaxHeader: VGParallaxHeader? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.UIScrollViewVGParallaxHeader) as? VGParallaxHeader
        }
        
        set {
            // Remove All Subviews
            for subview in subviews where subview.isMember(of: VGParallaxHeader.self) {
                subview.removeFromSuperview()
            }
            
            newValue?.insideTableView = isKind(of: UITableView.self)
            
            // Add Parallax Header
            if newValue!.insideTableView {
                (self as? UITableView)?.tableHeaderView = newValue
                newValue?.setNeedsLayout()
            } else {
                addSubview(newValue!)
            }
            
            objc_setAssociatedObject(self, &AssociatedKeys.UIScrollViewVGParallaxHeader, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
}

class VGParallaxHeader: UIView {
    var mode: VGParallaxHeaderMode?
    
    /// Default is top
    var stickyViewPosition: VGParallaxHeaderStickyViewPosition = .top {
        didSet {
            updateStickyViewConstraints()
        }
    }
    
    var stickyViewHeightConstraint: NSLayoutConstraint? {
        didSet {
            if let stickyViewHeightConstraint = stickyViewHeightConstraint {
                stickyView?.removeConstraint(stickyViewHeightConstraint)
                if stickyView?.superview === containerView {
                    stickyView?.addConstraint(stickyViewHeightConstraint)
                }
            }
        }
    }
    
    var stickyView: UIView? {
        didSet {
            if let stickyView = stickyView {
                stickyView.translatesAutoresizingMaskIntoConstraints = false
                containerView?.insertSubview(stickyView, aboveSubview: contentView!)
                updateStickyViewConstraints()
            }
        }
    }
    
    var insideTableView = false
    var progress: CGFloat = 0
    var shadowBehaviour: VGParallaxHeaderShadowBehaviour?
    
    var containerView: UIView!
    var contentView: UIView!
    
    var scrollView: UIScrollView?
    
    var originalTopInset: CGFloat = 0
    var originalHeight: CGFloat = 0
    
    var headerHeight: CGFloat?
    var maxOffsetY: CGFloat = 0
    
    var insetAwarePositionConstraint: NSLayoutConstraint?
    var insetAwareSizeConstraint: NSLayoutConstraint?
    var stickyViewContraints: [NSLayoutConstraint]?
    
    init(scrollView: UIScrollView, contentView: UIView, mode: VGParallaxHeaderMode, height: CGFloat, maxOffsetY: CGFloat) {
        super.init(frame: CGRect(x: 0, y: 0, width: scrollView.bounds.width, height: height))
        
        self.mode = mode
        
        self.scrollView = scrollView
        
        headerHeight = height
        originalHeight = height
        
        self.maxOffsetY = min(maxOffsetY, -maxOffsetY)
        
        containerView = UIView(frame: bounds)
        containerView?.clipsToBounds = true
        
        if !insideTableView {
            containerView?.autoresizingMask = [
                .flexibleHeight,
                .flexibleWidth
            ]
        }
        
        addSubview(containerView!)
        self.contentView = contentView
        self.contentView?.translatesAutoresizingMaskIntoConstraints = false
        self.containerView?.addSubview(self.contentView!)
        setupContentViewMode()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupContentViewMode() {
        switch mode! {
        case .fill:
            addContentViewModeFillConstraints()
        case .top:
            addContentViewModeTopConstraints()
        case .topFill:
            addContentViewModeTopFillConstraints()
        case .center:
            addContentViewModeCenterConstraints()
        }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentInset" {
            if let change = change {
                if let edgeInsets = (change[.newKey] as AnyObject).uiEdgeInsetsValue {
                    maxOffsetY -= edgeInsets.top // 控制最大下拉距离，只能在这里设置
                    originalTopInset = edgeInsets.top - (insideTableView ? 0 : originalHeight)
                    switch mode! {
                    case .fill:
                        insetAwarePositionConstraint?.constant = originalTopInset / 2
                        insetAwareSizeConstraint?.constant = -originalTopInset
                    case .top:
                        insetAwarePositionConstraint?.constant = originalTopInset
                    case .topFill:
                        insetAwarePositionConstraint?.constant = originalTopInset
                        insetAwareSizeConstraint?.constant = -originalTopInset
                    case .center:
                        insetAwarePositionConstraint?.constant = originalTopInset / 2
                    }
                    if !insideTableView {
                        scrollView?.contentOffset = CGPoint(x: 0, y: -scrollView!.contentInset.top)
                    }
                }
            }
            updateStickyViewConstraints()
        }  else if keyPath == "contentOffset" {
            let y = (change?[.newKey] as AnyObject).cgPointValue.y
            if y > originalHeight - originalTopInset {
                return
            }
            (object as? UIScrollView)?.shouldPositionParallaxHeader()
        }
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        if let superview = superview, newSuperview == nil {
            if superview.responds(to: #selector(getter: UIScrollView.contentInset)) {
                superview.removeObserver(self, forKeyPath: "contentInset")
            }
        }
    }
    
    // MARK: - VGParallaxHeader (Auto Layout)
    func addContentViewModeFillConstraints() {
        contentView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
        contentView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
        
        insetAwarePositionConstraint = contentView.autoAlignAxis(.horizontal, toSameAxisOf: containerView!, withOffset: originalTopInset / 2)
        let constraint = contentView.autoSetDimension(.height, toSize: originalHeight, relation: .greaterThanOrEqual)
        constraint.priority = UILayoutPriorityRequired
        
        insetAwareSizeConstraint = contentView.autoMatch(.height, to: .height, of: containerView!, withOffset: -originalTopInset)
        
        insetAwareSizeConstraint?.priority = UILayoutPriorityDefaultHigh
    }
    
    func addContentViewModeTopConstraints() {
        let array = contentView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: originalTopInset, left: 0, bottom: 0, right: 0), excludingEdge: .bottom)
        insetAwarePositionConstraint = array.first
        
        contentView.autoSetDimension(.height, toSize: originalHeight)
    }

    func addContentViewModeTopFillConstraints() {
        insetAwarePositionConstraint = contentView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: originalTopInset, left: 0, bottom: 0, right: 0), excludingEdge: .bottom).first
        
        let constraint = contentView.autoSetDimension(.height, toSize: originalHeight, relation: .greaterThanOrEqual)
        constraint.priority = UILayoutPriorityRequired
        
        insetAwareSizeConstraint = contentView.autoMatch(.height, to: .height, of: containerView!, withOffset: -originalTopInset)
        
        insetAwareSizeConstraint?.priority = UILayoutPriorityDefaultHigh
    }
    
    func addContentViewModeCenterConstraints() {
        contentView.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
        contentView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
        contentView.autoSetDimension(.height, toSize: originalHeight)
        
        insetAwarePositionConstraint = contentView.autoAlignAxis(.horizontal, toSameAxisOf: containerView!, withOffset: round(originalTopInset / 2))
    }
    
    // MARK: - VGParallaxHeader (Sticky View)
    func setStickyView(stickyView: UIView, height: CGFloat) {
        self.stickyView = stickyView
        stickyViewHeightConstraint = stickyView.autoSetDimension(.height, toSize: height)
    }
    
    func updateStickyViewConstraints() {
        if let superview = stickyView?.superview {
            if superview.isEqual(containerView) {
                var nonStickyEdge: ALEdge!
                switch stickyViewPosition {
                case .top:
                    nonStickyEdge = .bottom
                case .bottom:
                    nonStickyEdge = .top
                }
                
                // Remove Previous Constraints
                if let stickyViewContraints = stickyViewContraints {
                    stickyView?.removeConstraints(stickyViewContraints)
                    containerView?.removeConstraints(stickyViewContraints)
                }
                
                // Add Constraints
                stickyViewContraints = stickyView?.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: originalTopInset, left: 0, bottom: 0, right: 0), excludingEdge: nonStickyEdge)
            }
        }
    }
    
    deinit {
        removeObserver(self, forKeyPath: "contentInset")
        removeObserver(self, forKeyPath: "contentOffset")
    }
}
