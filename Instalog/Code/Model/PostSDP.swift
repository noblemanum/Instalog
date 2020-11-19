//
//  Post.swift
//  Instalog
//
//  Created by Dimon on 12.10.2020.
//  Copyright © 2020 Dimon. All rights reserved.
//

import Foundation

struct PostSDP: Codable {
    let id: String
    let author: String
    let authorUsername: String
    let authorAvatar: URL
    let createdTime: Date
    var currentUserLikesThisPost: Bool
    let likedByCount: Int
    let image: URL
    let description: String
}
