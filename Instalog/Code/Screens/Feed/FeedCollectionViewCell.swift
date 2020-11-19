//
//  FeedCollectionViewCell.swift
//  Instalog
//
//  Created by Dimon on 20.07.2020.
//  Copyright © 2020 Dimon. All rights reserved.
//

import UIKit
import Kingfisher

protocol FeedCollectionViewCellDelegate: AnyObject {
    func feedCellDidToggleLikeButton(_ cell: FeedCollectionViewCell)
    func feedCellLikesLabelTapped(_ cell: FeedCollectionViewCell)
    func feedCellUserTapped(_ cell: FeedCollectionViewCell)
}

class FeedCollectionViewCell: UICollectionViewCell {    
    
    // MARK: - Properties
    
    weak var delegate: FeedCollectionViewCellDelegate?
    
    private let dateFormatter = DateFormatter()
    
    private lazy var likeAnimator = LikeAnimator(container: contentView, layoutConstraints: likeImageViewWidthConstraint)
    
    // Adding gesture recognizer to postImage
    private lazy var doubleTapRecognizer: UITapGestureRecognizer = {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))

        tapRecognizer.numberOfTapsRequired = 2
        return tapRecognizer
    }()
    
    // Adding gesture recognizer to likesLabel
    private lazy var likesTap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(likesLabelTapped))
        return tap
    }()
    
    // Adding gesture recognizer to userImage
    private lazy var userImageTap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(userTapped))
        return tap
    }()
    
    private lazy var userNameLabelTap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(userTapped))
        return tap
    }()
    
    // MARK: - Outlets
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var likeImageViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Preparation
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImage.contentMode = .scaleAspectFill
        userImage.layer.cornerRadius = userImage.frame.width / 2
        
        postImage.contentMode = .scaleAspectFill
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        dateFormatter.doesRelativeDateFormatting = true
        
        postImage.addGestureRecognizer(doubleTapRecognizer)
        likesLabel.addGestureRecognizer(likesTap)
        userImage.addGestureRecognizer(userImageTap)
        userNameLabel.addGestureRecognizer(userNameLabelTap)
    }

    // MARK: - Configuring Layout Behavior
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        attributes.size = systemLayoutSizeFitting(layoutAttributes.size, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        return attributes
    }
    
    // MARK: - Public Methods
    
    func configure(with post: PostSDP) {
        
        userImage.kf.setImage(with: post.authorAvatar)
        userNameLabel.text = post.authorUsername
        dateLabel.text = dateFormatter.string(from: post.createdTime)
        
        postImage.kf.setImage(with: post.image)
        likesLabel.text = "Likes: \(post.likedByCount)"
        likeButton.isSelected = post.currentUserLikesThisPost
        descriptionLabel.text = post.description
        descriptionLabel.sizeToFit()
        
        setLikeButtonColor()
        setNeedsLayout()
    }
    
    // MARK: - Private Methods
    
    private func setLikeButtonColor() {
        likeButton.isSelected ? (likeButton.tintColor = .systemBlue) : (likeButton.tintColor = .systemGray)
    }
    
    // MARK: - Actions
    
    @objc private func doubleTapped() {
        
        likeAnimator.animate { }
        
        if !likeButton.isSelected {
            guard let likesString = likesLabel.text else { return }
            guard let numbers = Int(likesString.numbers) else { return }
            likesLabel.text = "Likes: \(numbers + 1)"
            
            
            self.delegate?.feedCellDidToggleLikeButton(self)
            self.likeButton.isSelected.toggle()
            self.setLikeButtonColor()
        }
    }
    
    @IBAction private func likeButtonTapped(_ sender: UIButton) {
        if !likeButton.isSelected {
            guard let likesString = likesLabel.text else { return }
            guard let numbers = Int(likesString.numbers) else { return }
            likesLabel.text = "Likes: \(numbers + 1)"
            likeButton.isSelected.toggle()
            setLikeButtonColor()
        } else {
            guard let likesString = likesLabel.text else { return }
            guard let numbers = Int(likesString.numbers) else { return }
            likesLabel.text = "Likes: \(numbers - 1)"
            likeButton.isSelected.toggle()
            setLikeButtonColor()
        }
        
        delegate?.feedCellDidToggleLikeButton(self)
    }
    
    @objc private func likesLabelTapped() {
        delegate?.feedCellLikesLabelTapped(self)
    }
    
    @objc private func userTapped(_ sender: UITapGestureRecognizer) {
        delegate?.feedCellUserTapped(self)
    }
    
}

