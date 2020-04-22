//
//  RoutineService.swift
//  RoutineTimer
//
//  Created by Mariah Baysic on 4/16/20.
//  Copyright © 2020 SpacedOut. All rights reserved.
//

import Foundation

class RoutineService {
    static let instance = RoutineService()
    
    var routines = [Routine]()
    
    func addRoutine(routine: Routine) {
        routines.append(routine)
        routines.sort(by: {$0.title < $1.title})
        NotificationCenter.default.post(name: NOTIF_ROUTINE, object: nil)
    }
    
    func moveRoutine(fromIndex: Int, toIndex: Int) {
        let routine = routines[fromIndex]
        routines.remove(at: fromIndex)
        routines.insert(routine, at: toIndex)
        
        NotificationCenter.default.post(name: NOTIF_ROUTINE, object: nil)
    }
    
    func deleteRoutine(index: Int) {
        routines.remove(at: index)
    }
    
    func updateRoutine(index: Int, routine: Routine) {
        routines.remove(at: index)
        routines.insert(routine, at: index)
        
        NotificationCenter.default.post(name: NOTIF_ROUTINE, object: nil)
    }
}
