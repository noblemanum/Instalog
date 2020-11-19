//
//  ProfileViewController.swift
//  Instalog
//
//  Created by Dimon on 26.07.2020.
//  Copyright © 2020 Dimon. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var profileCollectionView: UICollectionView!
    
    // MARK: - Properties
    
    var profileType: ProfileType = .currentUser
    var user: UserSDP?
    weak var parentVC: LikesFollowersFollowingViewController?
    private var currentUserPosts: [PostSDP] = []
    private let refresher = UIRefreshControl()
    private lazy var loadingIndicator: LoadingIndicator = {
        return LoadingIndicator(uiView: self.view)
    }()

    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileCollectionView.alwaysBounceVertical = true
        refresher.tintColor = .systemGray
        refresher.addTarget(self, action: #selector(refresh), for: .valueChanged)
        profileCollectionView.addSubview(refresher)
        
//        if let username = user?.username {
//            self.navigationItem.title = username
//        }
        
        if isRootViewController() {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "logout"), style: .plain, target: self, action: #selector(signOut))
        }
        
        loadUserData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadUserData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if parentVC?.controllerType != UniversalControllerType.likes {
            parentVC?.loadViewData()
        }
    }
        
    // MARK: - Private Methods
    
    private func loadUserData(withRefresher: Bool = false) {
        
        if !withRefresher {
            DispatchQueue.main.async {
                self.loadingIndicator.show()
            }
        }
        
        switch profileType {
        case .currentUser:
            ServerDataProvider.shared.currentUser { (resultType) in
                self.switchResultType(to: resultType, withRefresher: withRefresher)
            }
        case .user(id: let id):
            ServerDataProvider.shared.userWithID(userID: id) { (resultType) in
                self.switchResultType(to: resultType, withRefresher: withRefresher)
            }
        }
    }
   
    private func switchResultType(to resultType: Result<UserSDP>, withRefresher: Bool) {
        
        switch resultType {
        case .success(value: let user):
            self.user = user
            DispatchQueue.main.async {
                self.navigationItem.title = user.username
            }
            self.loadUserPosts(userID: user.id, withRefresher: withRefresher)
        case .failure(error: let error):
            DispatchQueue.main.sync {
                self.loadingIndicator.hide()
                ErrorReporting.showMessage(for: self,
                                           title: nil,
                                           message: error.getErrorDescription())
            }
        }
    }
    
    private func loadUserPosts(userID: String, withRefresher: Bool) {
        
        ServerDataProvider.shared.userPosts(userID: userID) { (result) in
            switch result {
            case .success(value: let posts):
                self.currentUserPosts = posts
                DispatchQueue.main.sync {
                    
                    self.profileCollectionView.register(cellType: PhotoCollectionViewCell.self)
                    self.profileCollectionView.dataSource = self
                    
                    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
                    layout.headerReferenceSize = CGSize(width: self.view.bounds.width, height: 86)
                    layout.itemSize = CGSize(width: (self.view.bounds.width - 2) / 3,
                                             height: (self.view.bounds.width - 2) / 3)
                    layout.minimumInteritemSpacing = 1
                    layout.minimumLineSpacing = 1
                    
                    self.profileCollectionView.collectionViewLayout = layout
                    self.profileCollectionView.reloadData()
                    
                    if !withRefresher {
                        self.loadingIndicator.hide()
                    } else {
                        self.refresher.endRefreshing()
                    }
                }
            case .failure(error: let error):
                DispatchQueue.main.async {
                    if !withRefresher {
                        self.loadingIndicator.hide()
                    } else {
                        self.refresher.endRefreshing()
                    }
                    ErrorReporting.showMessage(for: self,
                                               title: nil,
                                               message: error.getErrorDescription(),
                                               withDismissOption: true)
                }
            }
        }
    }
    
    private func isRootViewController() -> Bool {
        self.navigationController?.viewControllers.count == 1 ? true : false
    }
    
    @objc private func refresh() {
        
        if let _ = user?.id {
            loadUserData(withRefresher: true)
        } else {
            refresher.endRefreshing()
        }
    }
    
    @objc private func signOut() {
        
        let alert = UIAlertController(title: "Sign Out", message: "Are you sure you want to sign out?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let signOutAction = UIAlertAction(title: "Sign Out", style: .destructive) { (_) in
            
            self.loadingIndicator.show()
            
            ServerDataProvider.shared.signOut {
                ServerDataProvider.token = nil
                self.loadingIndicator.hide()
            
                let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AuthorizationViewControllerID") as? AuthorizationViewController
                UIApplication.shared.keyWindow?.rootViewController = viewController
            }
        }
            
        alert.addAction(cancelAction)
        alert.addAction(signOutAction)
            
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? LikesFollowersFollowingViewController {
            destination.parentUser = user
            if segue.identifier == "FollowersSegue" {
                destination.controllerType = .followers
            } else if segue.identifier == "FollowingSegue" {
                destination.controllerType = .following
            }
        }
    }
}

    // MARK: - Collection View Data Source

