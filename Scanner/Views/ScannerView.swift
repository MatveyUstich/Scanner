//
//  ScannerView.swift
//  Scanner
//
//  Created by Александр Устич on 17.03.2023.
//

import SwiftUI
import VisionKit
import CoreData

struct ScannerView: UIViewControllerRepresentable {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode

    func makeUIViewController(context: UIViewControllerRepresentableContext<ScannerView>) -> VNDocumentCameraViewController {
        let scannerViewController = VNDocumentCameraViewController()
        scannerViewController.delegate = context.coordinator
//        scannerViewController.modalPresentationStyle = .fullScreen
        return scannerViewController
    }

    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: UIViewControllerRepresentableContext<ScannerView>) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        var parent: ScannerView

        init(_ parent: ScannerView) {
            self.parent = parent
        }

        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            for pageIndex in 0..<scan.pageCount {
                let image = scan.imageOfPage(at: pageIndex)
                let imageData = image.jpegData(compressionQuality: 1.0)
                let scannedDocument = ScannedDocument(context: parent.viewContext)
                scannedDocument.imageData = imageData
                scannedDocument.dateAdded = Date()
            }
            parent.presentationMode.wrappedValue.dismiss()
            parent.saveContext()
        }

        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            parent.presentationMode.wrappedValue.dismiss()
        }

        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            parent.presentationMode.wrappedValue.dismiss()
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
