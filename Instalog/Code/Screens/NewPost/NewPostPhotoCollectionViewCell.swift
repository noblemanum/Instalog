//
//  NewPostPhotoCollectionViewCell.swift
//  Instalog
//
//  Created by Dimon on 03.09.2020.
//  Copyright © 2020 Dimon. All rights reserved.
//

import UIKit

protocol NewPostPhotoCollectionCellDelegate: AnyObject {
    func userTappedOnNewPostCell(_ cell: NewPostPhotoCollectionViewCell)
}

class NewPostPhotoCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var image: UIImageView!
    
    // MARK: - Properties
    
    var thumbnailPhoto: UIImage?
    
    weak var delegate: NewPostPhotoCollectionCellDelegate?
    
    private lazy var imageTap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        return tap
    }()
    
    // MARK: - Preparation
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        image.addGestureRecognizer(imageTap)
    }
    
    // MARK: - Private Methods
    
    @objc private func imageViewTapped() {
        delegate?.userTappedOnNewPostCell(self)
    }
}
