//
//  Post.swift
//  Socially
//
//  Created by 박지혜 on 7/23/24.
//

import SwiftUI
import FirebaseFirestoreSwift

struct Post: Identifiable, Decodable {
    // Firestore와 id를 mapping
    @DocumentID var id: String?
    var description: String?
    var imageURL: String?
    
    // 서버 시간 정렬
    /// 서버 도달 시간 차이를 완화시켜 줌
    @ServerTimestamp var datePublished: Date?
}
