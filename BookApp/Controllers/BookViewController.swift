//
//  BookViewController.swift
//  BookApp
//
//  Created by Katerina Temjanoska on 3/21/21.
//

import UIKit

class BookViewController: UIViewController {

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.mainNavColor
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: - IBActions
    
    @IBAction private func didTapShowBooks(_ sender: Any) {
        guard let newViewController = storyboard?.instantiateViewController(withIdentifier: Constants.bookGalleryIdentifier) as? BookGalleryViewController else { return }
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
}
