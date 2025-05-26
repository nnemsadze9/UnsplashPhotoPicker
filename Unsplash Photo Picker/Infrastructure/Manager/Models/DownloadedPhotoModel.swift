//
//  DownloadedPhotoModel.swift
//  Unsplash Photo Picker
//
//  Created by User on 25.05.25.
//

import Foundation

struct DownloadedPhoto: Identifiable, Codable {
    var id = UUID()
    var name: String
    var date: Date
    var url: URL
}
