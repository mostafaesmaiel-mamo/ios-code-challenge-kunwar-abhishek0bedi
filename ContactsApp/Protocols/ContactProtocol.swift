//
//  ContactProtocol.swift
//  ContactsApp
//
//  Created by kbedi on 09/06/2021.
//
import ContactsUI

protocol ContactFetchable {}

/// To fetch contacts from Phone
protocol PhoneContactsFetchable: ContactFetchable {
	var store: CNContactStore { get }
	var keys: [String] { get }
	func fetchPhoneContacts(onCompletion: @escaping ([ContactProtocol]) -> ())
}

protocol MamoContactsFetchable: ContactFetchable {
	func fetchSearchMamoContacts(emails: [String], orPhones: [String], onCompletion: @escaping (ContactResult) -> ())	
}

/// To present the contact on UI
protocol ContactProtocol {
	var id: String {get}
	var firstName: String {get}
	var lastName: String {get}
	var phoneNumber: String? {get}
	var email: String? {get}
	var isMamoContact: Bool {get}
	var isFrequentContact: Bool {get}
}

extension Array where Self.Element:ContactProtocol {
	var filteredEmails: [String] {
		self.compactMap { contact in
			if let email = contact.email, !email.isEmpty {
				return email
			}
			return nil
		}
	}
}



/// To present the contact on UI
protocol ContactPresentable {
	func configure(withContact contact: ContactProtocol)
}

