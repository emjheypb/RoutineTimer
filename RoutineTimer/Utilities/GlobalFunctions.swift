//
//  GlobalFunctions.swift
//  RoutineTimer
//
//  Created by Mariah Baysic on 4/18/20.
//  Copyright © 2020 SpacedOut. All rights reserved.
//

import Foundation

class GlobalFunctions {
    func getTimeInt(timeStr: String) -> [String : Int] {
        let time = timeStr.split{$0 == ":"}.map(String.init)
        
        switch time.count {
        case 3:
            return ["hours" : strToInt(str: time[0]), "minutes" : strToInt(str: time[1]), "seconds" : strToInt(str: time[2])]
        case 2:
            return ["hours" : 0, "minutes" : strToInt(str: time[0]), "seconds" : strToInt(str: time[1])]
        default:
            return ["hours" : 0, "minutes" : 0, "seconds" : strToInt(str: time[0])]
        }
    }
    
    func getTimeString(seconds: Int) -> [String : String] {
        let h = (seconds / 60) / 60
        let m = (seconds / 60) % 60
        let s = (seconds % 60) % 60
        
        let hrs = zeroLeftPadding(str: String (h))
        let mins = zeroLeftPadding(str: String (m))
        let secs = zeroLeftPadding(str: String (s))
        
        return ["hours" : hrs, "minutes" : mins, "seconds" : secs]
    }
    
    func getTotalSeconds(hrs: Int, mins: Int, secs: Int) -> Int {
        return ((hrs * 60) * 60) + (mins * 60) + secs
    }
    
    func zeroLeftPadding(str: String) -> String {
        return "".padding(toLength: 2 - str.count, withPad: "0", startingAt: 0) + str
    }
    
    func strToInt(str: String) -> Int {
        return Int (str.trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
    }
}
