//
//  FeedViewController.swift
//  Instalog
//
//  Created by Dimon on 20.07.2020.
//  Copyright © 2020 Dimon. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var feedCollection: UICollectionView!
    
    // MARK: - Properties
    
    private var postAuthor: String?
    private var posts: [PostSDP] = []
    private var post: PostSDP?
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPosts()
        
        feedCollection.register(cellType: FeedCollectionViewCell.self)
        
        feedCollection.delegate = self
        feedCollection.dataSource = self
    }
    
    // MARK: - Configuring Layout
    
    override func viewDidLayoutSubviews() {
        let flowLayout = feedCollection.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.estimatedItemSize = CGSize(width: feedCollection.bounds.width, height: 540)
        flowLayout.itemSize = UICollectionViewFlowLayout.automaticSize
        flowLayout.minimumLineSpacing = 7
    }
    
    // MARK: - Private
    
    private func loadPosts() {
        
        let loadingIndicator = LoadingIndicator(uiView: self.view)
        loadingIndicator.show()
        
        ServerDataProvider.shared.feed { (result) in
            switch result {
            case .success(value: let loadedPosts):
                self.posts = loadedPosts
                DispatchQueue.main.async {
                    self.feedCollection.reloadData()
                    loadingIndicator.hide()
                }
            case .failure(error: let error):
                DispatchQueue.main.async {
                    loadingIndicator.hide()
                    ErrorReporting.showMessage(for: self, title: nil, message: error.getErrorDescription())
                }
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LikesIdentifier",
            let destination = segue.destination as? LikesFollowersFollowingViewController {
            destination.post = post
        }
        else if segue.identifier == "ProfileIdentifier",
            let author = postAuthor,
            let destination = segue.destination as? ProfileViewController {
            destination.profileType = .user(id: author)
            destination.navigationItem.title = post?.authorUsername
        }
    }
    
    @IBAction func unwindSegue(sender: UIStoryboardSegue) {
        loadPosts()
        feedCollection.scrollToItem(at: IndexPath(item: 0, section: 0), at: [], animated: false)
    }
}

    // MARK: - Collection View Data Source

extension FeedViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = feedCollection.dequeueCell(of: FeedCollectionViewCell.self, for: indexPath)
        
        cell.delegate = self
        cell.configure(with: posts[indexPath.item])
        cell.layer.cornerRadius = 15
        
        return cell
    }
}

    // MARK: - Collection View Delegate

extension FeedViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        feedCollection.deselectItem(at: indexPath, animated: true)
    }
}

    // MARK: - Feed Collection View Cell Delegate

extension FeedViewController: FeedCollectionViewCellDelegate {

    func feedCellDidToggleLikeButton(_ cell: FeedCollectionViewCell) {
        guard let indexPath = feedCollection.indexPath(for: cell) else {
            return
        }

        let post = posts[indexPath.item]

        if post.currentUserLikesThisPost {
            posts[indexPath.item].currentUserLikesThisPost = false
            ServerDataProvider.shared.unlikePostWith(postID: post.id) { (result) in
                switch result {
                case .success(value: let post):
                    self.posts[indexPath.item] = post
                case .failure(error: let error):
                    DispatchQueue.main.async {
                        ErrorReporting.showMessage(for: self,
                                                   title: nil,
                                                   message: error.getErrorDescription())
                    }
                }
            }
        } else {
            posts[indexPath.item].currentUserLikesThisPost = true
            ServerDataProvider.shared.likePostWith(postID: post.id) { (result) in
                switch result {
                case .success(value: let post):
                    self.posts[indexPath.item] = post
                case .failure(error: let error):
                    DispatchQueue.main.async {
                        ErrorReporting.showMessage(for: self,
                                                   title: nil,
                                                   message: error.getErrorDescription())
                    }
                }
            }
        }
    }

    func feedCellLikesLabelTapped(_ cell: FeedCollectionViewCell) {
        guard let indexPath = feedCollection.indexPath(for: cell) else {
            return
        }
        
        let post = posts[indexPath.item]
        self.post = post
        performSegue(withIdentifier: "LikesIdentifier", sender: nil)
    }

    func feedCellUserTapped(_ cell: FeedCollectionViewCell) {
        guard let indexPath = feedCollection.indexPath(for: cell) else {
            return
        }

        let post = posts[indexPath.item]
        postAuthor = post.author
        performSegue(withIdentifier: "ProfileIdentifier", sender: nil)
    }
}
