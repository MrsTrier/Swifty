//
//  SearchViewController.swift
//  Swifty
//
//  Created by Darya on 08.06.2021.
//


import UIKit
import AuthenticationServices


struct Errors {
	static let connectionError = "Ops... Seems like you have problems with network connection"
	static let nickNameError = "Ops... Seems like you entered unexpected nickname"
	static let noNickNameError = "Ops... Seems like you have not entered any nickname"
	static let unknownError = "Ops... Seems like something went wrong"
 }


class SearchViewController: UIViewController, UINavigationBarDelegate {


	var userSent: Peer?

	var peerInformationViewController: PeerInformationViewController?
	func showErorr(title: String, message: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
		let searchView = self.view as! SearchView
		searchView.toggleActivityIndicator(on: false)
		self.present(alert, animated: true)
	}

	override func loadView() {
		let view = SearchView()
		view.delegate = self
		self.view = view
		self.view.clipsToBounds = true
	}

	override func viewWillAppear(_ animated: Bool) {

	}

	override func viewDidLoad() {
		super.viewDidLoad()
		let searchView = self.view as! SearchView
		searchView.toggleActivityIndicator(on: true)
		NetworkService.shared.postRequestToken() { (responce) in
			searchView.toggleActivityIndicator(on: false)
			if responce == nil {
				self.showErorr(title: Errors.connectionError,
							   message: "Please check your connection and try again")
				return
			}
		}

	}

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		view.endEditing(true)
	}
}

// MARK: SearchViewDelegate
extension SearchViewController: SearchViewDelegate {

	func letsGoButtonTapped(peerName: String) {
		let searchView = self.view as! SearchView
		if peerName.isEmpty {
			self.showErorr(title: Errors.noNickNameError ,
						   message: "Please enter name and try again")
			return
		}
		searchView.toggleActivityIndicator(on: true)
		NetworkService.shared.getData(peerName: peerName.lowercased()) { (responce, error) in
			searchView.toggleActivityIndicator(on: false)
			if responce == nil {
				if error?.localizedDescription == "The data couldn’t be read because it is missing." {
					self.showErorr(title: Errors.nickNameError ,
								   message: "Please corect the name and try again")
				}
				else if error?.localizedDescription == "The Internet connection appears to be offline." {
					self.showErorr(title: Errors.connectionError,
								   message: "Please corect the name and try again")
				}
				else {
					self.showErorr(title: Errors.unknownError ,
								   message: "Please try again later")
				}
				return
			}
			self.userSent = responce
			self.push()
		}
	}

	func push() {
		guard let userSent = userSent else {
			return
		}
		peerInformationViewController = PeerInformationViewController(userSent: userSent)
		guard let peerInformationViewController = peerInformationViewController else {
			return
		}
		let navigation = UINavigationController(rootViewController: peerInformationViewController)
		navigation.navigationBar.prefersLargeTitles = true
		let navBarAppearance = UINavigationBarAppearance()
		navBarAppearance.configureWithOpaqueBackground()
		navBarAppearance.backgroundColor = UIColor.systemBackground
		navigation.navigationBar.standardAppearance = navBarAppearance
		navigation.navigationBar.scrollEdgeAppearance = navBarAppearance
		navigation.modalPresentationStyle = .fullScreen
		present(navigation, animated: true)
	}

}
