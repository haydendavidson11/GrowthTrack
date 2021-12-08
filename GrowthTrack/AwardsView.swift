//
//  AwardsView.swift
//  GrowthTrack
//
//  Created by Hayden Davidson on 12/8/21.
//

import SwiftUI

struct AwardsView: View {
    static let tag: String? = "Awards"
    
    
    var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 100, maximum: 100))]
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(Award.allAwards) { award in
                        Button {
                            // No Action yet
                        } label: {
                            Image(systemName: award.image)
                                .resizable()
                                .scaledToFit()
                                .padding()
                                .frame(width: 100, height: 100)
                                .foregroundColor(Color.secondary.opacity(0.5))
                        }

                    }
                }
            }
        }
    }
}

struct AwardsView_Previews: PreviewProvider {
    static var previews: some View {
        AwardsView()
    }
}