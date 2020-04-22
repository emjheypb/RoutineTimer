//
//  RoutineTimerTesting.swift
//  RoutineTimerTesting
//
//  Created by Mariah Baysic on 4/21/20.
//  Copyright © 2020 SpacedOut. All rights reserved.
//

import XCTest

class RoutineTimerTesting: XCTestCase {
    let gf = GlobalFunctions()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGetTimeInt() {
        XCTAssertEqual(gf.getTimeInt(timeStr: ""), [0,0,0])
        XCTAssertEqual(gf.getTimeInt(timeStr: "01"), [1,0,0])
        XCTAssertEqual(gf.getTimeInt(timeStr: "00:01"), [1,0,0])
        XCTAssertEqual(gf.getTimeInt(timeStr: "00:00:01"), [1,0,0])
        XCTAssertEqual(gf.getTimeInt(timeStr: "00 : 01"), [1,0,0])
        XCTAssertEqual(gf.getTimeInt(timeStr: "00 : 00 : 01"), [1,0,0])
        
        XCTAssertEqual(gf.getTimeInt(timeStr: "01:02"), [2,1,0])
        XCTAssertEqual(gf.getTimeInt(timeStr: "00:01:02"), [2,1,0])
        XCTAssertEqual(gf.getTimeInt(timeStr: "01 : 02"), [2,1,0])
        XCTAssertEqual(gf.getTimeInt(timeStr: "00 : 01 : 02"), [2,1,0])
        
        XCTAssertEqual(gf.getTimeInt(timeStr: "01:02:03"), [3,2,1])
        XCTAssertEqual(gf.getTimeInt(timeStr: "01 : 02 : 03"), [3,2,1])
    }
    
    func testGetTimeString() {
        XCTAssert(gf.getTimeString(seconds: 1) == ["01","00","00"])
        XCTAssert(gf.getTimeString(seconds: 60) == ["00","01","00"])
        XCTAssert(gf.getTimeString(seconds: 3600) == ["00","00","01"])
    }
    
    func testGetTotalSeconds() {
        XCTAssert(gf.getTotalSeconds(time: [1, 0, 0]) == 1)
        XCTAssert(gf.getTotalSeconds(time: [1, 1, 0]) == 61)
        XCTAssert(gf.getTotalSeconds(time: [1, 1, 1]) == 3661)
    }

}
