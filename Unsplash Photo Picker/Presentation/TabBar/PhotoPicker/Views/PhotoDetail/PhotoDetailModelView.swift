//
//  PhotoDetailViewModel.swift
//  Unsplash Photo Picker
//
//  Created by User on 25.05.25.
//

import Foundation
import SwiftUI
import Photos

@MainActor
final class PhotoDetailViewModel: ObservableObject {
    
    func downloadAndTrack(from url: URL, username: String) async -> Bool {
        let status = await PHPhotoLibrary.requestAuthorization(for: .addOnly)
        guard status == .authorized || status == .limited else {
            print("No permission")
            return false
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else {
                print("Invalid image data")
                return false
            }
            
            try await saveToPhotoLibrary(image)
            FileManagerService.shared.save(DownloadedPhoto(name: username, date: Date(), url: url), to: .downloadsDirectory)
            return true
        } catch {
            print("Error downloading/saving: \(error)")
            return false
        }
    }
    
    private func saveToPhotoLibrary(_ image: UIImage) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            PHPhotoLibrary.shared().performChanges {
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            } completionHandler: { success, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }
}
