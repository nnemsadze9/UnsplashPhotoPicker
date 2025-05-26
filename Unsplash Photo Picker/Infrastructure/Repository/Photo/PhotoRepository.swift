//
//  PhotoRepository.swift
//  Unsplash Photo Picker
//
//  Created by User on 24.05.25.
//

protocol PhotoRepositoryProtocol{
    func getPhotos(page : Int) async throws -> [Photo]
    func searchPhotos(query: String, page: Int) async throws -> PhotoSearchResult
    func searchFilteredPhotos(query: String, filter: OrientationFilter, page:Int) async throws -> PhotoSearchResult
}

class PhotoRepository: PhotoRepositoryProtocol {
    let client : APIClient
    
    init(client: APIClient) {
        self.client = client
    }
    
    func getPhotos(page: Int) async throws -> [Photo] {
        let response : [Photo] = try await client.request(endpoint: Endpoint.getPhotos,
                                                          method: .get,
                                                          queryParameters: ["page" : page,
                                                                            "per_page": 20]
        )
        return response
    }
    
    
    func searchPhotos(query: String, page: Int) async throws -> PhotoSearchResult {
        
        let response : PhotoSearchResult = try await client.request(endpoint: Endpoint.searchPhotos,
                                                                    method: .get,
                                                                    queryParameters: ["query" : query,
                                                                                      "page": page,
                                                                                      "per_page": 20])
        return response
    }
    
    func searchFilteredPhotos(query: String, filter: OrientationFilter, page: Int) async throws -> PhotoSearchResult {
        print(query.isEmpty ? "Nature" : query)
        let response : PhotoSearchResult = try await client.request(endpoint: Endpoint.searchPhotos,
                                                                    method: .get,
                                                                    queryParameters: ["query" : query.isEmpty ? "Nature" : query,// I had to this because this endpoint doesnt support empty text
                                                                                      "page": page,
                                                                                      "per_page": 20,
                                                                                      "orientation": filter.rawValue.lowercased()])
        return response
    }
}
