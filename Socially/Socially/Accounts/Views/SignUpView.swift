//
//  SignUpView.swift
//  Socially
//
//  Created by 박지혜 on 7/23/24.
//

import SwiftUI
import AuthenticationServices
import FirebaseAuth
import FirebaseFirestore
import FirebaseAnalyticsSwift

struct SignUpView: View {
    @EnvironmentObject private var authService: AuthService
    
    var body: some View {
        VStack {
            SignInWithAppleButton(onRequest: authService.signInWithApple(request:),
                                  onCompletion: authService.signInWithAppleCompletion(result:))
            .signInWithAppleButtonStyle(.black)
            .frame(width: 290, height: 45, alignment: .center)
        }
        .analyticsScreen(name: "SignUpView")
    }
}

#Preview {
    SignUpView()
}
