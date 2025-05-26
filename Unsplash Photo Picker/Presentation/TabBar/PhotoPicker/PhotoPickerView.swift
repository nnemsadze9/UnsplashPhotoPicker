//
//  PhotoPickerView.swift
//  Unsplash Photo Picker
//
//  Created by User on 24.05.25.
//

import SwiftUI

enum OrientationFilter: String, CaseIterable, Identifiable {
    case all = "All"
    case landscape = "Landscape"
    case portrait = "Portrait"
    case squarish = "Squarish"
    
    var id: String { self.rawValue }
}

struct PhotoPickerView: View {
    @ObservedObject var viewModel = PhotoPickerVM()
    
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    private var photos: [Photo] = []
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView{
                SearchBarView(searchText: $viewModel.searchText)
                    .onChange(of: viewModel.searchText){
                        viewModel.fetchPhotos()
                    }
                Picker("Orientation", selection: $viewModel.filterType) {
                    ForEach(OrientationFilter.allCases) { option in
                        Text(option.rawValue)
                            .tag(option)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 16)
                .padding(.top, -15)
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(viewModel.photos.indices, id: \.self) { index in
                        let photo = viewModel.photos[index]
                        
                        NavigationLink(destination: PhotoDetailView(photo: photo)) {
                            PhotoItemView(
                                photo: photo,
                                isBookmarked: viewModel.isFavorite(photo),
                                onToggleBookmark: { tappedPhoto in
                                    viewModel.toggleFavorite(for: tappedPhoto)
                                }
                            )
                            .onAppear {
                                if index == viewModel.photos.count - 1 {
                                    viewModel.fetchPhotos()
                                }
                            }
                            
                        }
                    }
                }
                .padding(.horizontal, 16)
                
                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Explore")
                        .font(.title.bold())
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isDarkMode.toggle()
                    }) {
                        Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
                            .imageScale(.large)
                            .foregroundColor(.primary)
                    }
                }
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
            
        }
    }
}

struct PhotoPickerView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoPickerView()
    }
}
