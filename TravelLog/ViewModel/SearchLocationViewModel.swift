//
//  SearchLocationViewModel.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/18.
//

import MapKit

final class SearchLocationViewModel {
    
    var list: Observable<[LocationDTO]> = Observable([])
    var savedLocation: Observable<LocationDTO> = Observable<LocationDTO>(LocationDTO())
    
    var savedLocationMapItem: MKMapItem? {
        savedLocation.value.mapItem
    }
    
}

extension SearchLocationViewModel {
    
    func selectedLocation(id: UUID) -> LocationDTO {
        let index = list.value.firstIndex { locationModel in
            locationModel.id == id
        }
        guard let index = index else { return LocationDTO() }
        
        return list.value[index]
        
    }
    
    func mapCoordinate(id: UUID) -> CLLocationCoordinate2D? {
        selectedLocation(id: id).mapItem?.placemark.coordinate
    }
    
    
}

extension SearchLocationViewModel {
    
    func updateSavedLocation(location: LocationDTO) {
        savedLocation.value = location
    }
    
    func updateSavedLocationMapItem(mapItem: MKMapItem?) {
        savedLocation.value.mapItem = mapItem
    }
    
    func openInMap() {
       savedLocationMapItem?.openInMaps()
    }
    
}

extension SearchLocationViewModel: MapSearchSeviceDelegate {
    
    func appendLocationModel(mapitem: MKMapItem?) {
        let locationModel = LocationDTO(mapItem: mapitem)
        list.value.append(locationModel)
    }
    
    func clearPlaces() {
        list.value.removeAll()
    }
}
