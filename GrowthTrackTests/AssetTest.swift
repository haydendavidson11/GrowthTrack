//
//  AssetTest.swift
//  GrowthTrackTests
//
//  Created by Hayden Davidson on 2/8/22.
//

import XCTest
@testable import GrowthTrack

class AssetTest: XCTestCase {
    func testColorsExist() {
        for color in Project.colors {
            XCTAssertNotNil(UIColor(named: color), "Failed to load color '\(color)' from asset catalog")
        }
    }

    func testJSONLoadsCorrectly() {
        XCTAssertFalse(Award.allAwards.isEmpty, "Failed to load awards from JSON.")
    }

}
