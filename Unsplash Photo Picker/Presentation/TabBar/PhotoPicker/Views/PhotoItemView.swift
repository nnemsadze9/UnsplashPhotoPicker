//
//  PhotoItemView.swift
//  Unsplash Photo Picker
//
//  Created by User on 25.05.25.
//

import SwiftUI
struct PhotoItemView: View {
    let photo: Photo
    let isBookmarked: Bool
    let onToggleBookmark: (Photo) -> Void
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            if let url = URL(string: photo.urls.regular) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ZStack{
                        Color.gray.opacity(0.3)
                        ProgressView()
                    }
                }
                .frame(width: 180, height: 250)
                .clipped()
                .cornerRadius(10)
                
                Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                    .foregroundColor(isBookmarked ? .yellow : .white)
                    .padding(8)
                    .background(Color.black.opacity(0.4))
                    .clipShape(Circle())
                    .padding(8)
                    .onTapGesture {
                        onToggleBookmark(photo)
                    }
            }
        }
    }
}
