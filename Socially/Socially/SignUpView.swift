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

struct SignUpView: View {
    @EnvironmentObject private var authService: AuthService
    
    var body: some View {
        VStack {
            SignInWithAppleButton(onRequest: { request in
                let nonce = authService.randomNonceString()
                authService.currentNonce = nonce
                request.requestedScopes = [.email]
                request.nonce = authService.sha256(nonce)
            }, onCompletion: { result in
                switch result {
                case .success(let authResults):
                    switch authResults.credential {
                    case let appleIDCredential as ASAuthorizationAppleIDCredential:
                        guard let nonce = authService.currentNonce else {
                            fatalError("Invalid state: A login callback was received, but no login request was sent.")
                        }
                        
                        guard let appleIDToken = appleIDCredential.identityToken else {
                            fatalError("Invalid state: A login callback was received, but no login request was sent.")
                        }
                        
                        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                            print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                            return
                        }
                        
                        let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                                  idToken: idTokenString,
                                                                  rawNonce: nonce)
                        
                        Auth.auth().signIn(with: credential) { (authResult, error) in
                            if let error = error {
                                print(error.localizedDescription)
                                return
                            }
                            print("signed in")
                            
                            guard let user = authResult?.user else { return }
                            
                            let userData = ["email": user.email, "uid": user.uid]
                            Firestore.firestore().collection("Users")
                                .document(user.uid)
                                .setData(userData as [String : Any]) { _ in
                                    print("DEBUG: Did upload user data.")
                                }
                        }
                        print("\(String(describing: Auth.auth().currentUser?.uid))")
                        
                    default:
                        break
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
            .signInWithAppleButtonStyle(.black)
            .frame(width: 290, height: 45, alignment: .center)
        }
    }
}

#Preview {
    SignUpView()
}
