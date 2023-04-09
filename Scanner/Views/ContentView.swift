//
//  ContentView.swift
//  Scanner
//
//  Created by Александр Устич on 17.03.2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \ScannedDocument.dateAdded, ascending: true)])
    private var scannedDocuments: FetchedResults<ScannedDocument>
    
    private var groupedScannedDocuments: [Date: [ScannedDocument]] {
        Dictionary(grouping: scannedDocuments, by: { $0.dateAdded!.stripTime() })
    }
    
    @State private var isShowingScanner = false
    
    var body: some View {
        NavigationView {
            Group {
                if scannedDocuments.isEmpty {
                    VStack{
                        Text("No scanned documents yet")
                        Button(action: {
                            isShowingScanner = true
                        }) {
                            HStack {
                                Image(systemName: "doc.text.viewfinder")
                                    .font(.system(size: 20))
                                Text("Scan Documents")
                                    .fontWeight(.semibold)
                                    .font(.system(size: 20))
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding()
                        }
                    }
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], spacing: 16) {
                            ForEach(scannedDocuments) { document in
                                NavigationLink(destination: ImageDetailView(image: UIImage(data: document.imageData!)!)) {
                                    Image(uiImage: UIImage(data: document.imageData!)!)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 160, height: 160)
                                        .cornerRadius(10)
                                }
                                .contextMenu {
                                    Button(action: {
                                        // Add haptic feedback
                                        let generator = UINotificationFeedbackGenerator()
                                        generator.notificationOccurred(.success)
                                        
                                        // Delete document
                                        viewContext.delete(document)
                                        saveContext()
                                    }) {
                                        Label("Delete", systemImage: "trash")
                                    }
                                    Button(action: {
                                        // Add haptic feedback
                                        let generator = UIImpactFeedbackGenerator(style: .medium)
                                        generator.impactOccurred()
                                        
                                        // Share document
                                        let image = UIImage(data: document.imageData!)!
                                        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
                                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                                           let window = windowScene.windows.first {
                                            window.rootViewController?.present(activityViewController, animated: true, completion: nil)
                                        }
                                        
                                    }) {
                                        Label("Share", systemImage: "square.and.arrow.up")
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Documents")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isShowingScanner = true
                    }) {
                        Label("Scan", systemImage: "doc.text.viewfinder")
                    }
                }
            }
            .fullScreenCover(isPresented: $isShowingScanner) {
                ScannerView()
                    .environment(\.managedObjectContext, viewContext)
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


extension Date {
    func stripTime() -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: self)
        return calendar.date(from: components)!
    }
}
