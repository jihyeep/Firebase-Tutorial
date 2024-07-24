//
//  ProfileView.swift
//  Socially
//
//  Created by 박지혜 on 7/24/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authService: AuthService
    
    @State private var showingSignUp: Bool = false
    
    var body: some View {
        VStack(alignment: .center) {
            if authService.user != nil {
                Form {
                    Section("Your account") {
                        Text(authService.user?.email ?? "")
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
