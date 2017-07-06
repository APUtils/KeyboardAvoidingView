//
//  TextField.swift
//  OnTheList-iOS
//
//  Created by Admin on 29/05/16.
//  Copyright © 2016 OnTheList. All rights reserved.
//

import UIKit


/// TextField with `Done` default button and close keyboard when tap
class TextField: UITextField {
    
    //-----------------------------------------------------------------------------
    // MARK: - Initialization
    //-----------------------------------------------------------------------------
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    //-----------------------------------------------------------------------------
    // MARK: - Private methods
    //-----------------------------------------------------------------------------
    
    private func setup() {
        returnKeyType = .done
        if delegate == nil { delegate = self }
    }
}

//-----------------------------------------------------------------------------
// MARK: - UITextFieldDelegate
//-----------------------------------------------------------------------------

extension TextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return false
    }
}
