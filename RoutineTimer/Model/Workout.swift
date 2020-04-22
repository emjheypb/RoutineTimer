//
//  Workout.swift
//  RoutineTimer
//
//  Created by Mariah Baysic on 4/21/20.
//  Copyright © 2020 SpacedOut. All rights reserved.
//

import Foundation

struct Workout {
    public private(set) var title : String!
    public private(set) var description : String!
    public private(set) var setList : [Routine]!
    public var isCollapsed : Bool! = false
}
