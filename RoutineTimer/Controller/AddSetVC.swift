//
//  AddSetVC.swift
//  RoutineTimer
//
//  Created by Mariah Baysic on 4/23/20.
//  Copyright © 2020 SpacedOut. All rights reserved.
//

import UIKit

class AddSetVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var routinesTbl: UITableView!
    
    @IBOutlet weak var headerTxtbx: ErrorTextField!
    
    @IBOutlet weak var tblPlaceholderLbl: UILabel!
    
    private let setRoutinesService = SetRoutinesService.instance
    private let setService = SetService.instance
    
    var update : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        routinesTbl.delegate = self
        routinesTbl.dataSource = self
        
        routinesTbl.isEditing = true
        
        setupView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tabBarC = segue.destination as! UITabBarController
        let routinesVC = tabBarC.viewControllers![0] as! RoutineListVC
        let setsVC = tabBarC.viewControllers![1] as! SetListVC
        
        routinesVC.forSetList = true
        setsVC.forSetList = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(addItem(_:)), name: NOTIF_SET_ROUTINES, object: nil)
    }
    
    // Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setRoutinesService.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        setRoutinesService.moveItem(fromIndex: sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            setRoutinesService.deleteItem(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
//            NotificationCenter.default.post(name: NOTIF_SET_ROUTINES, object: nil)
        }
    }
    
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        return .delete
//    }
    
    // @IBActions
    @IBAction func addBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_ROUTINE_SETS, sender: self)
    }
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        headerTxtbx.layer.borderColor = UIColor.placeholderText.cgColor
        tblPlaceholderLbl.textColor = .placeholderText
        
        guard let setName = headerTxtbx.text, headerTxtbx.text != "" else {
            headerTxtbx.layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            return
        }
        
        if setRoutinesService.items.count == 0 {
            tblPlaceholderLbl.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        }
    }
    
    @IBAction func clearAllBtnPressed(_ sender: Any) {
        if setRoutinesService.items.count > 0 {
            let refreshAlert = UIAlertController(title: "Clear Set", message: "Are you sure?", preferredStyle: .alert)

            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            }))

            refreshAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action: UIAlertAction!) in
                self.setRoutinesService.clearItems()
                self.routinesTbl.reloadData()
            }))

            present(refreshAlert, animated: true, completion: nil)
        }
    }
    
    // Selectors
    @objc func addItem(_ : NotificationCenter) {
        routinesTbl.reloadData()
        
        tblPlaceholderLbl.textColor = .placeholderText
        tblPlaceholderLbl.isHidden = setRoutinesService.items.count != 0
    }
    
    @objc func dismissKeyboard(_ recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // Custom
    func setupView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        view.addGestureRecognizer(tap)
        
        setRoutinesService.clearItems()
        
        if update != nil {
            headerTxtbx.text = setService.sets[update].title
            
            for routine in setService.sets[update].routines {
                setRoutinesService.addItem(item: routine)
            }
            
            tblPlaceholderLbl.isHidden = true
        } else {
            tblPlaceholderLbl.isHidden = false
        }
        
    }
    
}
