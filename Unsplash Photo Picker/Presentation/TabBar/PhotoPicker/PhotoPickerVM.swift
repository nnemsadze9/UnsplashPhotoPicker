//
//  PhotoPickerVM.swift
//  Unsplash Photo Picker
//
//  Created by User on 24.05.25.
//

import Foundation

@MainActor class PhotoPickerVM: ObservableObject {
    
    private let photoRepository: PhotoRepositoryProtocol!
    
    @Published var photos: [Photo] = []
    @Published var favorites: [Photo] = []
    @Published var isLoading = false
    @Published var searchText = "" {
        didSet{
            isSearching = !searchText.isEmpty
        }
    }
    @Published var filterType: OrientationFilter = .all {
        didSet {
            page = 1
            photos = []
            fetchPhotos()
            searchText = ""
        }
    }
    
    private var page: Int = 1
    private var isSearching = false {
        willSet {
            if isSearching != newValue || isSearching {
                page = 1
                photos = []
            }
        }
    }
    
    func loadFavorites() {
        favorites = FileManagerService.shared.load(from: .favoriteDirectory)
    }
    
    func isFavorite(_ photo: Photo) -> Bool {
        favorites.contains(where: { $0.id == photo.id })
    }
    
    func toggleFavorite(for photo: Photo) {
        if isFavorite(photo) {
            FileManagerService.shared.delete(photo, from: .favoriteDirectory)
            favorites.removeAll { $0.id == photo.id }
        } else {
            FileManagerService.shared.save(photo, to: .favoriteDirectory)
            favorites.append(photo)
        }
    }
    
    init(photoRepository: PhotoRepositoryProtocol = PhotoRepository(client: .shared)) {
        self.photoRepository = photoRepository
        fetchPhotos()
    }
    
    func fetchPhotos() {
        let hasQuery = !searchText.trimmingCharacters(in: .whitespaces).isEmpty
        let isFilterAll = filterType == .all
        Task{
            switch (hasQuery, isFilterAll) {
                
            case (false, true):
                photos += try await photoRepository.getPhotos(page: page)
            case(true, true):
                photos += try await photoRepository.searchPhotos(query: searchText, page: page).results
            case(_ , _):
                photos += try await photoRepository.searchFilteredPhotos(query: searchText, filter: filterType, page: page).results
            }
        }
        page += 1
        isLoading = false
    }
}
