//
//  KeyboardAvoidingView.swift
//  Copyright (c) Anton Plebanovich.
//

import UIKit

#if CARTHAGE
    import APExtensionsViewState
#else
    import APExtensions
#endif


private let c_screenBounds = UIScreen.main.bounds

// TODO: Allow bottom constraint to point to other views
// TODO: Add UIViewController viewState processing and react accordingly.

/// Configures bottom constraint constant or frame height to avoid keyboard.
/// Bottom constraint should be added to Layout Guide or superview bottom.
public class KeyboardAvoidingView: UIView {
    
    // ******************************* MARK: - Public Properties
    
    /// Disable/enable resize back when keyboard dismiss. Might be helpful for some animations.
    /// Default is `true` - default constant will be restored.
    @IBInspectable public var restoreDefaultConstant: Bool = true
    
    /// Disable/enable animations. Default is `true` - animations enabled.
    public var animate = true
    
    /// Disable reaction to keyboard notifications. Default is `false` - view is reacting to keyobard notifications.
    public var disable = false
    
    // ******************************* MARK: - Private properties
    
    private var bottomConstraint: NSLayoutConstraint?
    private var defaultConstant: CGFloat?
    private var defaultHeight: CGFloat?
    private var previousKeyboardFrame: CGRect?
    
    private var layoutGuideHeight: CGFloat? {
        if let layoutGuide = bottomConstraint?.firstItem as? UILayoutSupport {
            return layoutGuide.length
        } else if let layoutGuide = bottomConstraint?.secondItem as? UILayoutSupport {
            return layoutGuide.length
        } else {
            // Safe area support
            if #available(iOS 9.0, *) {
                let getLayoutHeight: (UILayoutGuide) -> (CGFloat?) = { layoutGuide in
                    guard let owningView = layoutGuide.owningView else { return nil }
                    let rootRect = owningView.convert(layoutGuide.layoutFrame, to: UIScreen.main.coordinateSpace)
                    return c_screenBounds.height - rootRect.maxY
                }
                
                if let layoutGuide = bottomConstraint?.firstItem as? UILayoutGuide {
                    return getLayoutHeight(layoutGuide)
                } else if let layoutGuide = bottomConstraint?.secondItem as? UILayoutGuide {
                    return getLayoutHeight(layoutGuide)
                }
            }
        }
        
