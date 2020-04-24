//
//  RoutineListVC.swift
//  RoutineTimer
//
//  Created by Mariah Baysic on 4/21/20.
//  Copyright © 2020 SpacedOut. All rights reserved.
//

import UIKit

class RoutineListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var routinesTbl: UITableView!
    
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var fillerLbl: UILabel!
    
    @IBOutlet weak var headerGradientView: GradientView!
    @IBOutlet weak var pullDownView: UIView!
    
    private let routineService = RoutineService.instance
    private let workoutService = WorkoutService.instance
    private let setRoutinesService = SetRoutinesService.instance
    
    private var editTbl = false
    
    var forSetList = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        routinesTbl.delegate = self
        routinesTbl.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(addRoutine(_:)), name: NOTIF_ROUTINE, object: nil)
        
        if forSetList {
            setupView()
        } else {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(backSwiped(_:)))
            view.addGestureRecognizer(swipe)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! AddRoutineVC
        destinationVC.update = routinesTbl.indexPathForSelectedRow?.row
    }
    
    // Customs
    func setupView() {
        addBtn.isHidden = true
        backBtn.isHidden = true
        
        pullDownView.isHidden = false
        fillerLbl.isHidden = false
//        routinesTbl.allowsSelection = false

        headerLbl.text = "ADD TO NEW SET"
        
        NSLayoutConstraint.activate([
            headerGradientView.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    func addItem(row: Int) {
        let indexPath = IndexPath(row: row, section: 0)
        
        let bgView = UIView()
        bgView.backgroundColor = .link
        
        let cell = routinesTbl.cellForRow(at: indexPath)
        cell!.selectedBackgroundView = bgView
        
        let routine = routineService.routines[row]
        
        if !forSetList {
            if routine.count == nil {
                workoutService.addItem(item: Workout(title: routine.title, description: routine.time))
            } else {
                workoutService.addItem(item: Workout(title: routine.title, description: "\(routine.count!)"))
            }
        } else {
            setRoutinesService.addItem(item: routine)
        }
        
        routinesTbl.allowsSelection = true
        routinesTbl.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        routinesTbl.deselectRow(at: indexPath, animated: true)
        routinesTbl.allowsSelection = false
    }
    
    // Delegates
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
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !forSetList {
            let cell = routinesTbl.cellForRow(at: indexPath)
            cell!.selectedBackgroundView = nil
            
            performSegue(withIdentifier: TO_ADD_ROUTINE, sender: nil)
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            addItem(row: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    // @IBActions
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
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
    
    // @objc
    @objc func addRoutine(_ notif: Notification) {
        routinesTbl.reloadData()
    }
    
    @objc func addBtnTapped(_ sender: UIButton){
        addItem(row: sender.tag)
    }
    
    @objc func backSwiped(_ recognizer: UISwipeGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
}
