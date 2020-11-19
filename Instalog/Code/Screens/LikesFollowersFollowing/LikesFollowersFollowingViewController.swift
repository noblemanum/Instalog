//
//  LikesAndFollowersViewController.swift
//  Instalog
//
//  Created by Dimon on 01.10.2020.
//  Copyright © 2020 Dimon. All rights reserved.
//

import UIKit

class LikesFollowersFollowingViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    var post: PostSDP?
    var parentUser: UserSDP?
    var users: [UserSDP]?
    var controllerType: UniversalControllerType = .likes
    private lazy var loadingIndicator: LoadingIndicator = {
        return LoadingIndicator(uiView: self.tableView)
    }()
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        
        loadViewData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let selectedIndexPath = tableView.indexPathForSelectedRow else {
            return
        }
        
        if animated,
            let coordinator = transitionCoordinator {
            coordinator.animate { (context) in
                self.tableView.deselectRow(at: selectedIndexPath, animated: true)
            } completion: { (context) in
                if context.isCancelled {
                    self.tableView.selectRow(at: selectedIndexPath, animated: false, scrollPosition: .none)
                }
            }
        } else {
            self.tableView.deselectRow(at: selectedIndexPath, animated: false)
        }
    }
    
    // MARK: - Private
    
    func loadViewData() {
        
        switch controllerType {
        case .likes:
            self.navigationItem.title = "Likes"
            
            if let loadedPost = post {
                ServerDataProvider.shared.usersLikedPost(postID: loadedPost.id) { (resultType) in
                    self.switchResultType(to: resultType)
                }
            }
        case .followers:
            self.navigationItem.title = "Followers"
            
            if let user = parentUser {
                ServerDataProvider.shared.usersFollowingUser(userID: user.id) { (resultType) in
                    self.switchResultType(to: resultType)
                }
            }
        case .following:
            self.navigationItem.title = "Following"
            
            if let user = parentUser {
                ServerDataProvider.shared.usersFollowedByUser(userID: user.id) { (resultType) in
                    self.switchResultType(to: resultType)
                }
            }
        }
    }
    
    private func switchResultType(to resultType: Result<[UserSDP]>) {
        
        switch resultType {
        case .success(value: let users):
            var temp: [UserSDP] = []
            
            for user in users {
                temp.append(user)
            }
            self.users = temp
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.separatorStyle = .singleLine
                self.loadingIndicator.hide()
            }
        case .failure(error: let error):
            DispatchQueue.main.sync {
                self.loadingIndicator.hide()
                ErrorReporting.showMessage(for: self,
                                           title: nil,
                                           message: error.getErrorDescription(),
                                           withDismissOption: true)
            }
        }
    }
    
    // MARK: - Configuring Layout
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        loadingIndicator.show()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProfileSegue",
            let destination = segue.destination as? ProfileViewController,
            let users = users,
            let listItemIndex = tableView.indexPathForSelectedRow {
            let tempUser = users[listItemIndex.row]
//            destination.user = tempUser
            destination.profileType = .user(id: tempUser.id)
            destination.parentVC = self
        }
    }
}

    // MARK: - Table View Data Source

extension LikesFollowersFollowingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let users = users else { return 1 }
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCellIdentifier", for: indexPath)

        if let users = users {
            let user = users[indexPath.row]
            cell.imageView?.kf.setImage(with: user.avatar)
            cell.textLabel?.text = user.username
        }

        return cell
    }
}

    // MARK: - Table View Delegate

extension LikesFollowersFollowingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "ProfileSegue", sender: nil)
    }
}
