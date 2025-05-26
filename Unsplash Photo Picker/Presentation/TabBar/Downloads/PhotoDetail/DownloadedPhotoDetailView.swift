//
//  DownloadDetailView.swift
//  Unsplash Photo Picker
//
//  Created by User on 26.05.25.
//

import SwiftUI

struct DownloadedPhotoDetailView: View {
    let photo: DownloadedPhoto
    
    var body: some View {
        VStack {
            Spacer()
            AsyncImage(url: photo.url) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ZStack{
                    Color.gray.opacity(0.2)
                    ProgressView()
                }
            }
            Spacer()
            
            Text(photo.name)
                .font(.headline)
                .padding()
            
            Text(photo.date, style: .date)
                .font(.subheadline)
                .foregroundColor(.gray)
            
        }
        .padding()
        .navigationTitle("Photo")
        .navigationBarTitleDisplayMode(.inline)
    }
}
