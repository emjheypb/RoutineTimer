//
//  SetService.swift
//  RoutineTimer
//
//  Created by Mariah Baysic on 4/22/20.
//  Copyright © 2020 SpacedOut. All rights reserved.
//

import Foundation

class SetService {
    static let instance = SetService()
    
    var sets = [SetRoutines]()
    
    func clearSets() {
        sets.removeAll()
        NotificationCenter.default.post(name: NOTIF_SETS, object: nil)
    }
    
    func addSet(set: SetRoutines) {
        sets.append(set)
        sets.sort(by: {$0.title < $1.title})
        NotificationCenter.default.post(name: NOTIF_SETS, object: nil)
    }
    
    func moveSet(fromIndex: Int, toIndex: Int) {
        let set = sets[fromIndex]
        sets.remove(at: fromIndex)
        sets.insert(set, at: toIndex)
        
        NotificationCenter.default.post(name: NOTIF_SETS, object: nil)
    }
    
    func deleteSet(index: Int) {
        sets.remove(at: index)
    }
    
    func updateSets(index: Int, set: SetRoutines) {
        sets.remove(at: index)
        sets.insert(set, at: index)
        
        NotificationCenter.default.post(name: NOTIF_SETS, object: nil)
    }
}
