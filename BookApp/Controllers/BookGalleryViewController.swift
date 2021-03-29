//
//  BookGalleryViewController.swift
//  BookApp
//
//  Created by Katerina Temjanoska on 3/21/21.
//

import UIKit

class BookGalleryViewController: UIViewController {

    //MARK: - IBOutlets
    
    @IBOutlet private weak var addBarButtonItem: UIBarButtonItem!
    @IBOutlet private weak var imageCollectionView: UICollectionView!
    
    //MARK: - Properties
    
    private var books: [Book] = []
    private let columnCount = 3.0
    private let minimumInteritemSpacing: CGFloat = 10.0
    private let sectionInsets = UIEdgeInsets(top: 10.0,
                                             left: 10.0,
                                             bottom: 10.0,
                                             right: 10.0)
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Books"
        self.books = BookService.shared.books
        self.imageCollectionView.reloadData()
    }
    
    //MARK: - IBActions
    
    @IBAction private func didTapAddBook(_ sender: Any) {
        openAddBook()
    }
    
    @IBAction private func didTapAddBookButton(_ sender: Any) {
        openAddBook()
    }
    
    //MARK: - Private
    
    private func openAddBook() {
        guard let newViewController = storyboard?.instantiateViewController(withIdentifier: Constants.createBookIdentifier) as? CreateBookViewController else { return }
        newViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: newViewController)
        newViewController.screenType = .add
        self.navigationController?.present(navigationController, animated: true)
    }

}

//MARK: - UICollectionViewDelegateFlowLayout

extension BookGalleryViewController: UICollectionViewDelegateFlowLayout {
    
    var flowLayout: UICollectionViewFlowLayout? {
        return imageCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout
    }
    
    func collectionView(_ collectinoView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpace = sectionInsets.left + sectionInsets.right + (minimumInteritemSpacing * CGFloat(columnCount - 1))
        let width = Int((imageCollectionView.bounds.width - totalSpace) / CGFloat(columnCount))
        let height = (width * 2) - (width / 2)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int ) -> UIEdgeInsets {
        return sectionInsets
    }
    
}


//MARK: - UICollectionViewDataSource

extension BookGalleryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == books.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.addBookImageCollectionViewCell, for: indexPath)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(BookImageCollectionViewCell.self)", for: indexPath) as? BookImageCollectionViewCell else { return UICollectionViewCell() }
            let book = books[indexPath.item]
            cell.setUp(book)
            return cell
        }
    }
    
}

//MARK: - UICollectionViewDataSource

extension BookGalleryViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item != books.count,
              let viewController = storyboard?.instantiateViewController(withIdentifier: Constants.bookDetailsIdentifier) as? BookDetailsViewController else { return }
        let selectedBook = books[indexPath.item]
        viewController.selectedBook = selectedBook
        viewController.delegate = self
        let navigationController = UINavigationController(rootViewController: viewController)
        self.navigationController?.present(navigationController, animated: true)
    }
    
}

//MARK: - AddBookDelegate

extension BookGalleryViewController: AddBookDelegate {
    
    func addBook(book: Book) {
        self.dismiss(animated: true) {
            self.books = BookService.shared.books
            self.imageCollectionView.reloadData()
        }
    }
    
}
