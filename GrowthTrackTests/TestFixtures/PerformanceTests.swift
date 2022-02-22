//
//  PerformanceTests.swift
//  GrowthTrackTests
//
//  Created by Hayden Davidson on 2/21/22.
//

import XCTest
@testable import GrowthTrack

class PerformanceTests: BaseTestCase {

    func testAwardCalculationPerformance() throws {
        // Create a large amount of sample data
        for _ in 1...100 {
            try dataController.createSampleData()
        }

        // Create a large amount of awards to check
        let awards = Array(repeating: Award.allAwards, count: 25).joined()
        XCTAssertEqual(awards.count, 500, "This checks the awards count is constant. Change this if you add awards.")

        measure {
            _ = awards.filter(dataController.hasEarned)
        }
    }
}
