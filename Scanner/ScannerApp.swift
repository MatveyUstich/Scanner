//
//  ScannerApp.swift
//  Scanner
//
//  Created by Александр Устич on 17.03.2023.
//

import SwiftUI

@main
struct ScannerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
