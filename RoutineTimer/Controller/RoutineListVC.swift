//
//  RoutineListVC.swift
//  RoutineTimer
//
//  Created by Mariah Baysic on 4/21/20.
//  Copyright © 2020 SpacedOut. All rights reserved.
//

import UIKit

class RoutineListVC: UIViewController {
    
    @IBOutlet weak var routinesTbl: UITableView!
    
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    
    @IBOutlet weak var headerLbl: UILabel!
    
    @IBOutlet weak var headerGradientView: GradientView!
    
    private let routineService = RoutineService.instance
    private let workoutService = WorkoutService.instance
    private let setRoutinesService = SetRoutinesService.instance
    
    private var editTbl = false
    
    var forWorkoutList = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        routinesTbl.delegate = self
        routinesTbl.dataSource = self
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(backSwiped(_:)))
        view.addGestureRecognizer(swipe)
        
        addBtn.isHidden = !forWorkoutList
        
        if !forWorkoutList {
            headerLbl.text = "ADD TO SET LIST"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? AddRoutineVC {
            destinationVC.update = routinesTbl.indexPathForSelectedRow?.row
        }
    }
    
    // @IBActions
    @IBAction func addBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_ADD_ROUTINE, sender: nil)
    }
    
    @IBAction func editBtnPressed(_ sender: Any) {
        editTbl = !editTbl
        routinesTbl.isEditing = editTbl
//        deleteBtn.isHidden = !editTbl
        
        if editTbl {
            editBtn.setImage(UIImage(systemName: "multiply"), for: .normal)
        } else {
            editBtn.setImage(UIImage(systemName: "pencil"), for: .normal)
        }
    }
    
    @IBAction func unwindToRoutinesList( _ seg: UIStoryboardSegue) {
        routinesTbl.reloadData()
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        goBack()
    }
    
}

extension RoutineListVC {
    // Customs
    func addItem(row: Int) {
        let indexPath = IndexPath(row: row, section: 0)
        
        let bgView = UIView()
        bgView.backgroundColor = .link
        
        let cell = routinesTbl.cellForRow(at: indexPath)
        cell!.selectedBackgroundView = bgView
        if !forWorkoutList {
            cell!.selectionStyle = .default
        }
        
        let routine = routineService.routines[row]
        
        routinesTbl.selectRow(at: indexPath, animated: true, scrollPosition: .none)

        if forWorkoutList {
            if routine.count == nil {
                workoutService.addItem(item: Workout(title: routine.title, description: routine.time))
            } else {
                workoutService.addItem(item: Workout(title: routine.title, description: "\(routine.count!)"))
            }
        } else {
            setRoutinesService.addItem(item: routine)
        }
        
        routinesTbl.deselectRow(at: indexPath, animated: true)
        
        if forWorkoutList {
            perform(#selector(turn(indexPath:)), with: indexPath, afterDelay: 0.4)
        }
    }
    
    func goBack() {
        if forWorkoutList {
            performSegue(withIdentifier: UNWIND_TO_WORKOUT_LIST, sender: self)
        } else {
            performSegue(withIdentifier: UNWIND_TO_ADD_SET, sender: self)
        }
    }
    
    // @objc
    @objc func addBtnTapped(_ sender: UIButton){
        addItem(row: sender.tag)
    }
    
    @objc func backSwiped(_ recognizer: UISwipeGestureRecognizer) {
        goBack()
    }
    
    @objc func turn(indexPath: IndexPath) {
        let cell = routinesTbl.cellForRow(at: indexPath)
        
        if forWorkoutList {
            cell!.selectedBackgroundView = nil
        } else {
            cell?.selectionStyle = .none
        }
    }
}

extension RoutineListVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routineService.routines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = routinesTbl.dequeueReusableCell(withIdentifier: "RoutineCell") as? RoutineCell {
            let routine = routineService.routines[indexPath.row]
            
            cell.titleLbl.text = routine.title
            if routine.count == nil {
                cell.decriptionLbl.text = routine.time
            } else {
                cell.decriptionLbl.text = "\(routine.count!)"
            }
            
            cell.addBtn.tag = indexPath.row
            cell.addBtn.addTarget(self, action: #selector(addBtnTapped(_:)), for: .touchUpInside)
            
            if !forWorkoutList {
                cell.selectionStyle = .none
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            routineService.deleteRoutine(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if forWorkoutList {
            performSegue(withIdentifier: TO_ADD_ROUTINE, sender: nil)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}
