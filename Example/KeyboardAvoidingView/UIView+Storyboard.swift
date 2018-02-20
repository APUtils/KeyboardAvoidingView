//
//  UIView+Storyboard.swift
//  Copyright (c) Anton Plebanovich.
//

import UIKit

// ******************************* MARK: - Border

extension UIView {
    @IBInspectable var borderColor: UIColor? {
        get {
            guard let borderColor = layer.borderColor else { return nil }
            
            return UIColor(cgColor: borderColor)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var onePixelWidth: Bool {
        get {
            return layer.borderWidth == 1.0 / UIScreen.main.scale
        }
        set {
            if newValue {
                layer.borderWidth = 1.0 / UIScreen.main.scale
            } else {
                layer.borderWidth = 1.0
            }
        }
    }
}

// ******************************* MARK: - Corner Radius

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
}

// ******************************* MARK: - Shadow

extension UIView {
    @IBInspectable var shadowColor: UIColor? {
        get {
            guard let shadowColor = layer.shadowColor else { return nil }
            
            return UIColor(cgColor: shadowColor)
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var shadowOffset: CGPoint {
        get {
            return CGPoint(x: layer.shadowOffset.width, y: layer.shadowOffset.height)
        }
        set {
            layer.shadowOffset = CGSize(width: newValue.x, height: newValue.y)
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable var shadowApplyPath: Bool {
        get {
            return layer.shadowPath != nil
        }
        set {
            layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        }
    }
}
