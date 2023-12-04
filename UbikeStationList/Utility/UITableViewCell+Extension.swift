//
//  UITableViewCell+Extension.swift
//  UbikeStationList
//
//  Created by Person Zhang on 2023/12/1.
//

import Foundation
import UIKit

extension UITableViewCell : Reusable {
    var tableView: UITableView? {
        return self.next(of: UITableView.self)
    }
    
    var indexPath: IndexPath? {
        return self.tableView?.indexPath(for: self)
    }
}
