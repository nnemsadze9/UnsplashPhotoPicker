//
//  PhotoDetailView.swift
//  Unsplash Photo Picker
//
//  Created by User on 25.05.25.
//

import SwiftUI

struct PhotoDetailView: View {
    let photo : Photo
    @StateObject private var viewModel = PhotoDetailViewModel()
    @State private var showSuccessAlert = false
    @State private var showFailureAlert = false
    @State private var isLoading = false
    
    var body: some View {
        VStack(alignment: .center){
            Spacer()
            AsyncImage(url:URL(string: photo.urls.full)){ image in
                image
                    .resizable()
                    .scaledToFit()
            }
            placeholder: {
                ZStack{
                    Color.gray.opacity(0.3)
                    ProgressView()
                }
            }
            .padding(.vertical)
            Spacer()
            HStack(){
                AsyncImage(url:URL(string: photo.user.profileImage.small)){ image in
                    image
                        .resizable()
                        .scaledToFill()
                }
                placeholder: {
                    ZStack{
                        Color.gray.opacity(0.3)
                        ProgressView()
                    }
                }
                .clipped()
                .frame(width: 40, height: 40)
                .cornerRadius(20)
                
                VStack(alignment: .leading){
                    Text(photo.user.name)
                    Text("@\(photo.user.username)")
                        .opacity(0.7)
                        .font(.footnote)
                }
                Spacer()
            }
            .padding(.horizontal, 16)
            HStack(){
                Image(systemName: "heart")
                    .opacity(0.8)
                Text("\(photo.likes) likes ")
                    .opacity(0.8)
                    .font(.system(size: 15))
                Text("\(photo.createdAt, style: .date)")
                    .opacity(0.8)
                    .font(.system(size: 15))
                Spacer()
                ShareLink(item: photo.urls.full) {
                    Label("Share Photo", systemImage: "square.and.arrow.up")
                        .font(.system(size: 15))
                }
            }
            .padding(.horizontal, 16)
            
            DownloadButton {
                if let url = URL(string: photo.urls.full) {
                    return await viewModel.downloadAndTrack(from: url,username: photo.user.username)
                }
                return false
            }
            
        }
    }
}
