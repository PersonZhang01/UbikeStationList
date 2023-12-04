//
//  UIView+Extension.swift
//  UbikeStationList
//
//  Created by Person Zhang on 2023/12/1.
//

import Foundation
import UIKit

extension UIView {
    
    func setFrame(rect: CGRect? = nil) {
        guard let rect = rect else {
            self.frame = UIApplication.shared.nowkeyWindow?.frame ?? CGRect()
            return
        }
        self.frame = rect
    }
    
    func changeAlpha(_ withAlpha: CGFloat, duration: TimeInterval,delay: TimeInterval,completion:((UIViewAnimatingPosition)-> Void)?) {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: duration, delay: delay, animations: {
            self.alpha = withAlpha
        },completion: completion)
    }
    
    func setCircleCornerRadius() {
        self.layer.cornerRadius = self.frame.height*0.5
        self.clipsToBounds = true
    }
    
    func setView(withCornerRadius cornerRadius: CGFloat = 0,
                 borderColor: UIColor? = nil,
                 borderWidth: CGFloat = 0,
                 maskedCorners: CACornerMask = [.layerMaxXMaxYCorner,
                                                .layerMaxXMinYCorner,
                                                .layerMinXMaxYCorner,
                                                .layerMinXMinYCorner]) {
        self.layer.cornerRadius = cornerRadius
        self.layer.borderColor = borderColor?.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.maskedCorners = maskedCorners
        self.clipsToBounds = true
    }
}

extension UIView: NibProvidable {
    
}

