//
//  AgriARVisonProApp.swift
//  AgriARVisonPro
//
//  Created by Lukas Burkhardt on 01.10.24.
//

import SwiftUI

@main
struct AgriARVisonProApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }.immersionStyle(selection: .constant(.full), in: .full)
    }
}
