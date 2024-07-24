//
//  PostView.swift
//  Socially
//
//  Created by 박지혜 on 7/23/24.
//

import SwiftUI
import PhotosUI
import FirebaseAnalyticsSwift

struct PostView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject private var viewModel: PostViewModel
    
    @State private var description = ""
    @State private var isUploading = false
    @State private var data: Data?
    @State private var selectedItem: [PhotosPickerItem] = []
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    PhotosPicker(selection: $selectedItem, maxSelectionCount: 1, selectionBehavior: .default, matching: .images, preferredItemEncoding: .automatic) {
                        if let data = data,
                           let image = UIImage(data: data) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 300)
                        } else {
                            Label("Select a picture", systemImage: "photo.on.rectangle.angled")
                        }
                    }
                    .onChange(of: selectedItem) { (_, newValue) in
                        guard let item = selectedItem.first else {
                            return
                        }
                        item.loadTransferable(type: Data.self) { result in
                            switch result {
                            case .success(let data):
                                if let data = data {
                                    self.data = data
                                }
                            case .failure(let failure):
                                print("Error: \(failure.localizedDescription)")
                            }
                        }
                    }
                }
                Section {
                    TextField("Description", text: $description)
                }
                Section {
                    Button {
                        // 로딩 시작(disabled)
                        isUploading = true
                        self.viewModel.addData(description: description, datePublished: Date(), data: data!) { error in
                            // 로딩 제거
                            isUploading = false
                            if let error = error {
                                print("\(error)")
                                return
                            }
                            print("upload & post done")
                            dismiss()
                        }
                    } label: {
                        Text("Post")
                    }
                    .disabled(isUploading)
                }
            }
            .navigationTitle("New Post")
            .analyticsScreen(name: "PostView")
        }
    }
}

#Preview {
    PostView()
}
