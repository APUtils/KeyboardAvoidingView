//
//  KeyboardManager.swift
//  APExtensions
//
//  Created by mac-246 on 2/16/18.
//  Copyright © 2018 Anton Plebanovich. All rights reserved.
//

import ViewState
import UIKit

#if DEBUG
private let c_debugWork = false
#else
private let c_debugWork = false
#endif

/// Listener protocol
@objc public protocol KeyboardControllerListener: AnyObject {
    /// Called every time keyboard frame is changed.
    /// - parameters:
    ///   - frame: New keyboard overlapping frame.
    ///   - duration: Keyboard animation duration.
    ///   - animationOptions: Keyboard animation options.
    func keyboard(willChangeOverlappingFrame frame: CGRect, duration: Double, animationOptions: UIView.AnimationOptions)
}

/// Manager that observes keyboard frame.
public class KeyboardManager: NSObject {
    
    // ******************************* MARK: - Private
    
    private var hiddenKeyboardFrame: CGRect {
        CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 0)
    }
    
    // ******************************* MARK: - Class Properties
    
    @objc public static let shared = KeyboardManager()
    
    // ******************************* MARK: - Public Properties
    
    /// Disable/enable animations. Default is `true` - animations enabled.
    public var animate = true
    
    /// Is keyboard shown?
    public var isKeyboardShown: Bool {
        let screenBounds = UIScreen.main.bounds
        let intersection = UIScreen.main.bounds.intersection(keyboardFrame)
        return !intersection.isNull
    }
    
    /// Current keyboard overlapping rect
    public var keyboardOverlappingFrame: CGRect {
        let screenBounds = UIScreen.main.bounds
        let intersection = UIScreen.main.bounds.intersection(keyboardFrame)
        if intersection.isNull {
            return hiddenKeyboardFrame
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
    private lazy var keyboardFrame: CGRect = hiddenKeyboardFrame
    
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
        ViewState.setupOnce()
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
        let animationOptions: UIView.AnimationOptions = [animationCurve, .beginFromCurrentState]
        
        keyboardFrame = keyboardEndFrame
        
        let allObjects = listeners.allObjects
        let keyboardAvoidingViews = allObjects.compactMap { $0 as? KeyboardAvoidingView }
        let otherViews = allObjects.filter { !($0 is KeyboardAvoidingView) }
        let changes: () -> Void = { [self] in
            keyboardAvoidingViews.forEach { $0.keyboard(willChangeOverlappingFrame: keyboardOverlappingFrame, duration: duration, animationOptions: animationOptions) }
            otherViews.forEach { $0.keyboard(willChangeOverlappingFrame: keyboardOverlappingFrame, duration: duration, animationOptions: animationOptions) }
        }
        
        let hasWindow = keyboardAvoidingViews.reduce(false) { $0 || $1.window != nil }
        
        let acriveViewControllers = keyboardAvoidingViews
            .compactMap { $0._viewController }
            .filter { $0.viewState == .didAppear }
        
        let hasActiveViewController = !acriveViewControllers.isEmpty
        
        // Animate only .didAppear state to prevent broken transitions.
        if animate && hasWindow && hasActiveViewController, duration > 0 {
            
            // Stop scrolling if needed
            keyboardAvoidingViews
                .flatMap { $0.allSubviews }
                .compactMap { $0 as? UIScrollView }
                .forEach { $0.stopScrolling() }
            
            // Assure view layouted before animations start
            acriveViewControllers.forEach { $0.mainParent.view.layoutIfNeeded() }
            UIView.animate(withDuration: duration, delay: 0, options: animationOptions, animations: {
                changes()
                acriveViewControllers.forEach { $0.mainParent.view.layoutIfNeeded() }
            }, completion: nil)
            
        } else {
            changes()
        }
    }
}
