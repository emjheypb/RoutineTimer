//
//  WourkoutService.swift
//  RoutineTimer
//
//  Created by Mariah Baysic on 4/21/20.
//  Copyright © 2020 SpacedOut. All rights reserved.
//

import Foundation

class WorkoutService {
    static let instance = WorkoutService()
    
    var items = [Workout]()
    
    func clearItems() {
        items.removeAll()
        NotificationCenter.default.post(name: NOTIF_WORKOUT, object: nil)
    }
    
    func addItem(item: Workout) {
        items.append(item)
        NotificationCenter.default.post(name: NOTIF_WORKOUT, object: nil)
    }
    
    func moveItem(fromIndex: Int, toIndex: Int) {
        let item = items[fromIndex]
        items.remove(at: fromIndex)
        items.insert(item, at: toIndex)
        
        NotificationCenter.default.post(name: NOTIF_WORKOUT, object: nil)
    }
    
    func deleteItem(index: Int) {
        items.remove(at: index)
    }
    
    func updateItems(index: Int, item: Workout) {
        items.remove(at: index)
        items.insert(item, at: index)
        
        NotificationCenter.default.post(name: NOTIF_WORKOUT, object: nil)
    }
}
