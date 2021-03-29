//
//  BookDetailsViewController.swift
//  BookApp
//
//  Created by Katerina Temjanoska on 3/21/21.
//

import UIKit

class BookDetailsViewController: UIViewController {

    //MARK: - IBOutlets
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var yearLabel: UILabel!
    @IBOutlet private weak var genreLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var longDescriptionLabel: UILabel! 
    
    //MARK: - Properties
    
    var delegate: AddBookDelegate?
    var selectedBook: Book?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showBookDetails()
        navigationBar()
    }

    //MARK: - Private
    
    @objc private func cancelDetailScreen() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func openEditScreen() {
        guard let viewController = storyboard?.instantiateViewController(withIdentifier: Constants.createBookIdentifier) as? CreateBookViewController else { return }
        viewController.book = selectedBook
        viewController.screenType = .edit
        viewController.updateDelegate = self
        let newViewController = UINavigationController(rootViewController: viewController)
        self.navigationController?.present(newViewController, animated: true)
    }
    
    @objc private func deleteBook() {
        guard let selectedBook = selectedBook else { return }
        BookService.shared.deleteBook(deleteBook: selectedBook)
        delegate?.addBook(book: selectedBook)
    }
    
    private func showBookDetails() {
        guard let selectedBook = selectedBook,
              let photo = selectedBook.photo else { return }
        let image = UIImage(named: photo)
        imageView.image = image
        titleLabel.text = selectedBook.title
        yearLabel.text = selectedBook.releaseDate
        genreLabel.text = selectedBook.genre
        authorLabel.text = selectedBook.author
        longDescriptionLabel.text = selectedBook.longDescription
    }
    
    private func navigationBar() {
        navigationController?.navigationBar.barTintColor = UIColor.mainNavColor
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop,
                                                           target: self,
                                                           action: #selector(cancelDetailScreen))
        let edit = UIBarButtonItem(barButtonSystemItem: .edit,
                                   target: self,
                                   action: #selector(openEditScreen))
        let trash = UIBarButtonItem(barButtonSystemItem: .trash,
                                    target: self,
                                    action: #selector(deleteBook))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        edit.tintColor = UIColor.white
        trash.tintColor = UIColor.white
        navigationItem.rightBarButtonItems = [trash, edit]
    }


}

//MARK: UpdateBookDelegate

extension BookDetailsViewController: UpdateBookDelegate {
    
    func updateBook() {
        self.dismiss(animated: true) {
            guard let selectedBook = self.selectedBook else { return }
            self.selectedBook = BookService.shared.selectedBook(selectedBook: selectedBook)
            self.authorLabel.text = selectedBook.author
            self.genreLabel.text = selectedBook.genre
            self.longDescriptionLabel.text = selectedBook.longDescription
        }
    }
    
}
