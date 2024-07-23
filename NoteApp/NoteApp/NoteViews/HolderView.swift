//
//  HolderView.swift
//  NoteApp
//
//  Created by 박지혜 on 7/23/24.
//

import SwiftUI

struct HolderView: View {
    @EnvironmentObject private var authService: AuthService
    
    var body: some View {
        Group {
            if authService.user == nil {
                SignUpView()
            } else {
                NoteListView()
            }
        }
        .onAppear {
            authService.listenToAuthState()
        }
    }
}

#Preview {
    HolderView()
        .environmentObject(AuthService())
}
