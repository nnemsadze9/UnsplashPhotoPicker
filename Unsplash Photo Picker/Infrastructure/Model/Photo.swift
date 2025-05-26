//
//  Photo.swift
//  Unsplash Photo Picker
//
//  Created by User on 24.05.25.
//

import Foundation

struct Photo : Codable, Identifiable {
    let id : String
    let user : User
    let likes : Int
    let createdAt: Date
    let urls : Url
    
    struct Url: Codable{
        let full: String
        let regular: String
       }
    
    struct User : Codable{
        let name : String
        let username: String
        let profileImage: ProfileImage
        
        struct ProfileImage: Codable {
            let large: String
            let medium: String
            let small: String
                }
    }
    
}


