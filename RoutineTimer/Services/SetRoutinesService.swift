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
    }
    
    func moveItem(fromIndex: Int, toIndex: Int) {
        let item = items[fromIndex]
        items.remove(at: fromIndex)
        items.insert(item, at: toIndex)
    }
    
    func deleteItem(index: Int) {
        items.remove(at: index)
    }
    
    func updateItems(index: Int, item: Routine) {
        items.remove(at: index)
        items.insert(item, at: index)
    }
}
