//
//  SignUpView.swift
//  NoteApp
//
//  Created by 박지혜 on 7/23/24.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject private var authService: AuthService
    
    @State private var emailAddress: String = ""
    @State private var password: String = ""
    @State private var showingSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Email", text: $emailAddress)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                    SecureField("Password", text: $password)
                }
                Section {
                    Button {
                        authService.signUp(emailAddress: emailAddress, password: password)
                    } label: {
                        Text("Sign Up")
                            .bold()
                    }
                }
                Section {
                    Button {
                        authService.signIn(emailAddress: emailAddress, password: password)
                    } label: {
                        Text("Sign In")
                    }
                } header: {
                    Text("If you already have an account: ")
                }
            }
            .navigationTitle("Welcome")
            .toolbar {
                ToolbarItemGroup(placement: .cancellationAction) {
                    Button {
                        showingSheet.toggle()
                    } label: {
                        Text("Forgot password?")
                    }
                    .sheet(isPresented: $showingSheet, content: {
                        ResetPasswordView()
                    })
                }
            }
        }
    }
}

#Preview {
    SignUpView()
}
