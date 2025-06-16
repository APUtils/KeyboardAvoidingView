//
//  UIView+Utils.swift
//  KeyboardAvoidingView
//
//  Created by Anton Plebanovich on 8/8/17.
//  Copyright © 2017 Anton Plebanovich. All rights reserved.
//

import UIKit


extension UIView {
    /// All view superviews to the top most
    #if compiler(<5)
    var _superviews: AnySequence<UIView> {
        return sequence(first: self, next: { $0.superview }).dropFirst(1)
    }
    #else
    var _superviews: DropFirstSequence<UnfoldSequence<UIView, (UIView?, Bool)>> {
        return sequence(first: self, next: { $0.superview }).dropFirst(1)
    }
    #endif
    
    /// Returns all view's subviews
    var _allSubviews: [UIView] {
        var allSubviews = self.subviews
        allSubviews.forEach { allSubviews.append(contentsOf: $0._allSubviews) }
        return allSubviews
    }
    
    var _viewController: UIViewController? {
        var nextResponder: UIResponder? = self
        while nextResponder != nil {
            nextResponder = nextResponder?.next
            
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
        }
        
        return nil
    }
}


extension UIViewController {
    var _mainParent: UIViewController {
        return parent?._mainParent ?? self
    }
}

extension UIScrollView {
    
    /// Stops current scroll
    func _stopScrolling() {
        setContentOffset(contentOffset, animated: false)
    }
}
