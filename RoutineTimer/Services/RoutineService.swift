//
//  RoutineService.swift
//  RoutineTimer
//
//  Created by Mariah Baysic on 4/16/20.
//  Copyright © 2020 SpacedOut. All rights reserved.
//

import Foundation
import CoreData

class RoutineService {
    static let instance = RoutineService()
    
    var routines = [Routine]()
    var entityRoutines = [EntityRoutine]()
    
    func saveRoutine(routine: Routine, completion: @escaping CompletionHandler) {
        guard let manageContext = appDelegate?.persistentContainer.viewContext else { return }
        let entityRoutine = EntityRoutine(context: manageContext)
        
        entityRoutine.title = routine.title
        if routine.time == nil {
            entityRoutine.count = Int32(routine.count)
        } else {
            entityRoutine.time = routine.time
        }
        
        do {
            try manageContext.save()
            entityRoutines.append(entityRoutine)
            entityRoutines.sort(by: {$0.title! < $1.title!})
            routines.append(routine)
            routines.sort(by: {$0.title < $1.title})
            completion(true)
        } catch {
            debugPrint("Could not Save : \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func moveRoutine(fromIndex: Int, toIndex: Int) {
        let routine = routines[fromIndex]
        routines.remove(at: fromIndex)
        routines.insert(routine, at: toIndex)
    }
    
    func deleteRoutine(index: Int, completion: @escaping CompletionHandler) {
        guard let manageContext = appDelegate?.persistentContainer.viewContext else { return }
        
        manageContext.delete(entityRoutines[index])
        
        do {
            try manageContext.save()
            entityRoutines.remove(at: index)
            routines.remove(at: index)
            completion(true)
        } catch {
            debugPrint("Could not remove: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func updateRoutine(index: Int, routine: Routine, completion: @escaping CompletionHandler) {
        deleteRoutine(index: index) { (success) in
            if success {
                self.saveRoutine(routine: routine) { (success) in
                    if success {
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            }
        }
    }
    
    func fetch() {
        guard let manageContext = appDelegate?.persistentContainer.viewContext else { return }
        let fetchRoutine = NSFetchRequest<EntityRoutine>(entityName: "EntityRoutine")
        
        do {
            entityRoutines = try manageContext.fetch(fetchRoutine)
            entityRoutines.sort(by: {$0.title! < $1.title!})
            for entityRoutine in entityRoutines {
                let routine = Routine(title: entityRoutine.title, time: entityRoutine.time, count: entityRoutine.count)
                routines.append(routine)
            }
        } catch {
            debugPrint("Could not fetch data: \(error.localizedDescription)")
        }
    }
}
