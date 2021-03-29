//
//  BookService.swift
//  BookApp
//
//  Created by Katerina Temjanoska on 3/21/21.
//

import Foundation

class BookService {
    
    //MARK: - Properties
    
    static let shared = BookService()
    private var listOfBooks: [Book] = []
    
    //MARK: - BookService
    
    private init(){}
    
    //MARK: - Public
    
    func addBook(book: Book) -> Void {
        self.listOfBooks.insert(book, at: 0)
    }
    
    func editBook( genre: String,
                   author: String,
                   longDescription: String,
                   title: String) {
        for book in self.listOfBooks where book.title == title {
            book.genre = genre
            book.author = author
            book.longDescription = longDescription
        }
    }
    
    func deleteBook(deleteBook: Book) {
        self.listOfBooks = self.listOfBooks.filter({ $0.title != deleteBook.title })
    }
    
    var books: [Book] {
        return self.listOfBooks
    }
    
    var numberOfBooks: Int {
        return self.listOfBooks.count
    }
    
    func selectedBook(selectedBook: Book) -> Book {
        var updateSelectedBook: Book?
        for book in self.listOfBooks where book.title == selectedBook.title {
            updateSelectedBook = selectedBook
        }
        return updateSelectedBook!
    }
}

