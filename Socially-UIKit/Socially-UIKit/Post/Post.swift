//
//  Post.swift
//  Socially-UIKit
//
//  Created by 박지혜 on 7/25/24.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

struct Post: Identifiable, Hashable, Decodable {
    // Firestore와 id를 mapping
    @DocumentID var id: String?
    var description: String?
    var imageURL: String?
    var path: String?
    // 서버 시간 정렬
    @ServerTimestamp var datePublished: Date?
    
    init?(document: QueryDocumentSnapshot) {
        self.id = document.documentID
        self.description = document.data()["description"] as? String
        if let url = document.data()["imageURL"] as? String {
            self.imageURL = url
        } else if let path = document.data()["path"] as? String {
            // imageURL이 없는 경우 path 값을 사용하여 비동기적으로 URL 확인
            let mutableSelf = self
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                mutableSelf.checkImageURL(path)
            }
        }
    }
    
    func checkImageURL(_ path: String) {
        let thumbRef = Storage.storage().reference().child("thumbs/\(path)_320x200")
        thumbRef.downloadURL { url, error in
            if let error = error {
                return
            }

            if let url = url,
            let docId = self.id {
                Firestore.firestore().collection("Posts")
                    .document(docId)
                    .setData(["imageURL": url], merge: true)
            }
        }

    }
}
