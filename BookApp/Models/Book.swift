//
//  Book.swift
//  BookApp
//
//  Created by Katerina Temjanoska on 3/21/21.
//

import Foundation

class Book {
    
    //MARK: - Properties
    
    var title: String
    var releaseDate: String
    var author: String
    var genre: String
    var longDescription: String
    var photo: String?
    
    //MARK: - Book
    
    init(title: String, releaseDate: String, author: String, genre: String, longDescription: String, photo: String?) {
        self.title = title
        self.releaseDate = releaseDate
        self.author = author
        self.genre = genre
        self.longDescription = longDescription
        self.photo = photo
    }
    
}
