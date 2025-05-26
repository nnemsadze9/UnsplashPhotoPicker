//
//  ImageDownloadManager.swift
//  Unsplash Photo Picker
//
//  Created by User on 25.05.25.
//

import Foundation

enum FileManagerDestination : String {
    case downloadsDirectory = "donwloads_info.json"
    case favoriteDirectory = "favorites_info.json"
}

final class FileManagerService {
    static let shared = FileManagerService()
    private init() {}
    
    private func fileURL(for filename: String) -> URL {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return directory.appendingPathComponent(filename)
    }
    
    func save<T: Codable>(_ item: T, to fileDestination : FileManagerDestination) {
        let fileName = fileDestination.rawValue
        var items: [T] = load(from: fileDestination )
        items.append(item)
        
        do {
            let data = try JSONEncoder().encode(items)
            try data.write(to: fileURL(for: fileName))
        } catch {
            print("Error saving to \(fileName): \(error)")
        }
    }
    
    func load<T: Codable>(from fileDestination : FileManagerDestination) -> [T] {
        let fileName = fileDestination.rawValue
        let url = fileURL(for: fileName)
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode([T].self, from: data)
        } catch {
            print("Error loading from \(fileName): \(error)")
            return []
        }
    }
    
    func delete<T: Codable & Identifiable>(_ item: T, from fileDestination : FileManagerDestination) {
        let fileName = fileDestination.rawValue
        var items: [T] = load(from: fileDestination)
        items.removeAll { $0.id == item.id }
        do {
            let data = try JSONEncoder().encode(items)
            try data.write(to: fileURL(for: fileName))
        } catch {
            print("Error deleting from \(fileName): \(error)")
        }
    }
    
}
