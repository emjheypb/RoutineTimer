//
//  RoutineListVC.swift
//  RoutineTimer
//
//  Created by Mariah Baysic on 4/21/20.
//  Copyright © 2020 SpacedOut. All rights reserved.
//

import UIKit

class RoutineListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var routinesTbl: UITableView!
    
    private let routineService = RoutineService.instance
    private let workoutService = WorkoutService.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        routinesTbl.delegate = self
        routinesTbl.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(addRoutine(_:)), name: NOTIF_ROUTINE, object: nil)
    }
    
    // DELEGATES
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
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            routineService.deleteRoutine(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            NotificationCenter.default.post(name: NOTIF_WORKOUT, object: nil)
        }
    }
    
    // @IBActions
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addBtnPressed(_ sender: Any) {
//        let profile = AddRoutineVC()
//        profile.modalPresentationStyle = .custom
//        present(profile, animated: true, completion: nil)
        
        performSegue(withIdentifier: TO_ADD_ROUTINE, sender: nil)
    }
    
    @IBAction func editBtnPressed(_ sender: Any) {
    }
    
    // @objc
    @objc func addRoutine(_ notif: Notification) {
        routinesTbl.reloadData()
    }
    
    @objc func addBtnTapped(_ sender: UIButton){
        let routine = routineService.routines[sender.tag]
        
        if routine.count == nil {
            workoutService.addItem(item: Workout(title: routine.title, description: routine.time))
        } else {
            workoutService.addItem(item: Workout(title: routine.title, description: "\(routine.count!)"))
        }
    }
    
}
