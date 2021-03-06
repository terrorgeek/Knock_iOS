//
//  Knock_iOSApp.swift
//  Knock_iOS
//
//  Created by yusong on 10/27/21.
//

import SwiftUI

@main
struct Knock_iOSApp: App {
    var body: some Scene {
        WindowGroup {
            PreLaunch()
        }
    }
    
    static func returnAndSetOnBoardingCurrentItemToLogin() -> OnBoardingObserver {
        let onBoardingObserver = OnBoardingObserver()
        onBoardingObserver.onBoardingCurrentItem = "login"
        return onBoardingObserver
    }
}
