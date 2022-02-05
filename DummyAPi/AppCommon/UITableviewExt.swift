//
//  UITableview.swift
//  MyHealthTracker
//
//  Created by Maulik on 22/05/20.
//  Copyright © 2020 Lets Explore. All rights reserved.
//

 
public extension UITableView {
    func register<T: UITableViewCell>(cellType: T.Type, bundle: Bundle? = nil) {
        let className = cellType.className
        let nib = UINib(nibName: className, bundle: bundle)
        register(nib, forCellReuseIdentifier: className)
    }
    
    func register<T: UITableViewCell>(cellTypes: [T.Type], bundle: Bundle? = nil) {
        cellTypes.forEach { register(cellType: $0, bundle: bundle) }
    }
    
    
    func dequeueReusableCell<T: UITableViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: type.className, for: indexPath) as! T
    }
    
    /* use like this
    tableView.register(cellType: MyCell.self)
    tableView.register(cellTypes: [MyCell1.self, MyCell2.self])

    let cell = tableView.dequeueReusableCell(with: MyCell.self, for: indexPath)
    */
}


// Dyanmic tableview

@objc class DynamicSizeTableView: UITableView
{
//    public var maxHeight = CGFloat.infinity
//    override public var contentSize: CGSize {
//        didSet {
//            invalidateIntrinsicContentSize()
//            setNeedsLayout()
//        }
//    }
//
//    override public var intrinsicContentSize: CGSize {
//        let height = min(maxHeight, contentSize.height)
//        return CGSize(width: contentSize.width, height: height)
//    }
    
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}




 
public extension NSObject {
    
    static var className: String {
        get {
            return String(describing: self)
        }
    }
}


public extension String {
    func toJsonObject() -> Any? {
        if let data = self.data(using: .utf8) {
            return try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
        }
        return nil
    }
}
