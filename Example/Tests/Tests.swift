// https://github.com/Quick/Quick

import Quick
import Nimble
import Nimble_Snapshots
import KeyboardAvoidingView


class MainSpec: QuickSpec {
    override func spec() {
        if #available(iOS 9.0, *) {
            describe("KeyboardAvoidingView") {
                var containerView: UIView!
                var keyboardAvoidingView: KeyboardAvoidingView!
                
                beforeEach {
                    containerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 568))
                    containerView.backgroundColor = .red
                    
                    keyboardAvoidingView = KeyboardAvoidingView(frame: containerView.bounds)
                    keyboardAvoidingView.backgroundColor = .green
                    keyboardAvoidingView.animate = false
                }
                
                let showKeyboard: () -> () = {
                    let frame = CGRect(x: 0, y: 315, width: 320, height: 253)
                    let value = NSValue(cgRect: frame)
                    let userInfo = [UIKeyboardFrameEndUserInfoKey: value, UIKeyboardAnimationDurationUserInfoKey: 0.25, UIKeyboardAnimationCurveUserInfoKey: 7] as [AnyHashable : Any]
                    NotificationCenter.default.post(name: .UIKeyboardWillChangeFrame, object: nil, userInfo: userInfo)
                }
                
                
                context("aligned with constraints", {
                    beforeEach {
                        keyboardAvoidingView.translatesAutoresizingMaskIntoConstraints = false
                        
                        containerView.addSubview(keyboardAvoidingView)
                        keyboardAvoidingView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
                        keyboardAvoidingView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
                        keyboardAvoidingView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
                        keyboardAvoidingView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
                    }
                    
                    context("without keyboard", {
                        it("matches snapshot") {
                            expect(containerView).to(haveValidSnapshot(named: "without_keyboard"))
                        }
                    })
                    
                    context("with keyboard", {
                        beforeEach {
                            showKeyboard()
                        }
                        
                        it("matches snapshot") {
                            expect(containerView).to(haveValidSnapshot(named: "with_keyboard"))
                        }
                    })
                })
                
                
                context("aligned with frame", {
                    beforeEach {
                        keyboardAvoidingView.translatesAutoresizingMaskIntoConstraints = false
                        keyboardAvoidingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                        
                        containerView.addSubview(keyboardAvoidingView)
                    }
                    
                    context("without keyboard", {
                        it("matches snapshot") {
                            expect(containerView).to(haveValidSnapshot(named: "without_keyboard"))
                        }
                    })
                    
                    context("with keyboard", {
                        beforeEach {
                            showKeyboard()
                        }
                        
                        it("matches snapshot") {
                            expect(containerView).to(haveValidSnapshot(named: "with_keyboard"))
                        }
                    })
                })
            }
        }
    }
}
