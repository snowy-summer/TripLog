//
//  MapViewController.swift
//  TripLog
//
//  Created by 최승범 on 2024/03/13.
//

import MapKit

final class MapViewController: UIViewController {
    
    private let locationViewModel = SearchLocationViewModel()
    weak var delegate: MapViewControllerDelegate?
    
    private let mapView = MKMapView()
    private let searchViewController: SearchLocationViewController
    
    init(delegate: MapViewControllerDelegate? = nil) {
        self.delegate = delegate
        self.searchViewController = SearchLocationViewController(locationViewModel: locationViewModel)
        super.init(nibName: nil, bundle: nil)
      
        print("mapView 생성")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .basic
        savedLocationBind()
        configureMapView()
        configureNavigationBar()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        presentModal()
    }
    
    deinit {
        print("mapView 해제")
    }
    
}

extension MapViewController {
    
    private func savedLocationBind() {
         locationViewModel.savedLocation.observe { [weak self] location in
             self?.delegate?.updateLocation(location: location)
         }
     }
    
    private func presentModal() {
        
        searchViewController.isModalInPresentation = true
        searchViewController.delegate = self
        searchViewController.configureInformationViewDelegate(delegate: self)

        if let sheet = searchViewController.sheetPresentationController {
            
//            sheet.detents = [
//                CustomDetent.base.detent(view: self.view),
//                .large(),
//                CustomDetent.low.detent(view: self.view)
//            ]
            
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.largestUndimmedDetentIdentifier = .large
            sheet.selectedDetentIdentifier = CustomDetent.base.idetifier
    
        }
        
        self.present(searchViewController, animated: false)
    }
    
    @objc private func popViewController() {
        searchViewController.isModalInPresentation = false
        searchViewController.dismiss(animated: true)
        navigationController?.popViewController(animated: true)
    }
}

extension MapViewController: InformationViewDelegate {
    
    func popMapViewController() {
        searchViewController.dismiss(animated: true)
        navigationController?.popViewController(animated: true)
    }
    
    func hideInformationView() {
        searchViewController.isCollectionViewHidden(value: false)
        searchViewController.sheetPresentationController?.selectedDetentIdentifier = .large
    }
    
}

extension MapViewController: SearchLocationViewControllerDelegate {
    
    func updateMapView(where coordinate: CLLocationCoordinate2D) {
        mapView.removeAnnotations(mapView.annotations)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.01,
                                    longitudeDelta: 0.01)
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = coordinate
        
        mapView.setRegion(MKCoordinateRegion(center: coordinate,
                                             span: span),
                          animated: true)

        mapView.addAnnotation(annotation)
    }
}

//MARK: - Configuration

extension MapViewController {
    
    private func configureMapView() {
        view.addSubview(mapView)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.isPitchEnabled = false
        
        let mapViewConstraints = [
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ]
        
        NSLayoutConstraint.activate(mapViewConstraints)
    }
    
    private func configureNavigationBar() {
        let backButton = UIBarButtonItem(title: "뒤로가기",
                                         style: .plain,
                                         target: self,
                                         action: #selector(popViewController))
        
        navigationItem.leftBarButtonItem = backButton
    }
    
}