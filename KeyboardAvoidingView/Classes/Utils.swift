//
//  Utils.swift
//  KeyboardAvoidingView
//
//  Created by Anton Plebanovich on 2/15/18.
//  Copyright © 2018 Anton Plebanovich. All rights reserved.
//

import UIKit

var _g_visibleKeyboardHeight: CGFloat {
    var keyboardWindow: UIWindow! = nil
    for window in UIApplication.shared.windows {
        if type(of: window) != UIWindow.self {
            keyboardWindow = window
            break
        }
    }
    
    guard keyboardWindow != nil else { return 0 }
    
    for view in keyboardWindow.subviews {
        let viewClassString = NSStringFromClass(type(of: view))
        guard viewClassString.hasPrefix("UI") else { continue }
        
        if viewClassString.hasSuffix("PeripheralHostView") || viewClassString.hasSuffix("Keyboard") {
            return view.bounds.height
        } else if viewClassString.hasSuffix("InputSetContainerView") {
            for subview in view.subviews {
                let subviewClassString = NSStringFromClass(type(of: subview))
                guard subviewClassString.hasPrefix("UI") && subviewClassString.hasSuffix("InputSetHostView") else { continue }
                let keyboardInRootRect = keyboardWindow!.convert(subview.frame, from: view)
                
                return keyboardInRootRect.intersection(keyboardWindow!.bounds).height
            }
        }
    }
    
    return 0
}
