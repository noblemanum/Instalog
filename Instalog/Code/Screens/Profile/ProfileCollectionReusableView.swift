//
//  ProfileCollectionReusableView.swift
//  Instalog
//
//  Created by Dimon on 26.07.2020.
//  Copyright © 2020 Dimon. All rights reserved.
//

import UIKit

protocol ProfileCollectionReusableViewDelegate: AnyObject {
    func followButtonTapped()
    func followersLabelTapped()
    func followingLabelTapped()
}

class ProfileCollectionReusableView: UICollectionReusableView {
    
    // MARK: - Outlets
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNicknameLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    // MARK: - Properties
    
    weak var delegate: ProfileCollectionReusableViewDelegate?
    
    // Adding gesture recognizer to followersLabel
    private lazy var followersTap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(followersLabelTapped))
        return tap
    }()
    
    // Adding gesture recognizer to followingLabel
    private lazy var followingTap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(followingLabelTapped))
        return tap
    }()
    
    // MARK: - Preparation
    
    override func awakeFromNib() {
        
        followButton.backgroundColor = .systemBlue
        followButton.setTitleColor(.white, for: .normal)
        followButton.layer.cornerRadius = 5
        
        followersLabel.addGestureRecognizer(followersTap)
        followingLabel.addGestureRecognizer(followingTap)
    }
    
    // MARK: - Actions
    
    @IBAction private func followButtonTapped(_ sender: UIButton) {
        
        if followButton.title(for: .normal) == "Follow" {
            followButton.setTitle("Unfollow", for: .normal)
        } else {
            followButton.setTitle("Follow", for: .normal)
        }
        
        delegate?.followButtonTapped()
    }
    
    @objc private func followersLabelTapped() {
        delegate?.followersLabelTapped()
    }
    
    @objc private func followingLabelTapped() {
        delegate?.followingLabelTapped()
    }
}
