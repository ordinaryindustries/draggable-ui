//
//
// DragTest
//
// Created by Ordinary Industries on 12/30/23.
// Copyright (c) 2023 Ordinary Industries. All rights reserved.
//
// Twitter: @OrdinaryInds
// TikTok: @OrdinaryInds
//


import SwiftUI

@main
struct DraggableUIApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .persistentSystemOverlays(.hidden)
                .statusBarHidden()
        }
    }
}
