//
//  ItemsService.swift
//  RoutineTimer
//
//  Created by Mariah Baysic on 4/16/20.
//  Copyright © 2020 SpacedOut. All rights reserved.
//

import Foundation

class RoutineService {
    static let instance = RoutineService()
    
    var items = [Routine]()
    
    func clearItems() {
        items.removeAll()
        NotificationCenter.default.post(name: NOTIF_ADD_ROUTINE, object: nil)
    }
    
    func addItem(item: Routine) {
        items.append(item)
        
        NotificationCenter.default.post(name: NOTIF_ADD_ROUTINE, object: nil)
    }
    
    func moveItem(fromIndex: Int, toIndex: Int) {
        let item = items[fromIndex]
        items.remove(at: fromIndex)
        items.insert(item, at: toIndex)
        
        NotificationCenter.default.post(name: NOTIF_ADD_ROUTINE, object: nil)
    }
    
    func deleteItem(index: Int) {
        items.remove(at: index)
    }
    
    func updateItems(index: Int, item: Routine) {
        items.remove(at: index)
        items.insert(item, at: index)
        
        NotificationCenter.default.post(name: NOTIF_ADD_ROUTINE, object: nil)
    }
}
