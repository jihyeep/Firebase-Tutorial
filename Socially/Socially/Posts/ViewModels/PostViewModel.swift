//
//  PostViewModel.swift
//  Socially
//
//  Created by 박지혜 on 7/23/24.
//

import Combine
import FirebaseFirestore
import FirebaseStorage

class PostViewModel: ObservableObject {
    private var databaseReference = Firestore.firestore().collection("Posts")
    private let storageReference = Storage.storage().reference().child("\(UUID().uuidString)")
    
    func addData(description: String, datePublished: Date, data: Data, completion: @escaping (Error?) -> Void) {
        do {
            _ = storageReference.putData(data, metadata: nil) { (metadata, error) in
                if let error = error {
                    completion(error)
                    return
                }
                
                self.storageReference.downloadURL { (url, error) in
                    if let error = error {
                        completion(error)
                        return
                    }
                    
                    guard let downloadURL = url else {
                        completion(NSError(domain: "URLError", code: 0, userInfo: nil))
                        return
                    }
                    
                    self.databaseReference.addDocument(data: [
                        "description": description,
                        "datePublished": datePublished,
                        "imageURL": downloadURL.absoluteString
                    ]) { error in
                        completion(error)
                    }
                }
            }
        }
    }
}