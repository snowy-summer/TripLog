//
//  LocationDTO.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/18.
//

import MapKit

struct LocationDTO: Identifiable {
    var id = UUID()
    var mapItem: MKMapItem?
        
}

extension LocationDTO: Hashable {
    
    static func == (lhs: LocationDTO, rhs: LocationDTO) -> Bool {
        lhs.id.hashValue == rhs.id.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
