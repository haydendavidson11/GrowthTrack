//
//  GrowthTrackApp.swift
//  GrowthTrack
//
//  Created by Hayden Davidson on 12/6/21.
//

import SwiftUI

@main
struct GrowthTrackApp: App {
    @StateObject var dataController: DataController
    
    init() {
        let dataController = DataController()
        _dataController = StateObject(wrappedValue: dataController)
    }
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
        }
    }
}
