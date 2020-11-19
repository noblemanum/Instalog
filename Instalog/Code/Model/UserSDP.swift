//
//  UserSDP.swift
//  Instalog
//
//  Created by Dimon on 14.10.2020.
//  Copyright © 2020 Dimon. All rights reserved.
//

import Foundation

struct UserSDP: Codable {
    let id: String
    let username: String
    let fullName: String
    let avatar: URL
    var currentUserFollowsThisUser: Bool
    let currentUserIsFollowedByThisUser: Bool
    let followsCount: Int
    let followedByCount: Int
}
