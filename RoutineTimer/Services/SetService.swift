//
//  SetService.swift
//  RoutineTimer
//
//  Created by Mariah Baysic on 4/22/20.
//  Copyright © 2020 SpacedOut. All rights reserved.
//

import Foundation
import CoreData

class SetService {
    static let instance = SetService()
    
    var sets = [SetRoutines]()
    var entitySets = [EntitySet]()
    
    func clearSets() {
        sets.removeAll()
    }
    
    func addSet(set: SetRoutines, completion: @escaping CompletionHandler) {
        guard let manageContext = appDelegate?.persistentContainer.viewContext else { return }
        let entitySet = EntitySet(context: manageContext)
        
        entitySet.title = set.title
        var sequence : Int32 = 0
        for routine in set.routines {
            let entitySetRoutine = EntitySetRoutine(context: manageContext)
            entitySetRoutine.title = routine.title
            entitySetRoutine.time = routine.time
            entitySetRoutine.count = routine.count
            entitySetRoutine.sequence = sequence
            
            entitySet.addToRoutine(entitySetRoutine)
            sequence += 1
        }
        
        do {
            try manageContext.save()
            entitySets.append(entitySet)
            entitySets.sort(by: {$0.title! < $1.title!})
            
            sets.append(set)
            sets.sort(by: {$0.title < $1.title})
            completion(true)
        } catch {
            debugPrint("Could not Save : \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func moveSet(fromIndex: Int, toIndex: Int) {
        let set = sets[fromIndex]
        sets.remove(at: fromIndex)
        sets.insert(set, at: toIndex)
    }
    
    func deleteSet(index: Int, completion: @escaping CompletionHandler) {
        guard let manageContext = appDelegate?.persistentContainer.viewContext else { return }
        
        manageContext.delete(entitySets[index])
        
        do {
            try manageContext.save()
            entitySets.remove(at: index)
            sets.remove(at: index)
            completion(true)
        } catch {
            debugPrint("Could not remove: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func updateSets(index: Int, set: SetRoutines, completion: @escaping CompletionHandler) {
        deleteSet(index: index) { (success) in
            if success {
                self.addSet(set: set) { (success) in
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
        let fetchSet = NSFetchRequest<EntitySet>(entityName: "EntitySet")
        
        do {
            entitySets = try manageContext.fetch(fetchSet)
            entitySets.sort(by: {$0.title! < $1.title!})
            for entitySet in entitySets {
                var routines = [Routine]()
                var entitySetRoutines = entitySet.routine?.allObjects as! [EntitySetRoutine]
                entitySetRoutines.sort(by: {$0.sequence < $1.sequence})
                
                for entitySetRoutine in entitySetRoutines {
                    let routine = Routine(title: entitySetRoutine.title, time: entitySetRoutine.time, count: entitySetRoutine.count)
                    routines.append(routine)
                }
                
                let set = SetRoutines(title: entitySet.title, routines: routines, isCollapsed: false)
                sets.append(set)
            }
        } catch {
            debugPrint("Could not fetch data: \(error.localizedDescription)")
        }
    }
}
