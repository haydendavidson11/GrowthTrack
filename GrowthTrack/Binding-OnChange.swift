//
//  Binding-OnChange.swift
//  GrowthTrack
//
//  Created by Hayden Davidson on 12/8/21.
//

import SwiftUI

extension Binding {
    func onChange(_ handler: @escaping () -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue } ,
            set: { newValue in
                self.wrappedValue = newValue
                handler()
            }
        )
    }
}
