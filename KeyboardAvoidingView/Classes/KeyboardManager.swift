//
//  KeyboardManager.swift
//  APExtensions
//
//  Created by mac-246 on 2/16/18.
//  Copyright © 2018 Anton Plebanovich. All rights reserved.
//

import UIKit


#if DEBUG
    private let c_debugWork = false
#else
    private let c_debugWork = false
#endif


private let c_screenBounds = UIScreen.main.bounds
private let c_hiddenKeyboardFrame = CGRect(x: 0, y: c_screenBounds.height, width: c_screenBounds.width, height: 0)


/// Listener protocol
@objc public protocol KeyboardControllerListener: class {
    /// Called every time keyboard frame is changed.
    /// - parameters:
    ///   - frame: New keyboard overlapping frame.
    ///   - duration: Keyboard animation duration.
    ///   - animationOptions: Keyboard animation options.
    func keyboard(willChangeOverlappingFrame frame: CGRect, duration: Double, animationOptions: UIView.AnimationOptions)
}

/// Manager that observes keyboard frame.
public class KeyboardManager: NSObject {
    
    // ******************************* MARK: - Class Properties
    
    @objc public static let shared = KeyboardManager()
    
    // ******************************* MARK: - Public Properties
    
    /// Is keyboard shown?
    public var isKeyboardShown: Bool {
        let screenBounds = c_screenBounds
        let intersection = screenBounds.intersection(keyboardFrame)
        return !intersection.isNull
    }
    
    /// Current keyboard overlapping rect
    public var keyboardOverlappingFrame: CGRect {
        let screenBounds = c_screenBounds
        let intersection = screenBounds.intersection(keyboardFrame)
        if intersection.isNull {
            return c_hiddenKeyboardFrame
        } else {
            return intersection
        }
    }
    
    /// Current keyboard overlapping height
    public var keyboardOverlappingHeight: CGFloat {
        return keyboardFrame.height
    }
    
    // ******************************* MARK: - Private Properties
    
    private var listeners = NSHashTable<KeyboardControllerListener>(options: [.weakMemory])
    
    /// Current keyboard frame
    private var keyboardFrame: CGRect = c_hiddenKeyboardFrame
    
    // ******************************* MARK: - Public Methods
    
    /// Adds keyboard frame change listener. Returns current value immediatelly and then reports any changes. Listener is removed on dealloc.
    /// - parameters:
    ///   - listener: Listener to add.
    public func addListener(_ listener: KeyboardControllerListener) {
        listeners.add(listener)
    }
    
    /// Removes listener.
    /// - parameters:
    ///   - listener: Listener to remove.
    public func removeListener(_ listener: KeyboardControllerListener) {
        listeners.remove(listener)
    }
    
    // ******************************* MARK: - Initialization and Setup
    
    private override init() {
        super.init()
        
        setup()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setup() {
        setupNotifications()
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    // ******************************* MARK: - Private Methods - Notifications
    
    @objc private func onKeyboardWillChangeFrame(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        guard keyboardEndFrame != keyboardFrame else { return }
        if c_debugWork { print("KeyboardManager: frame will change to \(keyboardEndFrame)") }
        
        let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions().rawValue
        let animationCurve: UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
        let options: UIView.AnimationOptions = [animationCurve, .beginFromCurrentState]
        
        keyboardFrame = keyboardEndFrame
        listeners.allObjects.forEach { $0.keyboard(willChangeOverlappingFrame: keyboardOverlappingFrame, duration: duration, animationOptions: options) }
    }
}
