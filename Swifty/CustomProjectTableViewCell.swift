//
//  CustomProjectTableViewCell.swift
//  Swifty
//
//  Created by Darya on 11.06.2021.
//

import UIKit


class CustomProjectTableViewCell: UITableViewCell {

	static let identifier = "CustomProjectTableViewCell"

	private let projectName: UILabel = {
		let label = UILabel()
		label.font = UIFont(name: "Futura-Medium", size: 15)
		return label
	}()

	private let projectScore: UILabel = {
		let label = UILabel()
		label.font = UIFont(name: "Futura-Bold", size: 14)
		return label
	}()


	private let projectStatusRepresentation: UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage(systemName: "xmark.circle")
		imageView.tintColor = .systemRed

		return imageView
	}()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		contentView.addSubview(projectName)
		contentView.addSubview(projectScore)
		contentView.addSubview(projectStatusRepresentation)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func configure(projectName: String, projectScore: String, projectStatus: String) {
		self.projectName.text = projectName
		self.projectScore.text = projectScore
		if projectStatus == "finished" {
			projectStatusRepresentation.image = UIImage(systemName: "checkmark")
			projectStatusRepresentation.tintColor =	.systemGreen
		} else if projectStatus == "in_progress" {
			projectStatusRepresentation.image = UIImage(systemName: "clock")
			projectStatusRepresentation.tintColor =	.systemYellow
		}else if projectStatus == "searching_a_group" {
			projectStatusRepresentation.image = UIImage(systemName: "eyes")
			projectStatusRepresentation.tintColor =	.systemTeal
		}
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		self.projectName.text = nil
		self.projectScore.text = nil
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		projectName.translatesAutoresizingMaskIntoConstraints = false
		projectScore.translatesAutoresizingMaskIntoConstraints = false
		projectStatusRepresentation.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([

			projectScore.centerYAnchor.constraint(lessThanOrEqualTo: centerYAnchor),
			projectScore.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
			projectStatusRepresentation.centerYAnchor.constraint(equalTo: centerYAnchor),
			projectStatusRepresentation.trailingAnchor.constraint(equalTo: projectScore.trailingAnchor,
																  constant: -32),
			projectName.centerYAnchor.constraint(lessThanOrEqualTo: centerYAnchor, constant:0),
			projectName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8)

		])

	}
}
