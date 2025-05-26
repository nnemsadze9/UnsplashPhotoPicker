//
//  ContentView.swift
//  Unsplash Photo Picker
//
//  Created by User on 24.05.25.
//

import SwiftUI

struct UnsplashTabView: View {
    var body: some View {
        TabView {
            PhotoPickerView()
                .tabItem {
                    Image(systemName: "safari")
                    Text("Explore")
                }
            FavoritesView()
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Favorites")
                }
            
            DownloadsView()
                .tabItem {
                    Image(systemName: "icloud.and.arrow.down.fill")
                    Text("Downloads")
                }
        }
    }
}

#Preview {
    UnsplashTabView()
}
