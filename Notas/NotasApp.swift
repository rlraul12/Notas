//
//  NotasApp.swift
//  Notas
//
//  Created by Raul Paneque on 11/13/23.
//

import SwiftUI

@main
struct NotasApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 320, minHeight: 400)
        }
        .windowResizability(.contentSize)
        .modelContainer(for: [Note.self, NoteCategory.self])
    }
}
