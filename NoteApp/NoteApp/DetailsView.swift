//
//  DetailsView.swift
//  NoteApp
//
//  Created by 박지혜 on 7/22/24.
//

import SwiftUI

struct DetailsView: View {
    @ObservedObject var viewModel: NoteViewModel
    
    var note: Note
    @State private var presentAlert = false
    @State private var titleText = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Text(note.title ?? "")
                        .font(.system(size: 22, weight: .regular))
                        .padding()
                    Spacer()
                }
            }
            .navigationTitle("Details")
            .toolbar {
                ToolbarItemGroup(placement: .confirmationAction) {
                    Button {
                        presentAlert = true
                    } label: {
                        Text("Edit").bold()
                    }
                    .alert("Note", isPresented: $presentAlert, actions: {
                        TextField("\(note.title ?? "")", text: $titleText)
                        Button("Update") {
                            viewModel.updateData(title: titleText, id: note.id ?? "")
                            presentAlert = false
                            titleText = ""
                        }
                        Button("Cancel", role: .cancel) {
                            presentAlert = false
                            titleText = ""
                        }
                    }, message: {
                        Text("Write your new note")
                    })
                }
            }
        }
    }
}

#Preview {
    DetailsView(viewModel: NoteViewModel(), note: Note(title: "Test"))
}
