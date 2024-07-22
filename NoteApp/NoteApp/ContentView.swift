//
//  ContentView.swift
//  NoteApp
//
//  Created by 박지혜 on 7/22/24.
//

import SwiftUI

struct ContentView: View {
    @State private var showSheet = false
    @State private var postDetent = PresentationDetent.medium
    @StateObject private var viewModel = NoteViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.notes, id: \.id) { note in
                    VStack(alignment: .leading) {
                        Text(note.title ?? "")
                            .font(.system(size: 22, weight: .regular))
                    }
                }
            }
            .onAppear {
                viewModel.fetchData()
            }
            .navigationTitle("Notes")
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Text(" X notes")
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
    }
}

#Preview {
    ContentView()
}
