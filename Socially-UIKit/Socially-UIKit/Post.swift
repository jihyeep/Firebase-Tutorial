//
//  Post.swift
//  Socially-UIKit
//
//  Created by 박지혜 on 7/25/24.
//

import Foundation
import FirebaseFirestore

struct Post: Identifiable, Hashable, Decodable {
    // Firestore와 id를 mapping
    @DocumentID var id: String?
    var description: String?
    var imageURL: String?
    
    // 서버 시간 정렬
    @ServerTimestamp var datePublished: Date?
}
