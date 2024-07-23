//
//  ResetPasswordView.swift
//  NoteApp
//
//  Created by 박지혜 on 7/23/24.
//

import SwiftUI

struct ResetPasswordView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject private var authService: AuthService
    
    @State private var emailAddress: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Email", text: $emailAddress)
                        .textContentType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                }
                Section {
                    Button(
                        action: {
                            authService.resetPassword(emailAddress: emailAddress)
                        }) {
                            Text("Send email link").bold()
                        }
                } footer: {
                    Text("Once sent, check your email to reset your password.")
                }
            }
            .navigationTitle("Reset password")
            .toolbar {
                ToolbarItemGroup(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    ResetPasswordView()
}
