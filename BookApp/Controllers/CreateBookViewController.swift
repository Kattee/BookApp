//
//  CreateBookViewController.swift
//  BookApp
//
//  Created by Katerina Temjanoska on 3/21/21.
//

import UIKit

enum BookEditingType {
    
    case add
    case edit
    
}

protocol AddBookDelegate {
    
    func addBook(book: Book)
    
}

protocol UpdateBookDelegate {
    
    func updateBook()
    
}

class CreateBookViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var releaseYearTextField: UITextField!
    @IBOutlet private weak var authorTextField: UITextField!
    @IBOutlet private weak var genreTextField: UITextField!
    @IBOutlet private weak var addButton: UIButton!
    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var choosePhotoLabel: UILabel!
    @IBOutlet private var tapGesture: UITapGestureRecognizer!
    @IBOutlet private weak var longDescriptionTextView: UITextView!
    
    //MARK: - Properties
    
    var updateDelegate: UpdateBookDelegate?
    var delegate: AddBookDelegate?
    var screenType: BookEditingType = .add
    var book: Book?
    private var selectedImage = UIImage()
    private var randomPhoto: String = ""
    private let datePicker = UIDatePicker()
    private let picker = UIPickerView()
    private let pickerData = ["Comedy", "Action", "Romance", "Adventure", "Science fiction"]
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showDatePicker()
        showPickerView()
        longDescriptionTextView.text = "Long Description"
        longDescriptionTextView.textColor = UIColor.lightGray
        longDescriptionTextView.returnKeyType = .done
        longDescriptionTextView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        changeNavItem()
    }
    
    //MARK: - IBActions
    
    @IBAction private func didTapSelectPhoto(_ sender: Any) {
        choosePhotoLabel.isHidden = true
        let pictures: [String] = ["book1", "book2", "book3", "book5", "book6" ]
        guard let picture = pictures.randomElement() else { return }
        randomPhoto = picture
        selectedImage = UIImage(named: randomPhoto) ??  UIImage()
        photoImageView.image = selectedImage
    }
    
    @IBAction private func didTapAddBook(_ sender: UIButton) {
        guard validateInformation() else {
            showAlert()
            return
        }
        createOrUpdateBook()
    }
    
    
    //MARK: - Private
    
    private func createOrUpdateBook() {
        let title = titleTextField.text ?? ""
        let releaseYear = releaseYearTextField.text ?? ""
        let author = authorTextField.text ?? ""
        let genre = genreTextField.text ?? ""
        let longDescription = longDescriptionTextView.text ?? ""
        
        if screenType == .add {
            let book = Book(title: title,
                            releaseDate: releaseYear,
                            author: author,
                            genre: genre,
                            longDescription: longDescription,
                            photo: randomPhoto)
            BookService.shared.addBook(book: book)
            delegate?.addBook(book: book)
        } else if screenType == .edit {
            guard let book = book else { return }
            BookService.shared.editBook(genre: genre, author: author, longDescription: longDescription, title: book.title)
            updateDelegate?.updateBook()
        }
    }
    
    private func showBooksProperty() {
        guard let book = book,
              let photo = book.photo else { return }
        titleTextField.text = book.title
        titleTextField.isEnabled = false
        titleTextField.backgroundColor = UIColor.lightGray
        releaseYearTextField.text = book.releaseDate
        releaseYearTextField.isEnabled = false
        releaseYearTextField.backgroundColor = UIColor.lightGray
        genreTextField.text = book.genre
        longDescriptionTextView.text = book.longDescription
        authorTextField.text = book.author
        let image = UIImage(named: photo)
        photoImageView.image = image
        tapGesture.isEnabled = false
    }
    
    private func validateInformation() -> Bool {
        let isTitleValid = titleTextField.text != ""
        let isAuthorValid = authorTextField.text != ""
        let isLongDescriptionValid = longDescriptionTextView.text != ""
        let isReleaseDateValid = releaseYearTextField.text != ""
        let isGenreValid = genreTextField.text != ""
        let isImageValid = photoImageView.image != nil
        
        return isTitleValid && isAuthorValid && isLongDescriptionValid && isReleaseDateValid && isGenreValid && isImageValid
    }
    
    private func changeNavItem() {
        navigationController?.navigationBar.barTintColor = UIColor.mainNavColor
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        addButton.backgroundColor = UIColor.mainNavColor
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(cancelCreateScreen))
        navigationController?.navigationBar.tintColor = UIColor.white
        if screenType == .edit {
            choosePhotoLabel.isHidden = true
            navigationItem.title = Constants.editNavigationTitle
            addButton.setTitle("Edit book", for: .normal)
            showBooksProperty()
        } else if screenType == .add{
            navigationItem.title = Constants.addNavigationTitle
            addButton.setTitle("Add book", for: .normal)
        }
    }
    
    @objc private func cancelCreateScreen() {
        dismiss(animated: true, completion: nil)
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: Constants.alertTitle, message: Constants.alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.alertAction, style: .cancel))
        present(alert, animated: true)
    }
    
    private func showDatePicker() {
        datePicker.preferredDatePickerStyle = .wheels
        releaseYearTextField.inputView = datePicker
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        toolbar.tintColor = UIColor.systemBlue
        toolbar.backgroundColor = UIColor.blue
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: nil,
                                         action: #selector(donePressed));
        toolbar.setItems([doneButton], animated: false)
        releaseYearTextField.inputAccessoryView = toolbar
        datePicker.datePickerMode = .date
    }
    
    @objc private func donePressed() {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.dateFormat
        releaseYearTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    private func showPickerView() {
        picker.delegate = self
        genreTextField.inputView = picker
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.tintColor = UIColor.systemBlue
        toolbar.backgroundColor = UIColor.blue
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: nil,
                                         action: #selector(closePickerView))
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        genreTextField.inputAccessoryView = toolbar
    }
    
    @objc private func closePickerView() {
        self.view.endEditing(true)
    }
    
}

//MARK: - UIPickerViewDataSource

extension CreateBookViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
}

//MARK: - UIPickerViewDelegate

extension CreateBookViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genreTextField.text = pickerData[row]
    }
    
}

//MARK: - UITextViewDelegate

extension CreateBookViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Long Description" {
            textView.text = ""
            textView.textColor = UIColor.black
            
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Long Description"
            textView.textColor = UIColor.lightGray
        }
    }
    
}
