//
//  SetupVC.swift
//  RoutineTimer
//
//  Created by Mariah Baysic on 4/16/20.
//  Copyright © 2020 SpacedOut. All rights reserved.
//

import UIKit

class WorkoutListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var workoutTbl: UITableView!
    
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
    private var editTbl = false
    
    private let workout = WorkoutService.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        revealViewController()?.rearViewRevealWidth = self.view.frame.size.width - 70
        
        workoutTbl.delegate = self
        workoutTbl.dataSource = self
        
        workoutTbl.isEditing = editTbl
    }
    
    // Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        workout.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = workout.items[indexPath.row]
        
        if let cell = workoutTbl.dequeueReusableCell(withIdentifier: "WorkoutCell") as? WorkoutCell {
            let title = item.title
            let description = item.description
            
            cell.titleLbl.text = title
            cell.timeCountLbl.text = description
            
            cell.duplicateBtn.tag = indexPath.row
            cell.duplicateBtn.addTarget(self, action: #selector(duplicateTapped(_:)), for: .touchUpInside)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            workout.deleteItem(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            NotificationCenter.default.post(name: NOTIF_WORKOUT, object: nil)
        }
    }
    
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        if workoutTbl.isEditing {
//            return .none
//        }
//            return .delete
//    }
//
//    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
//        return false
//    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        workout.moveItem(fromIndex: sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }
    
    // Selectors
    @objc func duplicateTapped(_ sender: UIButton){
        workout.addItem(item: workout.items[sender.tag])
    }
    
    // Actions
    @IBAction func addBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_ROUTINE_SETS, sender: nil)
    }
    
    @IBAction func deleteBtnPressed(_ sender: Any) {
        if workout.items.count > 0 {
            let refreshAlert = UIAlertController(title: "Clear Workout List", message: "Are you sure?", preferredStyle: .alert)

            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            }))

            refreshAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action: UIAlertAction!) in
                self.workout.clearItems()
                self.workoutTbl.reloadData()
            }))
            
            present(refreshAlert, animated: true, completion: nil)
        }
    }
    
    @IBAction func editBtnPressed(_ sender: Any) {
        editTbl = !editTbl
        workoutTbl.isEditing = editTbl
//        deleteBtn.isHidden = !editTbl
        
        if editTbl {
            editBtn.setImage(UIImage(systemName: "multiply"), for: .normal)
        } else {
            editBtn.setImage(UIImage(systemName: "pencil"), for: .normal)
        }
    }
    
    @IBAction func saveAsSetBtnPressed(_ sender: Any) {
    }
    
    @IBAction func unwindToWorkoutList( _ seg: UIStoryboardSegue) {
        if workout.items.count != workoutTbl.numberOfRows(inSection: 0) {
            workoutTbl.reloadData()
        }
    }
}
