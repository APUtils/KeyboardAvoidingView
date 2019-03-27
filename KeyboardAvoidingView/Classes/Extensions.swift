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
    var mainParent: UIViewController {
        return parent?.mainParent ?? self
    }
}
