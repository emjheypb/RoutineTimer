//
//  ErrorTextField.swift
//  RoutineTimer
//
//  Created by Mariah Baysic on 4/18/20.
//  Copyright © 2020 SpacedOut. All rights reserved.
//

import UIKit

@IBDesignable
class ErrorTextField: UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setupView()
    }
    
    func setupView() {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.placeholderText.cgColor
        self.layer.cornerRadius = 10
    }

}
