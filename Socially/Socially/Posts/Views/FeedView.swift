//
//  FeedView.swift
//  Socially
//
//  Created by 박지혜 on 7/23/24.
//

import SwiftUI
import FirebaseFirestoreSwift

struct FeedView: View {
    @EnvironmentObject private var authService: AuthService
    
    // 시간순 정렬
    @FirestoreQuery(
        collectionPath: "Posts",
        predicates: [.order(by: "datePublished", descending: true)]
    ) var posts: [Post]
    
    @State private var showingPost: Bool = false
    
    var body: some View {
        NavigationStack {
            List(posts) { post in
                VStack(alignment: .leading) {
                    AsyncImage(url: URL(string: post.imageURL ?? "")) { phase in
                        switch phase {
                        case .empty:
                            EmptyView()
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 300, height: 200, alignment: .center)
                                .clipped()
                        case .failure:
                            Image(systemName: "photo")
                        @unknown default:
                            EmptyView()
                        }
                    }
                    VStack(alignment: .leading) {
                        Text(post.description ?? "")
                            .font(.headline)
                            .padding(12)
                        Text("Published on the \(post.datePublished?.formatted() ?? "")")
                            .font(.caption)
                    }
                }
                .frame(minHeight: 100, maxHeight: 350)
            }
            .navigationTitle("Feed")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        showingPost = true
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
            .sheet(isPresented: $showingPost) {
                PostView().presentationDetents([.medium, .large])
            }
        }
    }
}

#Preview {
    FeedView()
}
