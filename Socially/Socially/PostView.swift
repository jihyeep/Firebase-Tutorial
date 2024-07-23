//
//  PostView.swift
//  Socially
//
//  Created by 박지혜 on 7/23/24.
//

import SwiftUI

struct PostView: View {
    @EnvironmentObject private var viewModel: PostViewModel
    
    @State private var description = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Description", text: $description)
                }
                Section {
                    Button {
                        Task {
                            await self.viewModel.addData(description: description, datePublished: Date())
                        }
                    } label: {
                        Text("Post")
                    }
                }
            }
            .navigationTitle("New Post")
        }
    }
}

#Preview {
    PostView()
}
