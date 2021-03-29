//
//  BookImageCollectionViewCell.swift
//  BookApp
//
//  Created by Katerina Temjanoska on 3/21/21.
//

import UIKit

class BookImageCollectionViewCell: UICollectionViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    //MARK: - Public
    
    func setUp(_ book: Book) {
        guard let image = book.photo else { return }
        let selectedImage = UIImage(named: image) ??  UIImage()
        photoImageView.image = selectedImage
        nameLabel.text = book.title
    }
    
}
