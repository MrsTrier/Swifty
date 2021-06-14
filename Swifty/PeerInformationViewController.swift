//
//  PeerInformationViewController.swift
//  Swifty
//
//  Created by Darya on 08.06.2021.
//

import UIKit

struct ProjectModel {
	let fieldName: String
	let value: String
	let status: String
}

struct SkillModel {
	let fieldName: String
	let value: String
//	let status: String
}

class PeerInformationViewController: UIViewController {

	var userSent: Peer
	lazy var projectData : [ProjectModel] = []
	lazy var skillData : [SkillModel] = []

	var tableViewInfo = UITableView()


	init(userSent: Peer) {
		self.userSent = userSent
		super.init(nibName: nil, bundle: nil)

	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationItem.title = userSent.displayName
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back",
														   style: .done,
														   target: self,
														   action: #selector(dismissSelf))
		navigationItem.leftBarButtonItem?.tintColor = .systemGray
		setupViews()
		tableViewInfo.reloadData()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		tableViewInfo.layoutIfNeeded()
	}

	@objc func dismissSelf() {
		dismiss(animated: true, completion: nil)
	}

	private func setupViews() {
		setingUpView(peer: self.userSent)
		settingUpTableData(peer: self.userSent)
//		rowsToDisplay = projectData.sorted(by: {$0.value > $1.value})
		tableViewInfo.dataSource = self
		tableViewInfo.delegate = self
		tableViewInfo.allowsSelection = false
		view.addSubview(tableViewInfo)
	}

	private func layoutTable() {
		tableViewInfo.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			tableViewInfo.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
			tableViewInfo.topAnchor.constraint(equalTo: self.view.topAnchor),
//			tableViewInfo.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16)
			tableViewInfo.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -32)
		])
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
//		layoutTable()

		tableViewInfo.frame = view.bounds
	}

	// MARK: - View Settings
	func setingUpView(peer: Peer) {
		tableViewInfo.register(CustomProjectTableViewCell.self,
							   forCellReuseIdentifier: CustomProjectTableViewCell.identifier)

		tableViewInfo.register(CustomProfileCell.self,
							   forCellReuseIdentifier: CustomProfileCell.identifier)
		tableViewInfo.register(CustomSkillTableViewCell.self,
							   forCellReuseIdentifier: CustomSkillTableViewCell.identifier)

	}

	func settingUpTableData(peer: Peer) {
		projectData = []
		skillData = []

		for project in peer.projectsAll where (project.cursusId.contains(21) || project.cursusId.contains(1)) && !project.project.slug.hasPrefix("piscine") && !project.project.slug.hasPrefix("rushes") {
			projectData.append(ProjectModel(fieldName: project.project.name, value: "\(project.finalMark ?? 0)", status: project.status))
		}
		projectData.sort(by: {$0.value > $1.value})

		for skill in peer.cursusAll[0].skills {
			skillData.append(SkillModel(fieldName: skill.name, value: String(format: "%.2f", skill.level)))
		}
		skillData.sort(by: {$0.value > $1.value})
	}

//	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//		view.layoutSubviews()
//		tableViewInfo.layoutSubviews()
//	}

}


extension PeerInformationViewController: UITableViewDataSource, UITableViewDelegate {

