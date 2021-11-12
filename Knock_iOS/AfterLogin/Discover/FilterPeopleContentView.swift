//
//  FilterPeopleContentView.swift
//  Knock_iOS
//
//  Created by yusong on 10/30/21.
//

import SwiftUI

struct FilterPeopleContentView: View {
    @State var price = 10.00
    @State var showMap: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var locationManager: LocationManager
    
    var body: some View {
        ZStack {
            Rectangle().fill(Color(Constants.themeColor)).ignoresSafeArea()
            VStack {
                HStack {
                    Text("Location")
                    Spacer()
                    Text(self.locationManager.address)
                    if self.showMap {
                        Image(systemName: "arrowtriangle.down.fill").font(.system(size: 16, weight: .regular))
                    }
                    else {
                        Image(systemName: "arrowtriangle.forward.fill").font(.system(size: 16, weight: .regular))
                    }
                    
                }
                .padding(20)
                .foregroundColor(.white)
                .onTapGesture {
                    withAnimation {
                        self.showMap.toggle()
                    }
                }
                if self.showMap {
                    LocationContentView(locationManager: self.locationManager)
                }
                
                Divider().background(Color(.white))
                
                VStack {
                    HStack {
                        Text("Price (per hour)")
                        Spacer()
                        Text("$0.00 - $\(Int(price)).00")
                    }
                    HStack {
                        Button(action: {
                            
                        }, label: {
                            Text("Free")
                        })
                        Divider().background(Color(.white))
                        Button(action: {
                            
                        }, label: {
                            Text("Range")
                        })
                        Slider(value: $price, in: 0...10000, onEditingChanged: {_ in }).accentColor(.white)
                    }
                }
                .foregroundColor(.white)
                .padding(20)
                .frame(height: 120)
                
                Divider().background(Color(.white))
                
                VStack {
                    HStack {
                        Text("Meeting Methods")
                        Spacer()
                    }.padding()
                    HStack(spacing: 60) {
                        VStack {
                            Image(systemName: "phone.fill").font(.system(size: 16, weight: .regular))
                            Text("Phone")
                        }
                        VStack {
                            Image(systemName: "video.fill").font(.system(size: 16, weight: .regular))
                            Text("Video")
                        }
                        VStack {
                            Image(systemName: "person.fill").font(.system(size: 16, weight: .regular))
                            Text("In-Person")
                        }
                    }
                }.foregroundColor(.white)
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Filter").foregroundColor(.white).padding().overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 1)).foregroundColor(.white)
                })
            }
        }
        .onAppear {
            self.locationManager.lookUpCurrentLocation { placemark in
                
            }
        }
    }
}

struct FilterPeopleContentView_Previews: PreviewProvider {
    static var previews: some View {
        FilterPeopleContentView(locationManager: LocationManager())
    }
}
