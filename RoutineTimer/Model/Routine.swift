//
//  Item.swift
//  RoutineTimer
//
//  Created by Mariah Baysic on 4/16/20.
//  Copyright © 2020 SpacedOut. All rights reserved.
//

import Foundation

struct Routine {
    public private(set) var title : String!
    public private(set) var minutes : String!
    public private(set) var seconds : String!
    public private(set) var isByCount : Bool!
    public private(set) var count : Int?
}
