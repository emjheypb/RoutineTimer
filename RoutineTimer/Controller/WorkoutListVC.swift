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
    
    @IBOutlet weak var placeholderLbl: UILabel!
    
    private var editTbl = false
    
    private let workout = WorkoutService.instance
    private let setService = SetService.instance
    
    private let gf = GlobalFunctions()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        revealViewController()?.rearViewRevealWidth = self.view.frame.size.width - 70
        
        workoutTbl.delegate = self
        workoutTbl.dataSource = self
        
        workoutTbl.isEditing = editTbl
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTable(_:)), name: NOTIF_WORKOUT, object: nil)
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
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        workout.moveItem(fromIndex: sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }
    
    // Selectors
    @objc func duplicateTapped(_ sender: UIButton) {
        workout.addItem(item: workout.items[sender.tag])
    }
    
    @objc func reloadTable(_ sender: NotificationCenter) {
        workoutTbl.reloadData()
        placeholderLbl.isHidden = !(workoutTbl.numberOfRows(inSection: 0) == 0)
        placeholderLbl.textColor = .placeholderText
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
        if workoutTbl.numberOfRows(inSection: 0) > 0 {
            let alert = UIAlertController(title: "Save as Set", message: "Enter Set Name", preferredStyle: .alert)
            
            let saveAction = UIAlertAction(title: "Save", style: .default) { (action: UIAlertAction!) in
                var workoutRoutines = [Routine]()
                
                for item in self.workout.items {
                    let title = item.title
                    let setRoutines = item.setList
                    let description = item.description!

                    if item.setList == nil {
                        if description.contains(":") {
                            workoutRoutines.append(Routine(title: title, time: description))
                        } else {
                            workoutRoutines.append(Routine(title: title, count: self.gf.strToInt(str: description)))
                        }
                    } else {
                        for routine in setRoutines! {
                            workoutRoutines.append(routine)
                        }
                    }
                }
                
                self.setService.addSet(set: SetRoutines(title: alert.textFields?[0].text, routines: workoutRoutines, isCollapsed: false))
            }
            saveAction.isEnabled = false

            alert.addTextField { (textField) in
                textField.placeholder = "Set Name"
            }
            
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object:alert.textFields?[0], queue: OperationQueue.main) { (notification) -> Void in

                saveAction.isEnabled = (alert.textFields?[0].text != "")
            }

            alert.addAction(saveAction)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                return
            }))

            self.present(alert, animated: true, completion: nil)
        } else {
            placeholderLbl.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        }
    }
    
    @IBAction func unwindToWorkoutList( _ seg: UIStoryboardSegue) {
        
    }
}
