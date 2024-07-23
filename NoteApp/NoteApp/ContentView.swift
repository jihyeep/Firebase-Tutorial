//
//  ContentView.swift
//  NoteApp
//
//  Created by 박지혜 on 7/22/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var authService: AuthService
    
    @StateObject private var viewModel = NoteViewModel()
    
    @State private var showSheet = false
    @State private var postDetent = PresentationDetent.medium
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.notes, id: \.id) { note in
                    NavigationLink(destination: DetailsView(note: note)) {
                        VStack(alignment: .leading) {
                            Text(note.title ?? "")
                                .font(.system(size: 22, weight: .regular))
                        }
                    }
                }
                .onDelete(perform: viewModel.deleteData(at:))
            }
            .onAppear {
                viewModel.fetchData()
            }
            .navigationTitle("Notes")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        authService.signOut()
                    } label: {
                        Text("Sign out")
                    }
                }
                ToolbarItemGroup(placement: .bottomBar) {
                    Text(" \(viewModel.notes.count) notes")
                    Spacer()
                    Button {
                        showSheet.toggle()
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                    .imageScale(.large)
                    .sheet(isPresented: $showSheet) {
                        FormView()
                            // 팝업창 멈춤쇠
                            .presentationDetents([.large, .medium])
                    }
                }
            }
        }
        .environmentObject(viewModel)
    }
}

#Preview {
    ContentView()
}