extension ProfileViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentUserPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCollectionViewCell
        
        cell.image.kf.setImage(with: currentUserPosts[indexPath.item].image)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ProfileCollectionReusableView", for: indexPath) as! ProfileCollectionReusableView

            if let currentUser = user {
                reusableView.frame = CGRect(x: 0 , y: 0, width: self.view.frame.width, height: 86)
                reusableView.profileImageView.layer.cornerRadius = reusableView.profileImageView.bounds.width / 2
                reusableView.profileNicknameLabel.text = currentUser.fullName
                reusableView.profileImageView.kf.setImage(with: currentUser.avatar)
                reusableView.followersLabel.text = "Followers: \(currentUser.followedByCount)"
                reusableView.followingLabel.text = "Following: \(currentUser.followsCount)"
                
                if currentUser.currentUserFollowsThisUser {
                    reusableView.followButton.setTitle("Unfollow", for: .normal)
                } else {
                    reusableView.followButton.setTitle("Follow", for: .normal)
                }
                
                switch profileType {
                case .currentUser:
                    reusableView.followButton.isHidden = true
                default:
                    if currentUser.id == AuthorizationViewController.currentUserID {
                        reusableView.followButton.isHidden = true
                    }
                }
            }
            
            reusableView.delegate = self
            return reusableView

        default:
            fatalError("Unexpected element kind")
        }
    }

}

    // MARK: - Profile Collection Reusable View Delegate

extension ProfileViewController: ProfileCollectionReusableViewDelegate {
    
    func followersLabelTapped() {
        performSegue(withIdentifier: "FollowersSegue", sender: nil)
    }
    
    func followingLabelTapped() {
        performSegue(withIdentifier: "FollowingSegue", sender: nil)
    }
    
    func followButtonTapped() {
        if let user = user {
            if user.currentUserFollowsThisUser {
                unfollowUser(with: user.id)
            } else {
                followUser(with: user.id)
            }
        }
    }
    
    private func unfollowUser(with userID: String) {
        ServerDataProvider.shared.unfollowUserWith(userID: userID) { (result) in
            switch result {
            case.success(value: _):
                self.user?.currentUserFollowsThisUser = false
                self.loadUserData()
                return
            case .failure(error: let error):
                DispatchQueue.main.async {
                    ErrorReporting.showMessage(for: self,
                                               title: nil,
                                               message: error.getErrorDescription(),
                                               withDismissOption: true)
                }
            }
        }
    }
    
    private func followUser(with userID: String) {
        ServerDataProvider.shared.followUserWith(userID: userID) { (result) in
            switch result {
            case.success(value: _):
                self.user?.currentUserFollowsThisUser = true
                self.loadUserData()
                return
            case .failure(error: let error):
                DispatchQueue.main.async {
                    ErrorReporting.showMessage(for: self,
                                               title: nil,
                                               message: error.getErrorDescription(),
                                               withDismissOption: true)
                }
            }
        }
    }
}

