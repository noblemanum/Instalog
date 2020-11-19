//
//  NewPostViewController.swift
//  Instalog
//
//  Created by Dimon on 03.09.2020.
//  Copyright © 2020 Dimon. All rights reserved.
//

import UIKit

class NewPostViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var photosCollectionView: UICollectionView!
    
    // MARK: - Properties
    
    private var photos = [UIImage]()
    private var selectedPhoto: UIImage?
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadGallery()
        photosCollectionView.register(cellType: NewPostPhotoCollectionViewCell.self)
        photosCollectionView.dataSource = self
        
        configureLayout()
    }
    
    // MARK: - Private Methods
    
    private func loadGallery() {
        photos = Bundle.main.paths(forResourcesOfType: "jpg", inDirectory: "PhotosFolder").compactMap({
            (url)-> UIImage? in
            return UIImage(contentsOfFile: url)
        })
    }
    
    private func configureLayout() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (self.view.bounds.width - 2) / 3,
                                 height: (self.view.bounds.width - 2) / 3)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        photosCollectionView.collectionViewLayout = layout
    }
    
    private func createThumbnailPhotoImage(of image: UIImage) -> UIImage? {
        let newSize = CGSize(width: 30, height: 30)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        guard let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        return newImage
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewPostFiltersSegue",
            let destination = segue.destination as? FiltersViewController,
            let photo = selectedPhoto {
            destination.photo = photo
            destination.thumbnailPhoto = createThumbnailPhotoImage(of: photo)
        }
    }
}

    // MARK: - Collection View Data Source

extension NewPostViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! NewPostPhotoCollectionViewCell
        
        cell.delegate = self
        cell.image.image = photos[indexPath.item]
        return cell
    }
}

    // MARK: - New Post Photo Collection Cell Delegate

extension NewPostViewController: NewPostPhotoCollectionCellDelegate {
    
    func userTappedOnNewPostCell(_ cell: NewPostPhotoCollectionViewCell) {
        selectedPhoto = cell.image.image
        performSegue(withIdentifier: "NewPostFiltersSegue", sender: nil)
    }
}
