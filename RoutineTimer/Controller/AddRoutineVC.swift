//
//  AddRoutineVC.swift
//  RoutineTimer
//
//  Created by Mariah Baysic on 4/16/20.
//  Copyright © 2020 SpacedOut. All rights reserved.
//

import UIKit

class AddRoutineVC: UIViewController {

    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var timePkr: UIPickerView!
    
    @IBOutlet weak var countSwitch: UISwitch!
    
    @IBOutlet weak var titleTxtbx: UITextField!
    @IBOutlet weak var countTxtbx: UITextField!
    
    @IBOutlet weak var addBtn: RoundedButton!
    
    @IBOutlet weak var minsLbl: UILabel!
    @IBOutlet weak var secsLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var countLbl: UILabel!
    
    private var pickerData: [[String]] = [[String]]()
    private var data: [String] = []
    
    private var mins = "00"
    private var secs = "00"
    
    private let gf = GlobalFunctions()
    private let routineService = RoutineService.instance
    private let workoutService = WorkoutService.instance
    
    var update : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        timePkr.delegate = self
        timePkr.dataSource = self
        
        titleTxtbx.delegate = self
        
        setupView()
    }

    // Actions
    @IBAction func addBtnPressed(_ sender: Any) {
        addRoutine()
    }
    
    @IBAction func countEditingDidChange(_ sender: Any) {
        if countTxtbx.text != "" {
            countSwitch.setOn(true, animated: true)
        } else {
            countSwitch.setOn(false, animated: true)
        }
        switchChange(countSwitch.isOn)
    }
    
    @IBAction func countSwitchChanged(_ sender: Any) {
        switchChange(countSwitch.isOn)
        
        countLbl.textColor = .label
        countTxtbx.layer.borderColor = UIColor.placeholderText.cgColor
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        goBack()
    }

}

extension AddRoutineVC {
    // Customs
    func setupView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        view.addGestureRecognizer(tap)
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(backSwiped(_:)))
        view.addGestureRecognizer(swipe)
        
        populateData()
        
        if update != nil {
            let routine = routineService.routines[update]
            
            titleTxtbx.text = routine.title
            countSwitch.setOn(routine.count != nil, animated: true)
            
            if routine.count != nil {
                countTxtbx.text = "\(routine.count!)"
                
                minsLbl.textColor = .placeholderText
                secsLbl.textColor = .placeholderText
                timeLbl.textColor = .placeholderText
                timePkr.isUserInteractionEnabled = false
            } else {
                let time = gf.getTimeInt(timeStr: routine.time)
                let m = time[1]
                let s = time[0]

                timePkr.selectRow(m, inComponent: 0, animated: true)
                self.mins = pickerData[0][m].padding(toLength: 2, withPad: "0", startingAt: 0)

                timePkr.selectRow(s, inComponent: 1, animated: true)
                self.secs = pickerData[1][s].padding(toLength: 2, withPad: "0", startingAt: 0)
            }
        }
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
    
    func switchChange(_ isOn: Bool) {
        view.endEditing(true)
        timePkr.isUserInteractionEnabled = !isOn
        
        if isOn {
            minsLbl.textColor = .placeholderText
            secsLbl.textColor = .placeholderText
            timeLbl.textColor = .placeholderText
        } else {
            minsLbl.textColor = .label
            secsLbl.textColor = .label
            timeLbl.textColor = .label
        }
    }
    
    func addRoutine() {
        view.endEditing(true)
                
        if !countSwitch.isOn {
            minsLbl.textColor = .label
            secsLbl.textColor = .label
            timeLbl.textColor = .label
        }
        
        countLbl.textColor = .label
        
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
                countLbl.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                return
            }
            
            let routine = Routine(title: title, count: count)
            
            if update == nil {
                routineService.addRoutine(routine: routine)
            } else {
                routineService.updateRoutine(index: update, routine: routine)
            }
        } else {
            if mins != "00" || secs != "00" {
                let routine = Routine(title: title, time: "\(mins) : \(secs)")
//                let item = Workout(title: title, description: "\(routine.time!)", setList: nil)
                
                if update == nil {
                    routineService.addRoutine(routine: routine)
//                    workoutService.addItem(item: item)
                } else {
                    routineService.updateRoutine(index: update, routine: routine)
                }
            } else {
                minsLbl.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                secsLbl.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                timeLbl.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                return
            }
        }
        
        performSegue(withIdentifier: UNWIND_TO_ROUTINE_LIST, sender: self)
    }
    
    func goBack() {
        view.endEditing(true)
        var alertTitle = ""
        
        if update == nil {
            if titleTxtbx.text != "" || (countSwitch.isOn && countTxtbx.text != "") || (!countSwitch.isOn && "\(mins) : \(secs)" != "00 : 00") {
                alertTitle = "Discard New Routine"
            }
        } else {
            let routine = routineService.routines[update]
            
            if routine.title != titleTxtbx.text || (countSwitch.isOn && routine.count != gf.strToInt(str: countTxtbx.text ?? "0")) || (!countSwitch.isOn && routine.time != "\(mins) : \(secs)") {
                alertTitle = "Discard Routine Changes"
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

extension AddRoutineVC : UIPickerViewDataSource, UIPickerViewDelegate {
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
}

extension AddRoutineVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
