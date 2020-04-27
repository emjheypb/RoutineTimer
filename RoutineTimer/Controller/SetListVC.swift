//
//  SetListVC.swift
//  RoutineTimer
//
//  Created by Mariah Baysic on 4/21/20.
//  Copyright © 2020 SpacedOut. All rights reserved.
//

import UIKit

class SetListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var setsTbl: UITableView!
    
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    
    @IBOutlet weak var headerLbl: UILabel!
    
    @IBOutlet weak var headerGradientView: GradientView!
    
    private let setService = SetService.instance
    private let workoutService = WorkoutService.instance
    private let setRoutinesService = SetRoutinesService.instance
    
    private var editTbl = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setsTbl.delegate = self
        setsTbl.dataSource = self
        
//        setsTbl.register(SetHeadCell.self, forHeaderFooterViewReuseIdentifier: "header")
        
       let swipe = UISwipeGestureRecognizer(target: self, action: #selector(backSwiped(_:)))
       view.addGestureRecognizer(swipe)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? AddSetVC {
            destinationVC.update = setsTbl.indexPathForSelectedRow?.section
        }
    }
    
    func collapseExpand(section: Int) {
        setService.sets[section].isCollapsed = !setService.sets[section].isCollapsed
        
        let sections = IndexSet.init(integer: section)
        setsTbl.reloadSections(sections, with: .fade)
    }
    
    func addItem(section: Int) {
        let indexPath = IndexPath(row: 0, section: section)
        let setData = setService.sets[section]
        
        let bgView = UIView()
        bgView.backgroundColor = .link

        let cell = setsTbl.cellForRow(at: indexPath)
        cell!.selectedBackgroundView = bgView
        
        setsTbl.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        
        workoutService.addItem(item: Workout(title: setData.title, description: "SET", setList: setData.routines))
        
        setsTbl.deselectRow(at: indexPath, animated: true)
    }
    
    // @IBActions
    @IBAction func addBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_ADD_SET_ROUTINE, sender: nil)
    }
    
    @IBAction func editBtnPressed(_ sender: Any) {
        editTbl = !editTbl
        setsTbl.isEditing = editTbl
//        deleteBtn.isHidden = !editTbl
        
        if editTbl {
            editBtn.setImage(UIImage(systemName: "multiply"), for: .normal)
        } else {
            editBtn.setImage(UIImage(systemName: "pencil"), for: .normal)
        }
    }
    
    @IBAction func unwindToSetList( _ seg: UIStoryboardSegue) {
        if setService.sets.count != setsTbl.numberOfSections {
            setsTbl.reloadData()
        }
    }
    
    // Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let setData = setService.sets[section]
        if setData.isCollapsed {
            return setData.routines.count + 1
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let setData = setService.sets[indexPath.section]
        
        if indexPath.row == 0 {
            if let cell = setsTbl.dequeueReusableCell(withIdentifier: "SetHeaderCell", for: indexPath) as? SetHeaderCell {
                cell.titleLbl.text = setData.title
                cell.addBtn.tag = indexPath.section
                cell.collapseBtn.tag = indexPath.section
                
                cell.addBtn.addTarget(self, action: #selector(addBtnTapped(_:)), for: .touchUpInside)
                cell.collapseBtn.addTarget(self, action: #selector(collapseBtnTapped(_:)), for: .touchUpInside)
                
                cell.collapseBtn.setImage(setData.isCollapsed ? UIImage(systemName: "arrowtriangle.down.fill") : UIImage(systemName: "arrowtriangle.right.fill"), for: .normal)
                
                return cell
            }
        } else {
            if let cell = setsTbl.dequeueReusableCell(withIdentifier: "SetCell", for: indexPath) as? SetCell {
                let routine = setData.routines[indexPath.row - 1]

                cell.titleLbl.text = routine.title
                if routine.count == nil {
                   cell.descriptionLbl.text = routine.time
                } else {
                   cell.descriptionLbl.text = "\(routine.count!)"
                }

                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return setService.sets.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = setsTbl.cellForRow(at: indexPath)
        cell!.selectedBackgroundView = nil
        
        performSegue(withIdentifier: TO_ADD_SET_ROUTINE, sender: nil)
        setsTbl.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            setService.sets[indexPath.section].isCollapsed = false
            collapseExpand(section: indexPath.section)
            
            let sections = IndexSet.init(integer: indexPath.section)
            setService.deleteSet(index: indexPath.section)
            tableView.deleteSections(sections, with: .none)
            
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    // Selectors
    @objc func collapseBtnTapped(_ button: UIButton) {
        collapseExpand(section: button.tag)
    }
    
    @objc func addBtnTapped(_ sender: UIButton){
        addItem(section: sender.tag)
    }
        
    @objc func backSwiped(_ recognizer: UISwipeGestureRecognizer) {
        navigationController?.popViewController(animated: true)
    }
    
}
