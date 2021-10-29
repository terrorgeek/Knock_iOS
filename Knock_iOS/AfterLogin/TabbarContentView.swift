//
//  TabbarContentView.swift
//  Knock_iOS
//
//  Created by yusong on 10/27/21.
//

import SwiftUI

struct TabbarContentView: View {
    var body: some View {
        TabView {
            DiscoverContentView().tabItem {
                Image(systemName: "magnifyingglass.circle").font(.system(size: 50, weight: .regular))
            }
            
            Text("").tabItem {
                Image(systemName: "envelope").font(.system(size: 50, weight: .regular))
            }
            
            Text("").tabItem {
                Image(systemName: "calendar").font(.system(size: 50, weight: .regular))
            }
            
            Text("").tabItem {
                Image(systemName: "person").font(.system(size: 50, weight: .regular))
            }
        }
    }
}

struct TabbarContentView_Previews: PreviewProvider {
    static var previews: some View {
        TabbarContentView()
    }
}
