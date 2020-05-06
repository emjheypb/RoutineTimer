//
//  Constants.swift
//  RoutineTimer
//
//  Created by Mariah Baysic on 4/16/20.
//  Copyright © 2020 SpacedOut. All rights reserved.
//

import Foundation

typealias CompletionHandler = (_ Success: Bool) -> ()

// NOTIFICATIONS
let NOTIF_WORKOUT = Notification.Name("notifWorkout")
let NOTIF_SETS = Notification.Name("notifSets")

// SEGUES
let TO_ROUTINE_SETS = "toRoutineSets"
let TO_ADD_ROUTINE = "toAddRoutine"
let TO_ADD_SET_ROUTINE = "toAddSetRoutine"
let UNWIND_TO_WORKOUT_LIST = "unwindToWorkoutList"
let UNWIND_TO_ROUTINE_LIST = "unwindToRoutinesList"
let UNWIND_TO_SETS_LIST = "unwindToSetsList"
let UNWIND_TO_ADD_SET = "unwindToAddSet"