        return nil
    }
    
    private var isConstraintsAligned: Bool {
        return bottomConstraint != nil
    }
    
    private var isInverseOrder: Bool? {
        guard let firstItem = bottomConstraint?.firstItem else { return nil }
        
        return firstItem === self
    }
    
    // ******************************* MARK: - Initialization and Setup
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    private func setup() {
        KeyboardManager.shared.addListener(self)
        setupNotifications()
    }
    
    private func setupNotifications() {
        if let vc = _viewController {
            NotificationCenter.default.addObserver(self, selector: #selector(onViewStateDidChange(_:)), name: .UIViewControllerViewStateDidChange, object: vc)
        }
    }
    
    // ******************************* MARK: - Public Methods
    
    /// Set bottom constraint or frame height to default value
    public func resetToDefault() {
        if let defaultConstant = defaultConstant {
            bottomConstraint?.constant = defaultConstant
            _viewController?.view.layoutIfNeeded()
        } else if let defaultHeight = defaultHeight {
            frame.size.height = defaultHeight
        }
    }
    
    // ******************************* MARK: - Configuration
    
    private func configureSize() {
        configureSize(keyboardOverlappingFrame: KeyboardManager.shared.keyboardOverlappingFrame, duration: nil, animationOptions: nil)
    }
    
    private func configureSize(keyboardOverlappingFrame frame: CGRect, duration: Double?, animationOptions: UIView.AnimationOptions?) {
        getDefaultValuesIfNeeded()
        
        // Support only views that has viewControllers for now
        guard let viewController = _viewController else { return }
        
        // Do not adjust for .notLoaded and .didLoad because will be adjusted in willAppear
        // Do not adjust for .willDisappear and .didDisappear for better disappear animation
        guard viewController.viewState == .didAppear || viewController.viewState == .willAppear || viewController.viewState == .didAttach else { return }
        
        // Animate only .didAppear state to prevent broken transitions.
        if animate && window != nil && viewController.viewState == .didAppear, let duration = duration, let animationOptions = animationOptions {
            // Assure view layouted before animations start
            let vcView = viewController.mainParent.view
            vcView?.layoutIfNeeded()
            UIView.animate(withDuration: duration, delay: 0, options: animationOptions, animations: {
                self.updateSize(keyboardOverlappingFrame: frame)
                vcView?.layoutIfNeeded()
            }, completion: nil)
        } else {
            updateSize(keyboardOverlappingFrame: frame)
        }
    }
    
    private func updateSize(keyboardOverlappingFrame: CGRect) {
        if self.isConstraintsAligned, let defaultConstant = self.defaultConstant, let bottomConstraint = self.bottomConstraint, let isInverseOrder = self.isInverseOrder, let superview = self.superview {
            // Setup with bottom constraint constant
            let superviewFrameInRoot = superview.convert(superview.bounds, to: UIScreen.main.coordinateSpace)
            let keyboardOverlapSuperviewHeight = superviewFrameInRoot.maxY - keyboardOverlappingFrame.minY - (self.layoutGuideHeight ?? 0)
            var newConstant = max(keyboardOverlapSuperviewHeight, defaultConstant)
            if !self.restoreDefaultConstant {
                newConstant = max(bottomConstraint.constant, newConstant)
            }
            
            // Preventing modal view disappear constraint crashes.
            // Assuming we'll never need to set bottom constraint constant more than half of the screen height.
            newConstant = min(newConstant, UIScreen.main.bounds.height / 2)
            newConstant = isInverseOrder ? -newConstant : newConstant
            bottomConstraint.constant = newConstant
            
        } else if let defaultHeight = self.defaultHeight {
            // Setup with frame height
            let frameInRoot = convert(bounds, to: UIScreen.main.coordinateSpace)
            let visibleHeight = keyboardOverlappingFrame.minY - frameInRoot.minY
            let newHeight = min(visibleHeight, defaultHeight)
            
            self.frame.size.height = newHeight
        }
    }
    
    // ******************************* MARK: - UIView Overrides
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        configureSize()
    }
    
    // Make keyboard avoiding view transparent for touches
    override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let result = super.hitTest(point, with: event)
        if result == self { return nil }
        
        return result
    }
    
    // ******************************* MARK: - Private Methods - Notifications
    
    @objc private func onViewStateDidChange(_ notification: Notification) {
        // Assure view frame configured before appear
        guard let viewState = notification.userInfo?["viewState"] as? UIViewController.ViewState else { return }
        guard viewState == .willAppear else { return }
        
        configureSize()
    }
    
    // ******************************* MARK: - Private Methods
    
    private func getDefaultValuesIfNeeded() {
        guard bottomConstraint == nil && defaultHeight == nil else { return }
        
        if let newBottomConstraint = getBottomConstraint() {
            bottomConstraint = newBottomConstraint
            defaultConstant = newBottomConstraint.constant
        } else if defaultHeight == nil {
            defaultHeight = frame.height
        }
    }
    
    private func getBottomConstraint() -> NSLayoutConstraint? {
        for superview in _superviews {
            let constraints = superview.constraints
            for constraint in constraints {
                if (constraint.firstItem === self && constraint.secondItem === superview) || (constraint.secondItem === self && constraint.firstItem === superview) {
                    // Constraint from superview to view. Check if it is bottom constraint.
                    if constraint.firstAttribute == .bottom && constraint.secondAttribute == .bottom {
                        // Return
                        return constraint
                    }
                } else if constraint.firstItem === self && constraint.secondItem is UILayoutSupport {
                    // Constraint from view to layout guide. Check if it is bottom constraint.
                    if constraint.firstAttribute == .bottom {
                        return constraint
                    }
                } else if constraint.secondItem === self && constraint.firstItem is UILayoutSupport {
                    // Constraint from layout guide to view. Check if it is bottom constraint.
                    if constraint.secondAttribute == .bottom {
                        return constraint
                    }
                } else {
                    // Safe area support
                    if #available(iOS 9.0, *) {
                        if constraint.firstItem === self && constraint.secondItem is UILayoutGuide {
                            // Constraint from view to safe area. Check if it is bottom constraint.
                            if constraint.firstAttribute == .bottom {
                                return constraint
                            }
                        } else if constraint.secondItem === self && constraint.firstItem is UILayoutGuide {
                            // Constraint from safe area to view. Check if it is bottom constraint.
                            if constraint.secondAttribute == .bottom {
                                return constraint
                            }
                        }
                    }
                }
            }
        }
        
        return nil
    }
}

// ******************************* MARK: - KeyboardControllerListener

extension KeyboardAvoidingView: KeyboardControllerListener {
    
    // TODO: Add keyboard hide notification because on iPads keyboard can be undocked and moved
    // https://developer.apple.com/videos/play/wwdc2017/242/
    
    public func keyboard(willChangeOverlappingFrame frame: CGRect, duration: Double, animationOptions: UIView.AnimationOptions) {
        configureSize(keyboardOverlappingFrame: frame, duration: duration, animationOptions: animationOptions)
    }
}
