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
    }
    
    func addSet(set: SetRoutines) {
        sets.append(set)
        sets.sort(by: {$0.title < $1.title})
    }
    
    func moveSet(fromIndex: Int, toIndex: Int) {
        let set = sets[fromIndex]
        sets.remove(at: fromIndex)
        sets.insert(set, at: toIndex)
    }
    
    func deleteSet(index: Int) {
        sets.remove(at: index)
    }
    
    func updateSets(index: Int, set: SetRoutines) {
        sets.remove(at: index)
        sets.insert(set, at: index)
    }
}
