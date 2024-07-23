//
//  AuthService.swift
//  NoteApp
//
//  Created by 박지혜 on 7/23/24.
//

import SwiftUI
import FirebaseAuth

/// final: 더이상 상속, 수정, 변조되지 않도록
final class AuthService: ObservableObject {
    @Published var user: User?
    
    func listenToAuthState() {
        /// Stateful하게 관리
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
//            guard let self = self else {
//                return
//            }
            /// 위 코드와 동일
            self?.user = user
        }
    }
    
    func signIn(emailAddress: String, password: String) {
        Auth.auth().signIn(withEmail: emailAddress, password: password) { result, error in
            if let error = error {
                print("error: \(error.localizedDescription)")
                return
            }
        }
    }
    
    func signUp(emailAddress: String, password: String) {
        Auth.auth().createUser(withEmail: emailAddress, password: password) { result, error in
            if let error = error {
                print("create error: \(error.localizedDescription)")
                return
            }
            dump(result)
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func resetPassword(emailAddress: String) {
        Auth.auth().sendPasswordReset(withEmail: emailAddress) { error in
            if let error = error {
                print("error: \(error.localizedDescription)")
            }
            print("done")
        }
    }
}
