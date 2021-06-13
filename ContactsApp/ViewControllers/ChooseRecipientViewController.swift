//
//  ChooseRecipientViewController.swift
//  ContactsApp
//
//  Created by kbedi on 09/06/2021.
//

import UIKit
import Contacts

class ChooseRecipientViewController: UIViewController {
    
	//MARK: - IBOutlets
	@IBOutlet weak var containerView: UIView!
	@IBOutlet weak var footerView: UIView!

	//MARK: - Variables
	private var phoneContactManager: PhoneContactsFetchable!
	private var viewModel =  ChooseRecipientViewModel()
	private var collectionViewController: CollectionViewController!
	lazy var loader = LoaderView()
	
	//MARK: - ViewController Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "#Choose Recipient"
		
		guard phoneContactManager != nil else {
			fatalError("Contact Manager Cannot be Nil")
		}
		
		fetchPhoneContacts()
	}
	
	//MARK: - Configuration Methods
	func configure(withContactManager manager: PhoneContactsFetchable = ContactsManager()) {
		phoneContactManager = manager
	}
}

extension ChooseRecipientViewController {
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "segue_embed" {
			if let vc = segue.destination as? CollectionViewController {
				collectionViewController = vc
			}
		}
	}
	
	func reload() {
		collectionViewController.collectionView.reloadData()
	}
}

//MARK: - Contacts Related Functions
fileprivate extension ChooseRecipientViewController {
	
	func updateCollectionViewController(contacts: [ContactProtocol]) {
		collectionViewController.configure(withContacts: contacts)
	}
	
	func fetchPhoneContacts() {
		showHideViewsWhileLoading(canShow: false)
		loader.showOn(self.view)
		
		phoneContactManager.fetchPhoneContacts { [weak self] phoneContacts in
			DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // Deliberately put to show the spinner
				self?.showHideViewsWhileLoading(canShow: true)
				self?.loader.hide()
				self?.updateCollectionViewController(contacts: phoneContacts)
				self?.reload()
			}
		}
	}
		
	func showHideViewsWhileLoading(canShow: Bool) {
		if canShow {
			containerView.isHidden = false
			footerView.isHidden = false
		}
		else {
			containerView.isHidden = true
			footerView.isHidden = true
		}
	}
}
