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
    
    let setService = SetService.instance
    let workoutService = WorkoutService.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setsTbl.delegate = self
        setsTbl.dataSource = self
        
//        setsTbl.register(SetHeadCell.self, forHeaderFooterViewReuseIdentifier: "header")
        
        NotificationCenter.default.addObserver(self, selector: #selector(addSet(_:)), name: NOTIF_SETS, object: nil)
    }
    
    // @IBActions
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addBtnPressed(_ sender: Any) {
    }
    
    // DELEGATES
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
        setsTbl.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            setService.sets[indexPath.section].isCollapsed = false
            let sections = IndexSet.init(integer: indexPath.section)
            setsTbl.reloadSections(sections, with: .none)
            
            setService.deleteSet(index: indexPath.section)
            tableView.deleteSections(sections, with: .none)
            
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
            return .delete
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if let header = setsTbl.dequeueReusableHeaderFooterView(withIdentifier: "header") as? SetHeadCell {
//            header.collapseBtn.tag = section
//
//            if setService.sets[section].isCollapsed {
//                header.collapseBtn.setImage(UIImage(systemName: "arrowtriangle.down.fill"), for: .normal)
//            }
//            header.setLbl.text = setService.sets[section].title
//
//            header.collapseBtn.addTarget(self, action: #selector(collapseBtnTapped(_:)), for: .touchUpInside)
//            header.addBtn.addTarget(self, action: #selector(addBtnTapped(_:)), for: .touchUpInside)
//            header.rowBtn.addTarget(self, action: #selector(rowBtnTapped(_:)), for: .touchUpInside)
//
//            return header
//        }
//
//        return UIView()
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 40
//    }

    // Selectors
    @objc func collapseBtnTapped(_ button: UIButton) {
        setService.sets[button.tag].isCollapsed = !setService.sets[button.tag].isCollapsed

        let sections = IndexSet.init(integer: button.tag)
        setsTbl.reloadSections(sections, with: .fade)
    }
    
    @objc func addBtnTapped(_ sender: UIButton){
        let indexPath = IndexPath(row: 0, section: sender.tag)
        let cell = setsTbl.cellForRow(at: indexPath)
        let bgView = UIView()
        
        bgView.backgroundColor = .link
        cell!.selectedBackgroundView = bgView
        
        setsTbl.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        setsTbl.deselectRow(at: indexPath, animated: true)
        
        let setData = setService.sets[sender.tag]

        workoutService.addItem(item: Workout(title: setData.title, description: "SET", setList: setData.routines))
    }
    
    @objc func addSet(_ notif: Notification) {
        setsTbl.reloadData()
    }
    
}
