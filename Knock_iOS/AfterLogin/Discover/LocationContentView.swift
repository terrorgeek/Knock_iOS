//
//  LocationContentView.swift
//  Knock_iOS
//
//  Created by yusong on 11/4/21.
//

import SwiftUI
import MapKit

extension LocationContentView {
    struct Location: Identifiable {
        let id = UUID()
        var coordinate: CLLocationCoordinate2D
    }
    static let defaultLat = 39.0504463
    static let defaultLon = -77.5046096
}

struct LocationContentView: View {
    @ObservedObject var locationManager: LocationManager
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: Self.defaultLat, longitude: Self.defaultLon), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    @State var searchClicked = false
    @ObservedObject var filterPeopleViewModel: FilterPeopleViewModel
    
    @State var places: [Location] = [
        Location(coordinate: CLLocationCoordinate2D(latitude: defaultLat, longitude: defaultLon))
    ]
    
    var body: some View {
        VStack {
            HStack {
                TextField("Enter you location..", text: self.$locationManager.queryFragment)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(.white), lineWidth: 2))
                    .foregroundColor(.white)
//                Button(action: {
//                    self.searchClicked = true
//                    self.filterPeopleViewModel.address = self.locationManager.queryFragment
//                    
//                }, label: {
//                    Text("Search").padding().background(Color(Constants.themeColor)).cornerRadius(10).foregroundColor(.white)
//                })
            }.padding()
            
            // Address autocomplete
            if locationManager.status == .result {
                List {
                    Group { () -> AnyView in
                        switch locationManager.status {
                        case .noResults: return AnyView(Text("No Results"))
                        case .error(let description): return AnyView(Text("Error: \(description)"))
                        default: return AnyView(EmptyView())
                        }
                    }.foregroundColor(Color.gray)
                    ForEach(locationManager.searchResults, id: \.self) { completionResult in
                        //Autocomplete for searching address, each address is clickable and let you choose, then get the lon/lat from the addess
                        Text(completionResult.title).onTapGesture {
                            
                            self.searchClicked = true
                            self.locationManager.status = .noResults
                            self.filterPeopleViewModel.address = completionResult.title
                            //self.locationManager.queryFragment = completionResult.title
                            
                            self.locationManager.getLocation(from: self.filterPeopleViewModel.address) { location in
                                if let location = location {
                                    self.filterPeopleViewModel.lat = String(location.latitude)
                                    self.filterPeopleViewModel.lon = String(location.longitude)
                                    
                                    //set the center of the map to user selected address
                                    self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                                    self.places = [Location(coordinate: location)]
                                }
                            }
                        }
                        
                    }
                }
                .listStyle(PlainListStyle())
            }
            
            //Actual maps
            if locationManager.status == .noResults || locationManager.status == .idle {
                ScrollView {
                    if self.searchClicked {
                        Map(coordinateRegion: $region, annotationItems: places) { place in
                            MapPin(coordinate: place.coordinate)
                        }.accentColor(Color(.systemPink))
                        .frame(width: 400, height: 300)
                        .cornerRadius(10)
                    }
                    else {
                        Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: .constant(.follow))
                            .accentColor(Color(.systemPink))
                            .frame(width: 400, height: 300)
                            .cornerRadius(10)
                            .onAppear {
                                //By default we set it to user's current location
                                self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: self.locationManager.lastLocation?.coordinate.latitude ?? Self.defaultLat, longitude: self.locationManager.lastLocation?.coordinate.longitude ?? Self.defaultLon), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
                            }
                    }
                }
            }
        }
    }
}

struct LocationContentView_Previews: PreviewProvider {
    static var previews: some View {
        LocationContentView(locationManager: LocationManager(), filterPeopleViewModel: FilterPeopleViewModel())
    }
}
