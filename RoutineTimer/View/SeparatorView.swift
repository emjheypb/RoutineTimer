//
//  SeparatorView.swift
//  RoutineTimer
//
//  Created by Mariah Baysic on 4/17/20.
//  Copyright © 2020 SpacedOut. All rights reserved.
//

import UIKit

@IBDesignable
class SeparatorView: UIView {

    override func layoutSubviews() {
        self.layer.backgroundColor = UIColor.label.cgColor
        self.frame.size.height = 1
    }

}
