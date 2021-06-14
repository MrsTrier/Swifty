//
//  PeerInformationViewController.swift
//  Swifty
//
//  Created by Darya on 08.06.2021.
//

import UIKit

struct ProjectModel {
	let fieldName: String
	let value: Int
	let status: String
}

struct SkillModel {
	let fieldName: String
	let value: Float
//	let status: String
}

class PeerInformationViewController: UIViewController {

	var userSent: Peer
	lazy var projectData : [ProjectModel] = []
	lazy var skillData : [SkillModel] = []

	var tableViewInfo = UITableView(frame: .zero, style: .insetGrouped)

	init(userSent: Peer) {
		self.userSent = userSent
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.title = userSent.displayName
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back",
														   style: .done,
														   target: self,
														   action: #selector(dismissSelf))
		navigationItem.leftBarButtonItem?.tintColor = .systemGray
		setupViews()
		layoutTable()
	}

	@objc func dismissSelf() {
		dismiss(animated: true, completion: nil)
	}

	private func setupViews() {
		setingUpView(peer: self.userSent)
		settingUpTableData(peer: self.userSent)
		tableViewInfo.dataSource = self
		tableViewInfo.delegate = self
		tableViewInfo.allowsSelection = false
	}

	private func layoutTable() {
		view.addSubview(tableViewInfo)
		tableViewInfo.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			tableViewInfo.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tableViewInfo.topAnchor.constraint(equalTo: view.topAnchor),
			tableViewInfo.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			tableViewInfo.trailingAnchor.constraint(equalTo: view.trailingAnchor)
		])
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
			projectData.append(ProjectModel(fieldName: project.project.name, value: project.finalMark ?? 0, status: project.status))
		}
		projectData.sort(by: {$0.value > $1.value})
		for skill in peer.cursusAll[0].skills {
			skillData.append(SkillModel(fieldName: skill.name, value: skill.level))
		}
		skillData.sort(by: {$0.value > $1.value})
	}
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
		label.font = UIFont(name: "AvenirNext-Regular", size: 20)
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
								   level: userSent.cursusAll.first?.level ?? 0.0,
								   who: level == 0 && userSent.poolYear == nil)
				}
				return cell
			}
			guard let img = UIImage(data: data) else { return cell }
			let level = userSent.cursusAll.first(where: { $0.cursus.name == "42cursus" } )?.level
			cell.configure(profileImage: img,
						   profileName: userSent.login,
						   wallet: "Wallet  \(userSent.wallet) ₳",
						   evaluationPoints: "EP's  \(userSent.correctionPoint)",
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
						   projectScore: "\(projectData[indexPath.row].value)",
						   projectStatus: projectData[indexPath.row].status)
			return cell
		} else {
			guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomSkillTableViewCell.identifier,
														   for: indexPath) as? CustomSkillTableViewCell
			else {
				return UITableViewCell()
			}
			cell.configure(skillName: self.skillData[indexPath.row].fieldName,
						   skillLevel: String(format: "%.2f", self.skillData[indexPath.row].value))
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
}
