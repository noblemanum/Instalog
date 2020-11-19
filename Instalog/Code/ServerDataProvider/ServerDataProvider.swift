//
//  ServerDataProvider.swift
//  Instalog
//
//  Created by Dimon on 12.10.2020.
//  Copyright © 2020 Dimon. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class ServerDataProvider {
    
    // MARK: - Properties
    
    static let shared = ServerDataProvider()
    
    private(set) var isOnlineMode = true
    
    static var token: String?
    
    // MARK: - Sending and processing
    
    func signIn(login: String, password: String, completion: @escaping(Result<Token>) -> Void) {
        
        struct LoginAndPassword: Codable {
            let login: String
            let password: String
        }
        
        let loginAndPassword = LoginAndPassword(login: login, password: password)
        guard let request = createRequest(path: .signin, method: "POST", body: loginAndPassword) else {
            completion(.failure(error: .offlineMode))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if !self.catchError(data: data, response: response, error: error, completion: completion) {
                do {
                    guard let data = data else { return }
                    let jsonDecoder = JSONDecoder()
                    let token = try jsonDecoder.decode(Token.self, from: data)
                    completion(.success(value: token))
                } catch {
                    completion(.failure(error: .otherError(error)))
                }
            }
        }
        task.resume()
    }
    
    func signOut(completion: @escaping() -> Void) {
        guard let request = createRequest(path: .signout, method: "POST") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async {
                print("Token was invalidated")
                completion()
            }
        }
        task.resume()
    }
    
    func feed(completion: @escaping(Result<[PostSDP]>) -> Void) {
        guard let request = createRequest(path: .feed, method: "GET") else {
            completion(.failure(error: .offlineMode))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if !self.catchError(data: data, response: response, error: error, completion: completion) {
                do {
                    guard let data = data else { return }
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.dateDecodingStrategy = .formatted(.jsonDate)
                    let posts = try jsonDecoder.decode([PostSDP].self, from: data)
                    completion(.success(value: posts))
                } catch {
                    completion(.failure(error: .otherError(error)))
                }
            }
        }
        task.resume()
    }
    
    func usersLikedPost(postID: String, completion: @escaping(Result<[UserSDP]>) -> Void) {
        guard let request = createRequest(path: .usersLikedPost(postID), method: "GET") else {
            completion(.failure(error: .offlineMode))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if !self.catchError(data: data, response: response, error: error, completion: completion) {
                do {
                    guard let data = data else { return }
                    let jsonDecoder = JSONDecoder()
                    let users = try jsonDecoder.decode([UserSDP].self, from: data)
                    completion(.success(value: users))
                } catch {
                    completion(.failure(error: .otherError(error)))
                }
            }
        }
        task.resume()
    }
    
    func usersFollowingUser(userID: String, completion: @escaping(Result<[UserSDP]>) -> Void) {
        guard let request = createRequest(path: .usersFollowingUser(userID), method: "GET") else {
            completion(.failure(error: .offlineMode))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if !self.catchError(data: data, response: response, error: error, completion: completion) {
                do {
                    guard let data = data else { return }
                    let jsonDecoder = JSONDecoder()
                    let users = try jsonDecoder.decode([UserSDP].self, from: data)
                    completion(.success(value: users))
                } catch {
                    completion(.failure(error: .otherError(error)))
                }
            }
        }
        task.resume()
    }
    
    func usersFollowedByUser(userID: String, completion: @escaping(Result<[UserSDP]>) -> Void) {
        guard let request = createRequest(path: .usersFollowedByUser(userID), method: "GET") else {
            completion(.failure(error: .offlineMode))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if !self.catchError(data: data, response: response, error: error, completion: completion) {
                do {
                    guard let data = data else { return }
                    let jsonDecoder = JSONDecoder()
                    let users = try jsonDecoder.decode([UserSDP].self, from: data)
                    completion(.success(value: users))
                } catch {
                    completion(.failure(error: .otherError(error)))
                }
            }
        }
        task.resume()
    }
    
    func currentUser(completion: @escaping(Result<UserSDP>) -> Void) {
        guard let request = createRequest(path: .currentUser, method: "GET") else {
            completion(.failure(error: .offlineMode))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if !self.catchError(data: data, response: response, error: error, completion: completion) {
                do {
                    guard let data = data else { return }
                    let jsonDecoder = JSONDecoder()
                    let user = try jsonDecoder.decode(UserSDP.self, from: data)
                    completion(.success(value: user))
                } catch {
                    completion(.failure(error: .otherError(error)))
                }
            }
        }
        task.resume()
    }
    
    func userWithID(userID: String, completion: @escaping(Result<UserSDP>) -> Void) {
        guard let request = createRequest(path: .userWithID(userID), method: "GET") else {
            completion(.failure(error: .offlineMode))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if !self.catchError(data: data, response: response, error: error, completion: completion) {
                do {
                    guard let data = data else { return }
                    let jsonDecoder = JSONDecoder()
                    let user = try jsonDecoder.decode(UserSDP.self, from: data)
                    completion(.success(value: user))
                } catch {
                    completion(.failure(error: .otherError(error)))
                }
            }
        }
        task.resume()
    }
    
    func userPosts(userID: String, completion: @escaping(Result<[PostSDP]>) -> Void) {
        guard let request = createRequest(path: .userPosts(userID), method: "GET") else {
            completion(.failure(error: .offlineMode))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if !self.catchError(data: data, response: response, error: error, completion: completion) {
                do {
                    guard let data = data else { return }
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.dateDecodingStrategy = .formatted(.jsonDate)
                    let posts = try jsonDecoder.decode([PostSDP].self, from: data)
                    completion(.success(value: posts))
                } catch {
                    completion(.failure(error: .otherError(error)))
                }
            }
        }
        task.resume()
    }
    
    func followUserWith(userID: String, completion: @escaping(Result<UserSDP>) -> Void) {
        
        struct UserID: Codable {
            let userID: String
        }
        
        guard let request = createRequest(path: .follow, method: "POST", body: UserID(userID: userID)) else {
            completion(.failure(error: .offlineMode))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if !self.catchError(data: data, response: response, error: error, completion: completion) {
                do {
                    guard let data = data else { return }
                    let jsonDecoder = JSONDecoder()
                    let user = try jsonDecoder.decode(UserSDP.self, from: data)
                    completion(.success(value: user))
                } catch {
                    completion(.failure(error: .otherError(error)))
                }
            }
        }
        task.resume()
    }
    
    func unfollowUserWith(userID: String, completion: @escaping(Result<UserSDP>) -> Void) {
        
        struct UserID: Codable {
            let userID: String
        }
        
        guard let request = createRequest(path: .unfollow, method: "POST", body: UserID(userID: userID)) else {
            completion(.failure(error: .offlineMode))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if !self.catchError(data: data, response: response, error: error, completion: completion) {
                do {
                    guard let data = data else { return }
                    let jsonDecoder = JSONDecoder()
                    let user = try jsonDecoder.decode(UserSDP.self, from: data)
                    completion(.success(value: user))
                } catch {
                    completion(.failure(error: .otherError(error)))
                }
            }
        }
        task.resume()
    }
    
    func likePostWith(postID: String, completion: @escaping(Result<PostSDP>) -> Void) {
        
        struct PostID: Codable {
            let postID: String
        }
        
        guard let request = createRequest(path: .like, method: "POST", body: PostID(postID: postID)) else {
            completion(.failure(error: .offlineMode))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if !self.catchError(data: data, response: response, error: error, completion: completion) {
                do {
                    guard let data = data else { return }
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.dateDecodingStrategy = .formatted(.jsonDate)
                    let post = try jsonDecoder.decode(PostSDP.self, from: data)
                    completion(.success(value: post))
                } catch {
                    completion(.failure(error: .otherError(error)))
                }
            }
        }
        task.resume()
    }
    
    func unlikePostWith(postID: String, completion: @escaping(Result<PostSDP>) -> Void) {
        
        struct PostID: Codable {
            let postID: String
        }
        
        guard let request = createRequest(path: .unlike, method: "POST", body: PostID(postID: postID)) else {
            completion(.failure(error: .offlineMode))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if !self.catchError(data: data, response: response, error: error, completion: completion) {
                do {
                    guard let data = data else { return }
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.dateDecodingStrategy = .formatted(.jsonDate)
                    let post = try jsonDecoder.decode(PostSDP.self, from: data)
                    completion(.success(value: post))
                } catch {
                    completion(.failure(error: .otherError(error)))
                }
            }
        }
        task.resume()
    }
    
    func newPost(imageInBase64 image: String, description: String, completion: @escaping(Result<PostSDP>) -> Void) {
        
        struct NewPost: Codable {
            let image: String
            let description: String
        }
        
        guard let request = createRequest(path: .newPost, method: "POST", body: NewPost(image: image, description: description)) else {
            completion(.failure(error: .offlineMode))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if !self.catchError(data: data, response: response, error: error, completion: completion) {
                do {
                    guard let data = data else { return }
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.dateDecodingStrategy = .formatted(.jsonDate)
                    let post = try jsonDecoder.decode(PostSDP.self, from: data)
                    completion(.success(value: post))
                } catch {
                    completion(.failure(error: .otherError(error)))
                }
            }
        }
        task.resume()
    }
    
    // MARK: - Private Methods
    
    private func createRequest<T:Encodable>(path: Path, method: String, body: T) -> URLRequest? {
        guard var request = createRequest(path: path, method: method) else {
            return nil
        }
        
        let jsonEncoder = JSONEncoder()
        let encodedBody = try? jsonEncoder.encode(body)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = encodedBody
        return request
    }
    
    private func createRequest(path: Path, method: String) -> URLRequest? {
        
        if !ServerDataProvider.shared.isOnlineMode {
            return nil
        }
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = "localhost"
        urlComponents.port = 8080
        urlComponents.path = path.path
        
        guard let url = urlComponents.url else {
            return nil
        }
        
        print("url = <\(url)>")
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        if let token = ServerDataProvider.token {
            request.setValue(token, forHTTPHeaderField: "token")
        }
        return request
    }
    
    private func catchError<T>(data: Data?, response: URLResponse?, error: Error?, completion: @escaping (Result<T>) -> Void) -> Bool {
        if let _ = error {
            ServerDataProvider.shared.isOnlineMode = false
            completion(.failure(error: .serverUnreachable))
            return true
        }
        
        guard let _ = data else {
            completion(.failure(error: .zeroData))
            return true
        }
        
        if let httpResponse = response as? HTTPURLResponse {
            print("HTTP status code = \(httpResponse.statusCode)")
            
            switch httpResponse.statusCode {
            case 400:
                completion(.failure(error: .badRequest))
                return true
            case 401:
                completion(.failure(error: .unauthorized))
                return true
            case 404:
                completion(.failure(error: .notFound))
                return true
            case 406:
                completion(.failure(error: .notAcceptable))
                return true
            case 422:
                completion(.failure(error: .unprocessable))
                return true
            case 200:
                return false
            default:
                completion(.failure(error: .statusCode(httpResponse.statusCode)))
                return true
            }
        }
        
        return false
    }
}
