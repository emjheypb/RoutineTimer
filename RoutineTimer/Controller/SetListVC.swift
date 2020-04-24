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
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var fillerLbl: UILabel!
    
    @IBOutlet weak var headerGradientView: GradientView!
    @IBOutlet weak var pullDownView: UIView!
    
    private let setService = SetService.instance
    private let workoutService = WorkoutService.instance
    private let setRoutinesService = SetRoutinesService.instance
    
    private var editTbl = false
    
    var forSetList = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setsTbl.delegate = self
        setsTbl.dataSource = self
        
//        setsTbl.register(SetHeadCell.self, forHeaderFooterViewReuseIdentifier: "header")
        
        NotificationCenter.default.addObserver(self, selector: #selector(addSet(_:)), name: NOTIF_SETS, object: nil)
        
        if forSetList {
            setupView()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! AddSetVC
        destinationVC.update = setsTbl.indexPathForSelectedRow?.section
    }
    
    // Customs
    func setupView() {
        addBtn.isHidden = true
        backBtn.isHidden = true
        
        pullDownView.isHidden = false
        fillerLbl.isHidden = false
//        setsTbl.allowsSelection = false
        
        headerLbl.text = "ADD TO NEW SET"
        
        NSLayoutConstraint.activate([
            headerGradientView.heightAnchor.constraint(equalToConstant: 70)
        ])
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
        
        if !forSetList {
            workoutService.addItem(item: Workout(title: setData.title, description: "SET", setList: setData.routines))
        } else {
            for routine in setData.routines {
                setRoutinesService.addItem(item: routine)
            }
        }
        
        setsTbl.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        setsTbl.deselectRow(at: indexPath, animated: true)
    }
    
    // @IBActions
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
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
        
        if !forSetList {
            performSegue(withIdentifier: TO_ADD_SET_ROUTINE, sender: nil)
            setsTbl.deselectRow(at: indexPath, animated: true)
        } else {
            collapseExpand(section: indexPath.section)
        }
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
        if indexPath.row == 0 {
            return .delete
        }
        
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
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
        collapseExpand(section: button.tag)
    }
    
    @objc func addBtnTapped(_ sender: UIButton){
        addItem(section: sender.tag)
    }
    
    @objc func addSet(_ notif: Notification) {
        setsTbl.reloadData()
    }
    
}
