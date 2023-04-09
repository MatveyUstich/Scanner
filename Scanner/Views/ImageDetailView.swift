//
//  ImageDetailView.swift
//  Scanner
//
//  Created by Александр Устич on 07.04.2023.
//

import SwiftUI

struct ImageDetailView: View {
    var image: UIImage
    
    var body: some View {
        VStack {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .padding()
            
            Spacer()
        }
        .navigationBarTitle("Document", displayMode: .inline)
    }
}




struct ImageDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ImageDetailView(image: UIImage(named: "1.3.4-SetHeight_grey")!)
    }
}
