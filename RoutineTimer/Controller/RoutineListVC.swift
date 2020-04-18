//
//  SetupVC.swift
//  RoutineTimer
//
//  Created by Mariah Baysic on 4/16/20.
//  Copyright © 2020 SpacedOut. All rights reserved.
//

import UIKit

class RoutineListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var itemsTableView: UITableView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
    private var editTbl = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.revealViewController()?.rearViewRevealWidth = self.view.frame.size.width - 70
        
        self.itemsTableView.delegate = self
        self.itemsTableView.dataSource = self
        
        self.itemsTableView.isEditing = editTbl
        
        NotificationCenter.default.addObserver(self, selector: #selector(RoutineListVC.addItem(_:)), name: NOTIF_ADD_ROUTINE, object: nil)
    }
    
    // Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        RoutineService.instance.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = RoutineService.instance.items[indexPath.row]
        
        if let cell = itemsTableView.dequeueReusableCell(withIdentifier: "ItemCell") as? RoutineTableViewCell {
            let title = item.title
            let counts = item.isByCount
            
            cell.titleLbl.text = title
            
            if counts! {
                cell.timeCountLbl.text = "~\(item.count!)"
            } else {
                cell.timeCountLbl.text = "\(item.minutes ?? "00") : \(item.seconds ?? "00")"
            }
            
            cell.duplicateBtn.tag = indexPath.row
            cell.duplicateBtn.addTarget(self, action: #selector(duplicateTapped(_:)), for: .touchUpInside)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            RoutineService.instance.deleteItem(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            NotificationCenter.default.post(name: NOTIF_ADD_ROUTINE, object: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
            return .delete
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        RoutineService.instance.moveItem(fromIndex: sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let profile = AddRoutineVC()
        profile.modalPresentationStyle = .custom
        present(profile, animated: true) {
            profile.updateItem(index: indexPath.row)
        }
        
        itemsTableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableViewDidEndMultipleSelectionInteraction(_ tableView: UITableView) {
        print("End")
    }
    
    // Selectors
    @objc func addItem(_ notif: Notification) {
        itemsTableView.reloadData()
    }
    
    @objc func duplicateTapped(_ sender: UIButton){
        RoutineService.instance.addItem(item: RoutineService.instance.items[sender.tag])
    }
    
    // Actions
    @IBAction func addBtnPressed(_ sender: Any) {
        let profile = AddRoutineVC()
        profile.modalPresentationStyle = .custom
        present(profile, animated: true, completion: nil)
    }
    
    @IBAction func deleteBtnPressed(_ sender: Any) {
        if RoutineService.instance.items.count > 0 {
            let refreshAlert = UIAlertController(title: "Clear List", message: "", preferredStyle: .alert)

            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            }))

            refreshAlert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action: UIAlertAction!) in
                RoutineService.instance.clearItems()
                self.itemsTableView.reloadData()
            }))

            present(refreshAlert, animated: true, completion: nil)
        }
    }
    
    @IBAction func editBtnPressed(_ sender: Any) {
        editTbl = !editTbl
        itemsTableView.isEditing = editTbl
        deleteBtn.isHidden = !editTbl
        
        if editTbl {
            editBtn.setImage(UIImage(systemName: "multiply"), for: .normal)
        } else {
            editBtn.setImage(UIImage(systemName: "pencil"), for: .normal)
        }
    }
    
}
