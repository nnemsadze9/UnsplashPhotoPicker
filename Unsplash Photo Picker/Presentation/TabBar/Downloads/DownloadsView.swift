//
//  DownloadsView.swift
//  Unsplash Photo Picker
//
//  Created by User on 24.05.25.
//

import SwiftUI

struct DownloadsView: View {
    @State private var downloads: [DownloadedPhoto] = []
    
    var body: some View {
        NavigationStack{
            List(downloads) { item in
                NavigationLink(destination: DownloadedPhotoDetailView(photo: item)) {
                    HStack(alignment: .center, spacing: 12) {
                        AsyncImage(url: item.url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            ZStack{
                                Color.gray.opacity(0.2)
                                ProgressView()
                            }
                        }
                        .frame(width: 80, height: 80)
                        .clipped()
                        .cornerRadius(8)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.name)
                                .font((.headline))
                            
                            Text(item.date, style: .date)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .listStyle(.plain)
            
            .onAppear {
                downloads = FileManagerService.shared.load(from: .downloadsDirectory)
                print(downloads)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Downloads")
                        .font(.title.bold())
                }
            }
        }
    }
}



struct DownloadsView_Previews: PreviewProvider {
    static var previews: some View {
        DownloadsView()
    }
}
