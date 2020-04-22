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

        self.revealViewController()?.rearViewRevealWidth = self.view.frame.size.width - 70
        
        self.workoutTbl.delegate = self
        self.workoutTbl.dataSource = self
        
        self.workoutTbl.isEditing = editTbl
        
        NotificationCenter.default.addObserver(self, selector: #selector(addItem(_:)), name: NOTIF_WORKOUT, object: nil)
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
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
            return .delete
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        workout.moveItem(fromIndex: sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let profile = AddRoutineVC()
//        profile.modalPresentationStyle = .custom
//        present(profile, animated: true) {
//            profile.updateRoutine(index: indexPath.row)
//        }
//
//        workoutTbl.deselectRow(at: indexPath, animated: true)
//    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let button = UIButton(type: .system)
//        button.setImage(UIImage(systemName: "arrowtriangle.right"), for: .normal)
//        button.tintColor = .systemBackground
//        return button
//    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 40
//    }
    
    // Selectors
    @objc func addItem(_ notif: Notification) {
        workoutTbl.reloadData()
    }
    
    @objc func duplicateTapped(_ sender: UIButton){
        workout.addItem(item: workout.items[sender.tag])
    }
    
    // Actions
    @IBAction func addBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_ROUTINE_SETS, sender: nil)
    }
    
    @IBAction func deleteBtnPressed(_ sender: Any) {
        if workout.items.count > 0 {
            let refreshAlert = UIAlertController(title: "Clear List", message: "", preferredStyle: .alert)

            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            }))

            refreshAlert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action: UIAlertAction!) in
                self.workout.clearItems()
                self.workoutTbl.reloadData()
            }))

            present(refreshAlert, animated: true, completion: nil)
        }
    }
    
    @IBAction func editBtnPressed(_ sender: Any) {
        editTbl = !editTbl
        workoutTbl.isEditing = editTbl
        deleteBtn.isHidden = !editTbl
        
        if editTbl {
            editBtn.setImage(UIImage(systemName: "multiply"), for: .normal)
        } else {
            editBtn.setImage(UIImage(systemName: "pencil"), for: .normal)
        }
    }
    
}
