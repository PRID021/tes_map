//
//  ItemInfoView.swift
//  map_t
//
//  Created by TE-Member on 18/12/2023.
//

import SwiftUI
import _MapKit_SwiftUI

struct ItemInfoView: View {
    var selectedResult: MKMapItem
    var route: MKRoute?
    @State private var lookAroundScene: MKLookAroundScene?
    
    private var travelTime: String? {
        guard let route else { return nil }
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle  = .abbreviated
        formatter.allowedUnits  = [.hour, .minute]
        return formatter.string(from: route.expectedTravelTime )
    }
    
    func getLookAroundScene(){
            lookAroundScene = nil
        Task{
            let request = MKLookAroundSceneRequest(mapItem: selectedResult)
            lookAroundScene = try? await request.scene
        }
    }
    
    var body: some View {
        LookAroundPreview(initialScene: lookAroundScene)
            .overlay(alignment: .bottomTrailing){
                HStack{
                    Text("\(selectedResult.name ?? "")")
                    if let travelTime {
                        Text(travelTime)
                    }
                }
                .font(.caption)
                .foregroundStyle(.white)
                .padding(10)
            }
            .onAppear{
                getLookAroundScene()
            }
            .onChange(of: selectedResult){
                getLookAroundScene()
            }
    }
    
}

