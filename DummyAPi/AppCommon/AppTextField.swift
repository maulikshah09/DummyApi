//
//  AppTextField.swift
//  DummyAPi
//
//  Created by Maulik Shah on 05/02/22.
//

import UIKit
 

class AppTextField: UITextField {
  
    init() {
        super.init(frame: UIScreen.main.bounds)
        return
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

         setup()
    }
    
    func setup() {
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.themeBlue().cgColor
    }
    
    @IBInspectable var inset: CGFloat = 0
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: inset, dy: inset)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
}



