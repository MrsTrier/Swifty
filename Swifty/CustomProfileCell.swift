//
//  CustomProfileCell.swift
//  Swifty
//
//  Created by Darya on 11.06.2021.
//

import UIKit

final class CustomProfileCell: UITableViewCell {

	static let identifier = "CustomProfileCell"
	private let levelLabel = UILabel()
	private var level: Float = 0.0
	private var isStaff: Bool = false

	lazy var profileImageView: UIImageView = {

		let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 164, height: 164))

		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()

	lazy var levelView: UIProgressView = {
		let view = UIProgressView()
		view.progressTintColor = .systemGreen
		view.trackTintColor = .systemGray
		view.layer.cornerRadius = 22
		view.clipsToBounds = true
		view.layer.sublayers?[1].cornerRadius = 22
		view.subviews[1].clipsToBounds = true
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	lazy var staffLableView: UIView = {
		let label = UILabel()
		label.textColor = .white
		label.text = "staff"
		let view = UIView()
		view.layer.cornerRadius = 12
		view.backgroundColor = .systemGreen
		view.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(label)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
		return view
	}()

	var profileNameLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont(name: "Futura-Medium", size: 24)

		label.textAlignment = .left
		label.translatesAutoresizingMaskIntoConstraints = false

		return label
	}()

	var walletLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont(name: "Futura-Medium", size: 16)
		label.textAlignment = .left

		label.translatesAutoresizingMaskIntoConstraints = false

		return label
	}()

	var evaluationPointsLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont(name: "Futura-Medium", size: 16)
		label.textAlignment = .left
		label.translatesAutoresizingMaskIntoConstraints = false

		return label
	}()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {

		super.init(style: style, reuseIdentifier: reuseIdentifier)
		profileImageView.makeRounded()
		addSubview(profileImageView)
		addSubview(profileNameLabel)
		addSubview(walletLabel)
		addSubview(evaluationPointsLabel)
		

	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		self.profileImageView.image = nil
		self.profileNameLabel.text = nil
		self.walletLabel.text = nil
		self.evaluationPointsLabel.text = nil
	}

	func configure(profileImage: UIImage, profileName: String,
				   wallet: String, evaluationPoints: String, level: Float, who: Bool) {

		profileNameLabel.text = profileName
		profileImageView.image = profileImage
		profileImageView.contentMode = .scaleAspectFill
		walletLabel.text = wallet
		evaluationPointsLabel.text = evaluationPoints
		levelLabel.text = "\(level) %"
		levelLabel.textColor = .white
		self.level = level
		self.isStaff = who
		if isStaff {
			addSubview(staffLableView)
		}
		addLevelView()
	}

	func addLevelView() {
		let levelFraction: Float = Float(level) - Float(Int(level))
		levelView.setProgress(levelFraction, animated: true)
		addSubview(levelView)
		levelLabel.translatesAutoresizingMaskIntoConstraints = false
		levelView.addSubview(levelLabel)
		setupConstraints()
	}

	private func setupConstraints() {

		NSLayoutConstraint.activate([
			profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
			profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
			profileImageView.heightAnchor.constraint(equalToConstant: 164),
			profileImageView.widthAnchor.constraint(equalToConstant: 164),

			levelView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
			levelView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
			levelView.heightAnchor.constraint(equalToConstant: 44),
			levelView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 24),

			levelLabel.centerXAnchor.constraint(equalTo: levelView.centerXAnchor),
			levelLabel.centerYAnchor.constraint(equalTo: levelView.centerYAnchor),

			profileNameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16),
			profileNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),

			walletLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16),
			walletLabel.topAnchor.constraint(equalTo: profileNameLabel.bottomAnchor, constant: 16),

			evaluationPointsLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16),
			evaluationPointsLabel.topAnchor.constraint(equalTo: walletLabel.bottomAnchor, constant: 16)
		])
		if self.isStaff {
			NSLayoutConstraint.activate([

				staffLableView.topAnchor.constraint(equalTo: evaluationPointsLabel.bottomAnchor, constant: 16),
				staffLableView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16),
				staffLableView.widthAnchor.constraint(equalToConstant: 128),
				staffLableView.heightAnchor.constraint(equalToConstant: 24)
			])
		}

	}

}


extension UIImageView {

	func makeRounded() {
		self.layer.masksToBounds = false
		self.layer.cornerRadius = self.bounds.width / 7
		self.clipsToBounds = true
	}
}
