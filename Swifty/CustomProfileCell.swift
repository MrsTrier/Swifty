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

	lazy var levelView: UIView = {
		let view = UIView()
		view.backgroundColor = .systemGreen
		view.translatesAutoresizingMaskIntoConstraints = false

		return view
	}()

	lazy var shadowForLevelView: UIView = {

		let view = UIView()
		view.backgroundColor = .systemGray
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	lazy var staffLableView: UIView = {
		let label = UILabel()
		label.textColor = .white
		label.text = "staff"
		let view = UIView()
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
		label.font = .systemFont(ofSize: 28)
		label.textAlignment = .left
		label.translatesAutoresizingMaskIntoConstraints = false

		return label
	}()

	var walletLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 20)
		label.textAlignment = .left

		label.translatesAutoresizingMaskIntoConstraints = false

		return label
	}()

	var evaluationPointsLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 20)
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
		addLevelView()
	}

	func addLevelView() {
		levelView.removeFromSuperview()
		levelLabel.removeFromSuperview()
		willRemoveSubview(shadowForLevelView)

		shadowForLevelView.layer.cornerRadius = shadowForLevelView.frame.width / 25
		levelView.layer.cornerRadius = levelView.frame.width / 25
		staffLableView.layer.cornerRadius = staffLableView.frame.width / 25

		levelLabel.translatesAutoresizingMaskIntoConstraints = false
		shadowForLevelView.addSubview(levelView)
		shadowForLevelView.addSubview(levelLabel)
		let width: CGFloat = CGFloat(level.truncatingRemainder(dividingBy: 1)) * CGFloat(self.bounds.width - 32)
		levelView.leadingAnchor.constraint(equalTo: shadowForLevelView.leadingAnchor).isActive = true
		levelView.widthAnchor.constraint(equalToConstant: width).isActive = true
		levelView.heightAnchor.constraint(equalTo: shadowForLevelView.heightAnchor).isActive = true

		levelLabel.centerXAnchor.constraint(equalTo: shadowForLevelView.centerXAnchor).isActive = true
		levelLabel.centerYAnchor.constraint(equalTo: shadowForLevelView.centerYAnchor).isActive = true
		addSubview(shadowForLevelView)
		if isStaff {
			addSubview(staffLableView)
		}
		setupConstraints()
		layoutIfNeeded()
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		addLevelView()
	}

	private func setupConstraints() {

		NSLayoutConstraint.activate([
			profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
			profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
			profileImageView.heightAnchor.constraint(equalToConstant: 164),
			profileImageView.widthAnchor.constraint(equalToConstant: 164),

			shadowForLevelView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
			shadowForLevelView.widthAnchor.constraint(equalToConstant: self.bounds.width - 32),
			shadowForLevelView.heightAnchor.constraint(equalToConstant: 44),
			shadowForLevelView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 24),

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
