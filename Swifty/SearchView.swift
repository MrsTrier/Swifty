//
//  SearchView.swift
//  Swifty
//
//  Created by Darya on 08.06.2021.
//

import UIKit


protocol SearchViewDelegate: AnyObject {

	func letsGoButtonTapped(peerName: String)

}

class SearchView: UIView {

	weak var delegate: SearchViewDelegate?

	var activityView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))

	private var userNameTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))

	private let letsGoButton = PushButton(title: "LET'S GO!!!",
										  titleColor: .black,
										  backgroundColor: .white,
										  font: .boldSystemFont(ofSize: 12),
										  cornerRadius: 23,
										  transformScale: 0.8)

	// MARK: - Initialization
	override init(frame: CGRect) {
		super.init(frame: frame)
		userNameTextField.text = "mcanhand"

	}

	override func layoutSubviews() {
		super.layoutSubviews()
		setupViews()
		self.setImageAsBackground(named: "backgroung")
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Actions
	@objc private func letsGoButtonTapped() {
		delegate?.letsGoButtonTapped(peerName: userNameTextField.text ?? "")
	}

	private func setupViews() {
		self.activityView.style =  UIActivityIndicatorView.Style.gray
		letsGoButton.addTarget(self, action: #selector(letsGoButtonTapped), for: .touchUpInside )
		addSubview(letsGoButton)
		addSubview(userNameTextField)
		addSubview(activityView)

		setupConstraints()
	}

	private func setupConstraints() {
		userNameTextField.translatesAutoresizingMaskIntoConstraints = false
		activityView.translatesAutoresizingMaskIntoConstraints = false
		letsGoButton.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([

			userNameTextField.centerYAnchor.constraint(lessThanOrEqualTo: centerYAnchor, constant: -50),
			userNameTextField.centerXAnchor.constraint(equalTo: centerXAnchor),

			activityView.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor, constant: 10),
			activityView.centerXAnchor.constraint(equalTo: centerXAnchor),

			letsGoButton.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor, constant: 30),
			letsGoButton.centerXAnchor.constraint(equalTo: centerXAnchor),
			letsGoButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width / 4),
			letsGoButton.heightAnchor.constraint(equalToConstant: 55)

		])
	}

	

	public func toggleActivityIndicator(on: Bool) {
	  if on {
		self.activityView.startAnimating()
	  } else {
		self.activityView.stopAnimating()
	  }
	}
}

extension UIView {
	func setImageAsBackground(named image: String) {
		let width = UIScreen.main.bounds.size.width
		let height = UIScreen.main.bounds.size.height

		let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))

		guard let backgroundImage = UIImage(named: image) else {
			self.backgroundColor = .systemGreen
			return
		}
		imageViewBackground.image = backgroundImage
		imageViewBackground.contentMode = UIView.ContentMode.scaleAspectFill
//		imageViewBackground.clipsToBounds = true

		self.addSubview(imageViewBackground)
		self.sendSubviewToBack(imageViewBackground)
	}
}
