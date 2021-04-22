//
//  ViewController.swift
//  KeyboardAvoidingView
//
//  Created by Anton Plebanovich on 07/05/2017.
//  Copyright (c) 2017 Anton Plebanovich. All rights reserved.
//

import UIKit

import APExtensions
import ViewState


private var c_vcCounter = 0


public class ViewController: UIViewController {
    
    // ******************************* MARK: - @IBOutlets
    
    @IBOutlet private weak var textField: UITextField?
    
    // ******************************* MARK: - Private Properties
    
    private lazy var vcNumber: Int = {
        c_vcCounter += 1
        return c_vcCounter
    }()
    
    // ******************************* MARK: - UIViewController Overrides
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardOnTouch = true
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    public override func becomeFirstResponder() -> Bool {
        let bool = super.becomeFirstResponder()
        
        return bool
    }
}
