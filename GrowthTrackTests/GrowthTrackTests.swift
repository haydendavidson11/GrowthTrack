//
//  GrowthTrackTests.swift
//  GrowthTrackTests
//
//  Created by Hayden Davidson on 2/8/22.
//
import CoreData
import XCTest
@testable import GrowthTrack

class GrowthTrackTests: XCTestCase {

    var dataController: DataController!
    var managedObjectContext: NSManagedObjectContext!

    override func setUpWithError() throws {
        dataController = DataController(inMemory: true)
        managedObjectContext = dataController.container.viewContext
    }

}
