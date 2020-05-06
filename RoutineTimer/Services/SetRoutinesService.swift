//
//  SetRoutinesService.swift
//  RoutineTimer
//
//  Created by Mariah Baysic on 4/23/20.
//  Copyright © 2020 SpacedOut. All rights reserved.
//

import Foundation

class SetRoutinesService {
    static let instance = SetRoutinesService()
    
    var items = [Routine]()
    
    func clearItems() {
        items.removeAll()
    }
    
    func addItem(item: Routine) {
        items.append(item)
        NotificationCenter.default.post(name: NOTIF_SET_ROUTINES, object: nil)
    }
    
    func moveItem(fromIndex: Int, toIndex: Int) {
        let item = items[fromIndex]
        items.remove(at: fromIndex)
        items.insert(item, at: toIndex)
    }
    
    func deleteItem(index: Int) {
        items.remove(at: index)
    }
}
