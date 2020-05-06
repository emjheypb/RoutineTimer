//
//  AddSetVC.swift
//  RoutineTimer
//
//  Created by Mariah Baysic on 4/23/20.
//  Copyright © 2020 SpacedOut. All rights reserved.
//

import UIKit

class AddSetVC: UIViewController {
    
    @IBOutlet weak var routinesTbl: UITableView!
    @IBOutlet weak var gradientView: GradientView!
    
    @IBOutlet weak var headerTxtbx: ErrorTextField!
    
    @IBOutlet weak var tblPlaceholderLbl: UILabel!
    
    private let setRoutinesService = SetRoutinesService.instance
    private let setService = SetService.instance
    private let gf = GlobalFunctions()
    
    var update : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        routinesTbl.delegate = self
        routinesTbl.dataSource = self
        
        headerTxtbx.delegate = self
        
        setupView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? UITabBarController {
            let routinesVC = destinationVC.viewControllers![0] as! RoutineListVC
            let setsVC = destinationVC.viewControllers![1] as! SetListVC
            
            routinesVC.forWorkoutList = false
            
            setsVC.forWorkoutList = false
            setsVC.passBack = update
        }
    }
    
    // @IBActions
    @IBAction func addBtnPressed(_ sender: Any) {
        view.endEditing(true)
        performSegue(withIdentifier: TO_ROUTINE_SETS, sender: self)
    }
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        view.endEditing(true)
        
        headerTxtbx.layer.borderColor = UIColor.placeholderText.cgColor
        tblPlaceholderLbl.textColor = .placeholderText
        
        guard let setName = headerTxtbx.text, headerTxtbx.text != "" else {
            headerTxtbx.layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            return
        }
        
        if setRoutinesService.items.count == 0 {
            tblPlaceholderLbl.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            return
        }
        
        let routines = setRoutinesService.items
        
        if update == nil {
            setService.addSet(set: SetRoutines(title: setName, routines: routines, isCollapsed: false))
        } else {
            setService.updateSets(index: update, set: SetRoutines(title: setName, routines: routines, isCollapsed: setService.sets[update].isCollapsed))
        }

        NotificationCenter.default.post(name: NOTIF_SETS, object: nil)
        performSegue(withIdentifier: UNWIND_TO_SETS_LIST, sender: self)
    }
    
    @IBAction func clearAllBtnPressed(_ sender: Any) {
        view.endEditing(true)
        
        if setRoutinesService.items.count > 0 {
            let refreshAlert = UIAlertController(title: "Clear Set", message: "Are you sure?", preferredStyle: .alert)

            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            }))

            refreshAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action: UIAlertAction!) in
                self.setRoutinesService.clearItems()
                self.routinesTbl.reloadData()
                self.tblPlaceholderLbl.isHidden = false
            }))

            present(refreshAlert, animated: true, completion: nil)
        }
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        goBack()
    }
    
    @IBAction func unwindToAddSet( _ seg: UIStoryboardSegue) {
        routinesTbl.reloadData()
    }
    
}

extension AddSetVC {
    // Custom
    func setupView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        tblPlaceholderLbl.addGestureRecognizer(tap)
        gradientView.addGestureRecognizer(tap)
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(backSwiped(_:)))
        view.addGestureRecognizer(swipe)
        
        setRoutinesService.clearItems()
        
        if update != nil {
            headerTxtbx.text = setService.sets[update].title
            
            for routine in setService.sets[update].routines {
                setRoutinesService.addItem(item: routine)
            }
            
            tblPlaceholderLbl.isHidden = true
        }
        
        routinesTbl.isEditing = true
    }
    
    func goBack() {
        view.endEditing(true)
        
        var alertTitle = ""
        
        if update == nil {
            if headerTxtbx.text != "" || routinesTbl.numberOfRows(inSection: 0) > 0 {
                alertTitle = "Discard New Set"
            }
        } else {
            let set = setService.sets[update]
            
            if set.title != headerTxtbx.text {
                alertTitle = "Discard Set Changes"
            } else {
                if set.routines.count != routinesTbl.numberOfRows(inSection: 0) {
                    alertTitle = "Discard Set Changes"
                } else {
                    for num in 0 ... set.routines.count - 1 {
                        let cell = routinesTbl.cellForRow(at: IndexPath(row: num, section: 0)) as? SetRoutineCell
                        let routine = set.routines[num]
                        
                        if routine.title != cell?.titleLbl.text {
                            alertTitle = "Discard Set Changes"
                            break
                        }
                    }
                }
            }
        }
        
        if alertTitle != "" {
            let refreshAlert = UIAlertController(title: alertTitle, message: "Are you sure?", preferredStyle: .alert)

            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                return
            }))

            refreshAlert.addAction(UIAlertAction(title: "Discard", style: .destructive, handler: { (action: UIAlertAction!) in
                self.navigationController?.popViewController(animated: true)
            }))
            
            present(refreshAlert, animated: true, completion: nil)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    // Selectors
    @objc func dismissKeyboard(_ recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func backSwiped(_ recognizer: UISwipeGestureRecognizer) {
        goBack()
    }
}

extension AddSetVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setRoutinesService.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = routinesTbl.dequeueReusableCell(withIdentifier: "SetRoutineCell") as? SetRoutineCell {
            let routine = setRoutinesService.items[indexPath.row]

            cell.titleLbl.text = routine.title

            if routine.count == nil {
                cell.descriptionLbl.text = routine.time
            } else {
                cell.descriptionLbl.text = "\(routine.count!)"
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        view.endEditing(true)
        setRoutinesService.moveItem(fromIndex: sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            setRoutinesService.deleteItem(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
    }
}

extension AddSetVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
