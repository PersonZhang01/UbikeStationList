//
//  UIApplication+Extension.swift
//  UbikeStationList
//
//  Created by Person Zhang on 2023/12/1.
//

import Foundation
import UIKit

extension UIApplication {
    var nowkeyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first
    }
}
