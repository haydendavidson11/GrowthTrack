//
//  DevelopmentTests.swift
//  GrowthTrackTests
//
//  Created by Hayden Davidson on 2/9/22.
//

import CoreData
import XCTest
@testable import GrowthTrack

class DevelopmentTests: BaseTestCase {

    func testSampleDataCreationWorks() throws {
        try dataController.createSampleData()

        XCTAssertEqual(dataController.count(for: Project.fetchRequest()), 5, "There should be 5 sample projects.")
        XCTAssertEqual(dataController.count(for: Item.fetchRequest()), 50, "There should 50 sample items.")
    }

    func testDeleteAllClearsEverything() throws {

        // Given
        try dataController.createSampleData()

        // When
        dataController.deleteAll()

        // Then
        XCTAssertEqual(dataController.count(
            for: Project.fetchRequest()), 0,
                       "There should be 0 sample projects after deleteAll().")
        XCTAssertEqual(dataController.count(
            for: Item.fetchRequest()), 0,
                       "There should 0 sample items after deleteAll().")
    }

    func testExampleProjectIsClosed() {
        let project = Project.example
        XCTAssertTrue(project.closed, "The example project should be closed.")
    }

    func testExampleItemIsHighPriority() {
        let item = Item.example
        XCTAssertEqual(item.priority, 3, "The example item should be high priority.")
    }

}
