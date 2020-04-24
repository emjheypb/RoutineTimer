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
        Routine(title: "Rest", time: "01 : 30"),
        Routine(title: "Rest", time: "00 : 30"),
        Routine(title: "Punches", time: "03 : 00"),
        Routine(title: "Calf Raises", count: 10),
        Routine(title: "March Steps", count: 20),
        Routine(title: "Squats", count: 2)
    ]

    let setData = [
        SetRoutines(title: "Test Count", routines: [
                Routine(title: "C1", count: 1),
                Routine(title: "C2", count: 2),
                Routine(title: "C3", count: 3)
            ], isCollapsed: false),
        SetRoutines(title: "Test Time", routines: [
                Routine(title: "T1", time: "00 : 01"),
                Routine(title: "T2", time: "00 : 02"),
                Routine(title: "T3", time: "00 : 03")
            ], isCollapsed: false),
        SetRoutines(title: "Test Mix Time", routines: [
                Routine(title: "T1", time: "00 : 01"),
                Routine(title: "C2", count: 2),
                Routine(title: "T3", time: "00 : 03")
            ], isCollapsed: false),
        SetRoutines(title: "Test Mix Count", routines: [
                Routine(title: "C1", count: 1),
                Routine(title: "T2", time: "00 : 02"),
                Routine(title: "C3", count: 3)
            ], isCollapsed: false),
        SetRoutines(title: "Morning Stretch", routines: [
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
            ], isCollapsed: false),
        SetRoutines(title: "Recovery Workout", routines: [
                Routine(title: "Low Side Leg Raise (R)", count: 30),
                Routine(title: "Hip Rotation (R)", count: 6),
                Routine(title: "Low Side Leg Raise (L)", count: 30),
                Routine(title: "Hip Rotation (L)", count: 6),
                Routine(title: "Straight Leg Back Swing (R)", count: 30),
                Routine(title: "Hip Rotation (R)", count: 6),
                Routine(title: "Straight Leg Back Swing (L)", count: 30),
                Routine(title: "Hip Rotation (L)", count: 6),
                Routine(title: "Back and Forth Head Tilt", count: 6),
                Routine(title: "Side-to-Side Head Tilt", count: 6),
                Routine(title: "Head Rotation (R)", count: 3),
                Routine(title: "Head Rotation (L)", count: 3)
            ], isCollapsed: false)
    ]
}
