//
//  DownloadButton.swift
//  Unsplash Photo Picker
//
//  Created by User on 25.05.25.
//

import SwiftUI

struct DownloadButton: View {
    let action: () async -> Bool
    @State private var isLoading = false
    @State private var showSuccessAlert = false
    @State private var showFailureAlert = false
    
    var body: some View {
        Button {
            isLoading = true
            Task {
                defer { isLoading = false }
                let success = await action()
                success ? (showSuccessAlert = true) : (showFailureAlert = true)
            }
        } label: {
            HStack {
                
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.7)
                } else {
                    Image(systemName: "square.and.arrow.down")
                    Text("Download Image")
                }
            }
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.blue))
        }
        .padding(.horizontal, 16)
        .disabled(isLoading)
        .alert("Saved to your Photo Library!", isPresented: $showSuccessAlert) {
            Button("OK", role: .cancel) {}
        }
        .alert("Download failed or permission denied.", isPresented: $showFailureAlert) {
            Button("OK", role: .cancel) {}
        }
    }
}


struct DownloadDownloadsButton_Previews: PreviewProvider {
    static var previews: some View {
        DownloadButton(action: { true })
    }
}
