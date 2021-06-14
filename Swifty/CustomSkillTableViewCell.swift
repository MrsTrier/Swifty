//
//  CustomSkillTableViewCell.swift
//  Swifty
//
//  Created by Darya on 13.06.2021.
//

import UIKit


class CustomSkillTableViewCell: UITableViewCell {

	static let identifier = "CustomSkillTableViewCell"

	private let skillName: UILabel = {
		let label = UILabel()
		label.font = UIFont(name: "Futura-Medium", size: 15)
		return label
	}()

	private let skillLevel: UILabel = {
		let label = UILabel()
		label.font = UIFont(name: "Futura-Bold", size: 14)
		return label
	}()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		contentView.addSubview(skillName)
		contentView.addSubview(skillLevel)


	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	func configure(skillName: String, skillLevel: String) {
		self.skillName.text = skillName
		self.skillLevel.text = skillLevel
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		self.skillName.text = nil
		self.skillLevel.text = nil
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		skillName.translatesAutoresizingMaskIntoConstraints = false
		skillLevel.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([

			skillLevel.centerYAnchor.constraint(lessThanOrEqualTo: centerYAnchor, constant:0),
			skillLevel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),

			skillName.centerYAnchor.constraint(lessThanOrEqualTo: centerYAnchor, constant:0),
			skillName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16)

		])

	}
}
