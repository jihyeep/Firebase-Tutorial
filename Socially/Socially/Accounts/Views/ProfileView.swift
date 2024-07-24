//
//  ProfileView.swift
//  Socially
//
//  Created by 박지혜 on 7/24/24.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @EnvironmentObject var authService: AuthService
    
    @State private var showingSignUp: Bool = false
    @State private var data: Data?
    @State private var selectedItem: [PhotosPickerItem] = []
    
    var body: some View {
        VStack(alignment: .center) {
            if authService.user != nil {
                Form {
                    Section("Your account") {
                        HStack {
                            PhotosPicker(selection: $selectedItem, maxSelectionCount: 1, selectionBehavior: .default, matching: .images, preferredItemEncoding: .automatic) {
                                if let data = data, let image = UIImage(data: data) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxHeight: 80)
                                } else {
                                    AsyncImage(url: authService.user?.photoURL) { phase in
                                        switch phase {
                                        case .empty:
                                            EmptyView()
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 80, height: 80)
                                                .clipped()
                                        case .failure:
                                            Image(systemName: "person.circle")
                                        @unknown default:
                                            EmptyView()
                                        }
                                    }
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
                                            authService.uploadProfileImage(data)
                                        }
                                    case .failure(let failure):
                                        print("Error: \(failure.localizedDescription)")
                                    }
                                }
                            }
                            
                            Text(authService.user?.email ?? "")
                        }
                    }
                    Button {
                        authService.signOut()
                    } label: {
                        Text("Logout")
                            .foregroundStyle(.red)
                    }
                }
            } else {
                Form {
                    Section("Your account") {
                        Text("Seems like you are not logged in, create an account")
                    }
                    Button {
                        showingSignUp.toggle()
                    } label: {
                        Text("Sign Up")
                            .foregroundStyle(.blue)
                            .bold()
                    }
                    .sheet(isPresented: $showingSignUp) {
                        SignUpView().presentationDetents([.height(100), .medium, .large])
                    }
                }
            }
        }
        .onAppear {
            authService.listenToAuthState()
        }
    }
}

#Preview {
    ProfileView()
}
