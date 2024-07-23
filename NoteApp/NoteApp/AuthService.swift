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
}
