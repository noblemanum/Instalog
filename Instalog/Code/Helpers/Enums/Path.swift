//
//  Path.swift
//  Instalog
//
//  Created by Dimon on 12.10.2020.
//  Copyright © 2020 Dimon. All rights reserved.
//

import Foundation

enum Path {
    case signin
    case signout
    case feed
    case currentUser
    case follow
    case unfollow
    case like
    case unlike
    case usersLikedPost(String)
    case usersFollowingUser(String)
    case usersFollowedByUser(String)
    case userWithID(String)
    case userPosts(String)
    case newPost
    
    var path: String {
        switch self {
        case .signin:
            return "/signin"
        case .signout:
            return "/signout"
        case .feed:
            return "/posts/feed"
        case .currentUser:
            return "/users/me"
        case .follow:
            return "/users/follow"
        case .unfollow:
            return "/users/unfollow"
        case .like:
            return "/posts/like"
        case .unlike:
            return "/posts/unlike"
        case .usersLikedPost(let postID):
            return "/posts/\(postID)/likes"
        case .usersFollowingUser(let userID):
            return "/users/\(userID)/followers"
        case .usersFollowedByUser(let userID):
            return "/users/\(userID)/following"
        case .userWithID(let userID):
            return "/users/\(userID)"
        case .userPosts(let userID):
            return "/users/\(userID)/posts/"
        case .newPost:
            return "/posts/create"
        }
    }
}
