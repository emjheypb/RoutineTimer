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
    
    @IBInspectable var placeHolderString: String = "" {
        didSet {
            self.attributedPlaceholder = NSAttributedString(string: placeHolderString,
                                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        }
    }
    
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
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 10
        self.attributedPlaceholder = NSAttributedString(string: placeHolderString,
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        let paddingViewL = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: self.frame.height))
        let paddingViewR = UIView(frame: CGRect(x: self.frame.maxX, y: 0, width: 5, height: self.frame.height))
        self.leftView = paddingViewL
        self.leftViewMode = UITextField.ViewMode.always
        self.rightView = paddingViewR
        self.rightViewMode = UITextField.ViewMode.always
    }

}
