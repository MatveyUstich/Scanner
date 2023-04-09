//
//  MainView.swift
//  Scanner
//
//  Created by Александр Устич on 22.03.2023.
//

import SwiftUI

struct MainView: View {
    
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label("Documents", systemImage: "doc.text")
                }
//                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
