//
//  RoundedView.swift
//  RoutineTimer
//
//  Created by Mariah Baysic on 4/17/20.
//  Copyright © 2020 SpacedOut. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0.5 {
        didSet {
            self.layer.cornerRadius = cornerRadius
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
        self.layer.cornerRadius = cornerRadius
    }

}
