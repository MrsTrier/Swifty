//
//  SceneDelegate.swift
//  Swifty
//
//  Created by Darya on 08.06.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
			   options connectionOptions: UIScene.ConnectionOptions) {

		guard let windowScene = (scene as? UIWindowScene) else { return }

		/// 2. Create a new UIWindow using the windowScene constructor which takes in a window scene.
		let window = UIWindow(windowScene: windowScene)
		let searchViewController = SearchViewController()

		window.rootViewController = searchViewController
		self.window = window

		window.makeKeyAndVisible()

	}


}
