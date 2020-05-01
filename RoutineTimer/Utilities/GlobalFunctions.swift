//
//  GlobalFunctions.swift
//  RoutineTimer
//
//  Created by Mariah Baysic on 4/18/20.
//  Copyright © 2020 SpacedOut. All rights reserved.
//

import Foundation

class GlobalFunctions {
    func getTimeInt(timeStr: String) -> [Int] {
        let time = timeStr.split{$0 == ":"}.map(String.init)
        
        switch time.count {
        case 3:
            return [strToInt(str: time[2]), strToInt(str: time[1]), strToInt(str: time[0])]
        case 2:
            return [strToInt(str: time[1]), strToInt(str: time[0]), 0]
        case 1:
            return [strToInt(str: time[0]), 0, 0]
        default:
            return [0, 0, 0]
        }
    }
    
    func getTimeString(seconds: Int) -> [String] {
        let h = (seconds / 60) / 60
        let m = (seconds / 60) % 60
        let s = (seconds % 60) % 60
        
        let hrs = zeroLeftPadding(str: String (h))
        let mins = zeroLeftPadding(str: String (m))
        let secs = zeroLeftPadding(str: String (s))
        
        return [secs, mins, hrs]
    }
    
    func getTotalSeconds(time: [Int]) -> Int {
        return ((time[2] * 60) * 60) + (time[1] * 60) + time[0]
    }
    
    func zeroLeftPadding(str: String) -> String {
        return "".padding(toLength: 2 - str.count, withPad: "0", startingAt: 0) + str
    }
    
    func strToInt(str: String) -> Int {
        return Int (str.trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
    }
}