	func numberOfSections(in tableView: UITableView) -> Int {
		return 3
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return 1
		}
		if section == 1 {
			return self.projectData.count
		}
		return self.skillData.count
	}

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let returnedView = UIView()

		if tableView.numberOfRows(inSection: section) == 0 {
			return UIView()
		}
		let label = UILabel()
		label.textColor = .systemGray
		if section == 0 {
			label.text = "PROFILE"
		} else if section == 1 {
			label.text = "PROJECTS"
		} else {
			label.text = "SKILLS"
		}

		returnedView.addSubview(label)

		label.translatesAutoresizingMaskIntoConstraints = false

		label.centerXAnchor.constraint(equalTo: returnedView.centerXAnchor).isActive = true
		label.centerYAnchor.constraint(equalTo: returnedView.centerYAnchor).isActive = true

		return returnedView
	}

	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 36
	}


	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		if indexPath.section == 0 {
			guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomProfileCell.identifier,
														   for: indexPath) as? CustomProfileCell
			else {
				return UITableViewCell()
			}
			guard let data = try? Data(contentsOf: userSent.imageURL) else {
				if let img = UIImage(named: "ImgPlaceholder") {
					let level = userSent.cursusAll.first(where: { $0.cursus.name == "42cursus" } )?.level

					cell.configure(profileImage: img,
								   profileName: userSent.login,
								   wallet: "Wallet  \(userSent.wallet) ₳",
								   evaluationPoints: "Evaluation points  \(userSent.correctionPoint)",
								   level: userSent.cursusAll.first?.level ?? 0.0, who: level == 0 && userSent.poolYear == nil)
				}
				return cell
			}
			guard let img = UIImage(data: data) else { return cell }
			let level = userSent.cursusAll.first(where: { $0.cursus.name == "42cursus" } )?.level
			cell.configure(profileImage: img,
						   profileName: userSent.login,
						   wallet: "Wallet  \(userSent.wallet) ₳",
						   evaluationPoints: "Evaluation points  \(userSent.correctionPoint)",
						   level: level ?? 0.0,
						   who: level == 0 && userSent.poolYear == nil)
			return cell
		} else if indexPath.section == 1 {
			guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomProjectTableViewCell.identifier,
														   for: indexPath) as? CustomProjectTableViewCell
			else {
				return UITableViewCell()
			}
			cell.configure(projectName: projectData[indexPath.row].fieldName,
						   projectScore: projectData[indexPath.row].value,
						   projectStatus: projectData[indexPath.row].status)
			return cell
		} else {
			guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomSkillTableViewCell.identifier,
														   for: indexPath) as? CustomSkillTableViewCell
			else {
				return UITableViewCell()
			}
			cell.configure(skillName: self.skillData[indexPath.row].fieldName,
						   skillLevel: self.skillData[indexPath.row].value)
			return cell
		}
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.section == 0 {
			return CGFloat(288)
		} else {
			return CGFloat(48)
		}
	}


	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		let cornerRadius : CGFloat = 19.0
		cell.backgroundColor = UIColor.clear
		let layer: CAShapeLayer = CAShapeLayer()
		let pathRef: CGMutablePath = CGMutablePath()
		let bounds: CGRect = cell.bounds.insetBy(dx:0,dy:0)
		var addLine: Bool = false

		if (indexPath.row == 0 && indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1) {
			pathRef.addRoundedRect(in: bounds, cornerWidth: cornerRadius, cornerHeight: cornerRadius)
		} else if (indexPath.row == 0) {
			pathRef.move(to: CGPoint(x: bounds.minX, y: bounds.maxY))
			pathRef.addArc(tangent1End: CGPoint(x: bounds.minX, y: bounds.minY), tangent2End: CGPoint(x: bounds.midX, y: bounds.midY), radius: cornerRadius)
			pathRef.addArc(tangent1End: CGPoint(x: bounds.maxX, y: bounds.minY), tangent2End: CGPoint(x: bounds.maxX, y: bounds.midY), radius: cornerRadius)
			pathRef.addLine(to:CGPoint(x: bounds.maxX, y: bounds.maxY))
			addLine = true
		} else if (indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1) {
			pathRef.move(to: CGPoint(x: bounds.minX, y: bounds.minY), transform: CGAffineTransform())
			pathRef.addArc(tangent1End: CGPoint(x: bounds.minX, y: bounds.maxY), tangent2End: CGPoint(x: bounds.midX, y: bounds.maxY), radius: cornerRadius)
			pathRef.addArc(tangent1End: CGPoint(x: bounds.maxX, y: bounds.maxY), tangent2End: CGPoint(x: bounds.maxX, y: bounds.midY), radius: cornerRadius)
			pathRef.addLine(to:CGPoint(x: bounds.maxX, y: bounds.minY))
		} else {
			pathRef.addRect(bounds)

			addLine = true
		}

		layer.path = pathRef
		layer.fillColor = #colorLiteral(red: 0.7763349414, green: 0.7766209245, blue: 0.7720612884, alpha: 0.2683807791).cgColor

		if (addLine == true) {
			let lineLayer: CALayer = CALayer()
			let lineHeight: CGFloat = (1.0 / UIScreen.main.scale)
			lineLayer.frame = CGRect(x:bounds.minX + 10 , y:bounds.size.height-lineHeight, width:bounds.size.width-10, height:lineHeight)
			lineLayer.backgroundColor = tableView.separatorColor?.cgColor
			layer.addSublayer(lineLayer)
		}
		let testView: UIView = UIView(frame: bounds)
		testView.layer.insertSublayer(layer, at: 0)
		testView.backgroundColor = UIColor.clear
		cell.backgroundView = testView

	}
}

