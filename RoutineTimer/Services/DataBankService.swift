//
//  DataBank.swift
//  RoutineTimer
//
//  Created by Mariah Baysic on 4/22/20.
//  Copyright © 2020 SpacedOut. All rights reserved.
//

import Foundation

class DataBankService {
    static let instance = DataBankService()
    
    let routineData = [
        Routine(title: "Rest", time: "00 : 30"),
        Routine(title: "Rest", time: "01 : 00"),
        Routine(title: "Rest", time: "01 : 30"),
        Routine(title: "Punches", time: "03 : 00"),
        Routine(title: "Calf Raises", count: 10),
        Routine(title: "March Steps", count: 20)
    ]

    let setData = [
        SetRoutines(title: "Morning Stretches", routines: [
                Routine(title: "Overhead Shoulder", time: "00 : 30"),
                Routine(title: "Side Shoulder (R)", time: "00 : 15"),
                Routine(title: "Side Shoulder (L)", time: "00 : 15"),
                Routine(title: "Back Shoulder", time: "00 : 30"),
                Routine(title: "Core", time: "00 : 30"),
                Routine(title: "Hamstrings", time: "00 : 30"),
                Routine(title: "Glutes (R)", time: "00 : 15"),
                Routine(title: "Glutes (L)", time: "00 : 15"),
                Routine(title: "Quads (R)", time: "00 : 15"),
                Routine(title: "Quads (L)", time: "00 : 15"),
                Routine(title: "Calf Raises", time: "00 : 30")
            ], isCollapsed: false)
    ]
}
