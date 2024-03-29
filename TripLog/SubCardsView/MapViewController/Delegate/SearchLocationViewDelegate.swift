//
//  SearchLocationViewControllerDelegate.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/21.
//

import Foundation
import CoreLocation

protocol SearchLocationViewDelegate: AnyObject {

    func updateMapView(where coordinate: CLLocationCoordinate2D, title: String?)
    func changeModalMaxConstraint()
    func changeModalLowConstraint()
    
}
