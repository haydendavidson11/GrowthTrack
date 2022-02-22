//
//  ExtensionTests.swift
//  GrowthTrackTests
//
//  Created by Hayden Davidson on 2/9/22.
//

import SwiftUI
import XCTest
@testable import GrowthTrack

class ExtensionTests: XCTestCase {

    func testDecodingAwardsFromBundle() {
        let awards = Bundle.main.decode([Award].self, from: "Awards.json")
        XCTAssertFalse(awards.isEmpty, "Awards.json should decode a non-empty array.")
    }

    func testDecodingStringFromBundle() {
        let bundle = Bundle(for: ExtensionTests.self)
        let data = bundle.decode(String.self, from: "DecodableString.json")
        XCTAssertEqual(data, "The rain in Spain falls mainly on the Spaniards.",
                       "The String must match the content of DecodableString.json")
    }

    func testDecodingDictionaryFromBundle() {
        let bundle = Bundle(for: ExtensionTests.self)
        let data = bundle.decode([String: Int].self, from: "DecodableDictionary.json")
        XCTAssertEqual(data,
                       ["One": 1, "Two": 2, "Three": 3],
                       "The decoded content should match the content of DecodableDictionary.json")
    }

    func testBindingOnChange() {
        // Given
        var onChangeFunctionRun = false

        func exampleFunctionToCall() {
            onChangeFunctionRun = true
        }

        var storedValue = ""

        let binding = Binding(
            get: { storedValue },
            set: { storedValue = $0 }
        )

        let changedBinding = binding.onChange(exampleFunctionToCall)

        // When
        changedBinding.wrappedValue = "Test"

        // Then
        XCTAssertTrue(onChangeFunctionRun, "The onChange() function must be run when the is changed.")
    }

}
