//
//  AddItem.swift
//  RoutineTimer
//
//  Created by Mariah Baysic on 4/16/20.
//  Copyright © 2020 SpacedOut. All rights reserved.
//

import UIKit

class AddRoutineVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var timePkr: UIPickerView!
    @IBOutlet weak var countSwitch: UISwitch!
    @IBOutlet weak var titleTxtbx: UITextField!
    @IBOutlet weak var countTxtbx: UITextField!
    @IBOutlet weak var addBtn: RoundedButton!
    @IBOutlet weak var minsLbl: UILabel!
    @IBOutlet weak var secsLbl: UILabel!
    
    private var pickerData: [[String]] = [[String]]()
    private var data: [String] = []
    
    private var mins = "00"
    private var secs = "00"
    
    private var update = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.timePkr.delegate = self
        self.timePkr.dataSource = self
        
        self.titleTxtbx.delegate = self
        
        setupView()
    }

    // Actions
    @IBAction func addBtnPressed(_ sender: Any) {
        minsLbl.textColor = .label
        secsLbl.textColor = .label
        titleTxtbx.layer.borderColor = UIColor.placeholderText.cgColor
        countTxtbx.layer.borderColor = UIColor.placeholderText.cgColor
        
        guard let title = titleTxtbx.text, titleTxtbx.text != "" else {
            titleTxtbx.layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            return
        }
        
        if countSwitch.isOn {
            mins = "00"
            secs = "00"
            
            let count = Int (countTxtbx.text ?? "0") ?? 0
            if count < 1 || count > 9999 {
                countTxtbx.layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                return
            }
            
            let item = Routine(title: title, minutes: mins, seconds: secs, isByCount: countSwitch.isOn, count: count)
            
            if addBtn.titleLabel?.text! == "ADD" {
                RoutineService.instance.addItem(item: item)
            } else {
                RoutineService.instance.updateItems(index: update, item: item)
            }

            dismiss(animated: true, completion: nil)
        } else {
            if mins != "00" || secs != "00" {
                let item = Routine(title: title, minutes: mins, seconds: secs, isByCount: countSwitch.isOn)
                
                if addBtn.titleLabel?.text! == "ADD" {
                    RoutineService.instance.addItem(item: item)
                } else {
                    RoutineService.instance.updateItems(index: update, item: item)
                }

                dismiss(animated: true, completion: nil)
            } else {
                minsLbl.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                secsLbl.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            }
        }
    }
    
    @IBAction func countEditingDidChange(_ sender: Any) {
        countSwitch.setOn(true, animated: true)
        timePkr.isUserInteractionEnabled = !countSwitch.isOn
    }
    
    @IBAction func countSwitchChanged(_ sender: Any) {
        timePkr.isUserInteractionEnabled = !countSwitch.isOn
    }
    
    // Customs
    func setupView() {
        let closeTap = UITapGestureRecognizer(target: self, action: #selector(AddRoutineVC.closeTouch(_:)))
        bgView.addGestureRecognizer(closeTap)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(AddRoutineVC.dismissKeyboard(_:)))
        view.addGestureRecognizer(tap)
        
        addBtn.setTitle("ADD", for: .normal)
        
        populateData()
    }
    
    func populateData() {
        // Minutes
        for n in 0...59 {
            let str = "".padding(toLength: 2 - String(n).count, withPad: "0", startingAt: 0) + String(n)
            data.append("\(str)")
        }
        pickerData.append(data)
        data.removeAll()
        
        // Seconds
        for n in 0...59 {
            let str = "".padding(toLength: 2 - String(n).count, withPad: "0", startingAt: 0) + String(n)
            data.append("\(str)")
        }
        pickerData.append(data)
        data.removeAll()
    }
    
    func updateItem(index: Int) {
        update = index
        addBtn.setTitle("UPDATE", for: .normal)
        
        let item = RoutineService.instance.items[index]
        let mins = Int (item.minutes ?? "0") ?? 1 - 1
        let secs = Int (item.seconds ?? "0") ?? 1 - 1
        
        titleTxtbx.text = item.title
        countSwitch.setOn(item.isByCount, animated: true)
        
        if item.isByCount {
            countTxtbx.text = "\(item.count ?? 0)"
        } else {
            timePkr.selectRow(mins, inComponent: 0, animated: true)
            self.mins = pickerData[0][mins].padding(toLength: 2, withPad: "0", startingAt: 0)
            
            timePkr.selectRow(secs, inComponent: 1, animated: true)
            self.secs = pickerData[1][secs].padding(toLength: 2, withPad: "0", startingAt: 0)
        }
    }

    // Selectors
    @objc func closeTouch(_ recognizer: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard(_ recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // Delegates
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            mins = pickerData[component][row].padding(toLength: 2, withPad: "0", startingAt: 0)
        default:
            secs = pickerData[component][row].padding(toLength: 2, withPad: "0", startingAt: 0)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

}
