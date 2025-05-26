//
//  FavoritesView.swift
//  Unsplash Photo Picker
//
//  Created by User on 24.05.25.
//

import SwiftUI

struct FavoritesView: View {
    @State private var favorites : [Photo] = []
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView{
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(favorites, id: \.id) { photo in
                        NavigationLink(destination: PhotoDetailView(photo: photo)) {
                            PhotoItemView(photo: photo, isBookmarked: true){ tappedPhoto in
                                FileManagerService.shared.delete(tappedPhoto, from: .favoriteDirectory)
                                favorites = FileManagerService.shared.load(from: .favoriteDirectory)
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .onAppear() {
                    favorites = FileManagerService.shared.load(from: .favoriteDirectory)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Favorites")
                        .font(.title.bold())
                }
            }
            
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
