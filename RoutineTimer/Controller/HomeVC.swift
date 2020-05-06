//
//  HomeVC.swift
//  RoutineTimer
//
//  Created by Mariah Baysic on 4/16/20.
//  Copyright © 2020 SpacedOut. All rights reserved.
//

import UIKit
import AVFoundation

class HomeVC: UIViewController {

    @IBOutlet weak var routinePckr: UIPickerView!
    
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var repeatBtn: UIButton!
    @IBOutlet weak var startBtn: CircleButton!
    
    @IBOutlet weak var setsLbl: UILabel!
    @IBOutlet weak var progressLbl: UILabel!
    @IBOutlet weak var restCountLbl: UILabel!
    @IBOutlet weak var overallTimerLbl: UILabel!
    
    @IBOutlet weak var restStepper: UIStepper!
    @IBOutlet weak var setsStepper: UIStepper!
    
    private var itemsCount = 0
    private var totalTime = 0
    private var overallTotalTime = 0
    private var isStarted = false
    
    private var timer = Timer()
    private var overallTimer = Timer()
    private var player: AVAudioPlayer!
    private let session = AVAudioSession.sharedInstance()
    
    private let gf = GlobalFunctions()
    private let workoutService = WorkoutService.instance
    private var workoutBreakdown = [Routine]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        view.addGestureRecognizer((self.revealViewController().panGestureRecognizer())!)
        view.addGestureRecognizer((self.revealViewController().tapGestureRecognizer())!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(addItem(_:)), name: NOTIF_WORKOUT, object: nil)
        
        routinePckr.delegate = self
        routinePckr.dataSource = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(HomeVC.dismissKeyboard(_:)))
        view.addGestureRecognizer(tap)
        
        view.bringSubviewToFront(repeatBtn)
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        for routineData in DataBankService.instance.routineData {
            RoutineService.instance.addRoutine(routine: routineData)
        }
        
        for setData in DataBankService.instance.setData {
            SetService.instance.addSet(set: setData)
        }
        
        NotificationCenter.default.post(name: NOTIF_SETS, object: nil)
    }
    
    // Actions
    @IBAction func startBtnPressed(_ sender: Any) {
        if itemsCount > 0 {
            if isStarted {
                stopTimer()
                stop()
            } else {
                start()
                startOverallTimer()
                startRestTimer()
            }
        }
    }
    
    @IBAction func previousBtnPressed(_ sender: Any) {
        let prevRow = routinePckr.selectedRow(inComponent: 0) - 1
        
        if prevRow >= 0 {
            stopTimer()
            routinePckr.selectRow(prevRow, inComponent: 0, animated: true)
            setProgress(selected: prevRow)
            
            if isStarted { startRestTimer() }
        }
    }
    
    @IBAction func nextBtnPressed(_ sender: Any) {
        let nextRow = routinePckr.selectedRow(inComponent: 0) + 1
        
        if nextRow < itemsCount {
            stopTimer()
            routinePckr.selectRow(nextRow, inComponent: 0, animated: true)
            setProgress(selected: nextRow)
            
            if isStarted {
                startRestTimer()
            } else {
                resetAll(nextRow)
            }
        } else {
            if setsStepper.value > 1 {
                setsStepper.value -= 1
                
                resetAll()
                if isStarted {
                    startRestTimer()
                }
            } else {
                stop()
                stopTimer()
            }
        }
    }
    
    @IBAction func stepperPressed(_ sender: Any) {
        resetRestTimer(seconds: Int (restStepper.value))
    }
    
    @IBAction func repeatBtnPressed(_ sender: Any) {
        overallTimerLbl.text = "00 : 00 : 00"
        
        stop()
        resetAll()
    }
    
    @IBAction func setsStepperPressed(_ sender: Any) {
        resetSets(sets: setsStepper.value)
    }
    
}

