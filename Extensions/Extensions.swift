//
//  Extencions.swift
//  RaceGame
//
//  Created by Dmitry Divin on 1.12.25.
//

import UIKit

extension UIView {
    
    func roundCorners(radius: CGFloat) {
        layer.cornerRadius = radius
    }
    func dropShadow(radius: CGFloat = 0) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 5, height: 0)
        layer.shadowRadius = 5
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
        layer.shouldRasterize = true
    }
}
