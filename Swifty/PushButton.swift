//
//  PushButton.swift
//  Swifty
//
//  Created by Darya on 08.06.2021.
//

import UIKit

class PushButton: UIButton {

	// MARK: - Initialization
	convenience init(image: UIImage?,
					 alpha: CGFloat = 1,
					 transformScale: CGFloat = 0.7) {
		self.init()

		adjustsImageWhenHighlighted = false
		setImage(image, for: .normal)
		self.alpha = alpha
		self.transformScale = transformScale
	}

	convenience init(title: String,
					 titleColor: UIColor,
					 backgroundColor: UIColor,
					 font: UIFont?,
					 cornerRadius: CGFloat,
					 transformScale: CGFloat = 0.7) {
		self.init()

		adjustsImageWhenHighlighted = false
		layer.cornerRadius = cornerRadius
		self.backgroundColor = backgroundColor
		self.transformScale = transformScale
		addLabel(text: title, font: font, color: titleColor)
	}

	// MARK: - Properties
	private var transformScale: CGFloat = 0.7

	override var isHighlighted: Bool {
		willSet {
			animate(with: newValue)
		}
	}

	// MARK: - Module function
	private func animate(with value: Bool) {

		var transform = CGAffineTransform.identity

		if value {
			transform = CGAffineTransform(scaleX: transformScale,
										  y: transformScale)
		}

		UIView.animate(withDuration: 0.2) {
			self.transform = transform
		}
	}

	private func addLabel(text: String, font: UIFont?, color: UIColor) {

		let label = UILabel(text: text, font: font, color: color,
							lines: 1, alignment: .center)
		label.translatesAutoresizingMaskIntoConstraints = false
		addSubview(label)

		NSLayoutConstraint.activate([
			label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: bounds.width / 4),
			label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -bounds.width / 4),
			label.topAnchor.constraint(equalTo: topAnchor, constant: bounds.height / 3),
			label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bounds.height / 3)
		])
	}
}

extension UILabel {

	convenience init(text: String,
					 font: UIFont?,
					 color: UIColor,
					 lines: Int = 1,
					 alignment: NSTextAlignment = .center) {
		self.init()

		self.text = text
		self.textColor = color
		self.font = font
		self.adjustsFontSizeToFitWidth = true
		self.numberOfLines = lines
		self.textAlignment = alignment
	}
}

extension UIButton {

	func addRightImage(image: UIImage?,
					   side: CGFloat,
					   offset: CGFloat) {

		let imageView = UIImageView(image: image)
		addSubview(imageView)

		NSLayoutConstraint.activate([
			imageView.widthAnchor.constraint(equalToConstant: side),
			imageView.heightAnchor.constraint(equalToConstant: side),
			imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: offset),
			imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
		])
	}
}