extension HomeVC {
    // Selectors
    @objc func dismissKeyboard(_ recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func addItem(_ notif: Notification) {
        var selectedItem = routinePckr.selectedRow(inComponent: 0)
        
        workoutBreakdown.removeAll()
        for thing in workoutService.items {
            if thing.setList == nil {
                if thing.description.contains(":") {
                    workoutBreakdown.append(Routine(title: thing.title, time: thing.description))
                } else {
                    workoutBreakdown.append(Routine(title: thing.title, count: gf.strToInt(str: thing.description)))
                }
            } else {
                for routineInSet in thing.setList {
                    workoutBreakdown.append(routineInSet)
                }
            }
        }
        
        itemsCount = workoutBreakdown.count
        routinePckr.reloadAllComponents()
        
        if selectedItem >= itemsCount {
            routinePckr.selectRow(itemsCount - 1, inComponent: 0, animated: true)
            selectedItem = routinePckr.selectedRow(inComponent: 0)
        }
        
        setProgress(selected: selectedItem)
    }
    
    @objc func updateTimer(_ timer: Timer) {
        if totalTime != 0 {
            totalTime -= 1
            
            let time = gf.getTimeString(seconds: totalTime)
            progressLbl.text = "\(time[1]) : \(time[0])"
        } else {
            stopTimer()
            activateAudio()
            
            let nextRow = routinePckr.selectedRow(inComponent: 0) + 1
            
            let url = Bundle.main.url(forResource: "Sounds/C", withExtension: "wav")
            player = try! AVAudioPlayer(contentsOf: url!)
            player.delegate = self
            player.play()
            
            if itemsCount > nextRow {
                routinePckr.selectRow(nextRow, inComponent: 0, animated: true)
                setProgress(selected: nextRow)
                
                startRestTimer()
            } else {
                setProgress(selected: nextRow - 1)
                
                if setsStepper.value > 1 {
                    setsStepper.value -= 1
                    
                    resetAll()
                    startRestTimer()
                } else {
                    stop()
                    setsStepper.value = 1
                
                    resetAll()
                }
            }
        }
    }
    
    @objc func restTimer(_ timer: Timer) {
        let items = workoutBreakdown
        let row = routinePckr.selectedRow(inComponent: 0)
        
        if totalTime != 0 {
            totalTime -= 1
            
            resetRestTimer(seconds: totalTime)
        } else {
            stopTimer()
            activateAudio()
            resetRestTimer(seconds: Int (restStepper.value))
            
            let url = Bundle.main.url(forResource: "Sounds/B", withExtension: "wav")
            player = try! AVAudioPlayer(contentsOf: url!)
            player.delegate = self
            player.play()
            
            if isStarted {
                if items[row].count == nil {
                    startTimer()
                }
            } else {
                start()
                stopTimer()
                
                if items[row].count == nil {
                    startTimer()
                }
            }
        }
    }
    
    @objc func updateOverallTimer(_ timer: Timer) {
        overallTotalTime += 1
        
        let time = gf.getTimeString(seconds: overallTotalTime)
        overallTimerLbl.text = "\(time[2]) : \(time[1]) : \(time[0])"
    }
    
    // Customs
    func setProgress(selected: Int) {
        if itemsCount != 0 {
            let item = workoutBreakdown[selected]
            
            if item.count == nil {
                progressLbl.text = item.time
            } else {
                progressLbl.text = "\(item.count!) Counts"
            }
        } else { progressLbl.text = "" }
    }
    
    func stopTimer() {
        timer.invalidate()
    }
    
    func startTimer() {
        let time = gf.getTimeInt(timeStr: progressLbl.text!)
        totalTime = gf.getTotalSeconds(time: [time[0], time[1], 0])
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer(_:)), userInfo: nil, repeats: true)
    }
    
    func startRestTimer() {
        if !isStarted {
            totalTime = 3
        } else {
            totalTime = Int (restStepper.value)
        }
        
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(restTimer(_:)), userInfo: nil, repeats: true)
    }
    
    func resetRestTimer(seconds: Int) {
        let time = gf.getTimeString(seconds: seconds)
        restCountLbl.text = "\(time[1]) : \(time[0])"
    }
    
    func resetSets(sets: Double) {
        setsLbl.text = gf.zeroLeftPadding(str: String (Int (sets)))
    }
    
    func resetAll(_ index: Int = 0) {
        stopTimer()
        
        routinePckr.selectRow(index, inComponent: 0, animated: true)
        setProgress(selected: index)
         
        resetRestTimer(seconds: Int (restStepper.value))
        resetSets(sets: setsStepper.value)
    }
    
    func activateAudio() {
        do {
            try session.setCategory(.playback, options: .duckOthers)
            try session.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
        }
    }
    
    func startOverallTimer() {
        let time = gf.getTimeInt(timeStr: overallTimerLbl.text!)
        overallTotalTime = gf.getTotalSeconds(time: [time[0], time[1], time[2]])
        overallTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateOverallTimer(_:)), userInfo: nil, repeats: true)
    }
    
    func stop() {
        overallTimer.invalidate()
        startBtn.setImage(UIImage(systemName: "play.fill"), for: .normal)
        isStarted = false
    }
    
    func start() {
        startBtn.setImage(UIImage(systemName: "stop.fill"), for: .normal)
        isStarted = true
    }
}

extension HomeVC : UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return itemsCount
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 80
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = UILabel()
        if let v = view {
            label = v as! UILabel
        }
        
        label.font = UIFont(name: "AvenirNext-Heavy", size: 25)
        label.text =  workoutBreakdown[row].title
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 2
        label.textAlignment = .center
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        stop()
        stopTimer()

        setProgress(selected: row)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}

extension HomeVC : AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        do {
            try session.setActive(false)
        } catch {
            print(error)
        }
    }
}
