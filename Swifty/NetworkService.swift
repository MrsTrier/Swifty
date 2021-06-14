//
//  NetworkService.swift
//  Swifty
//
//  Created by Darya on 08.06.2021.
//

import Foundation

struct IntraAccess: Decodable {
	var token: String

	enum CodingKeys : String, CodingKey {
		case token = "access_token"
	}
}

class NetworkService {

	private init() {}
	static let shared = NetworkService()
	private let intraURL = "https://api.intra.42.fr"
	private let getToken = "/oauth/token"
	private let getUser = "/v2/users/"
	private let getCoalition = "/v2/coalitions_users/:id"
	private let UID = "674b91c167889c0d801623c988bb51f7be4c785d9486b26f5956c9f4a100329f"
	private let secretKey = "861d9c5af9c0359ffb05685c9c080e82e35353fa4deb3b6e0cd774953b2d546c"
	private let callback = "com.swiftyCompanion://mcanhand"
	private var token = ""


	func getData(peerName: String, completion: @escaping (Peer?, Error?) -> Void) {

		guard !token.isEmpty else { return }
		guard let url = URL(string: intraURL + getUser + peerName) else { return }
		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")

		decode(request: request, model: Peer.self) { (peer, error) in
			guard let peer = peer else {
				completion(nil, error)
				return
			}
			completion(peer, nil)
		}
	}

	func postRequestToken(completion: @escaping (String?) -> ()) {

		guard let url = URL(string: intraURL + getToken) else { return }

		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		let postString = "grant_type=client_credentials&client_id=\(UID)&client_secret=\(secretKey)"
		request.httpBody = postString.data(using: String.Encoding.utf8)

		decode(request: request, model: IntraAccess.self) { (data, error) in
			guard let getToken = data else {
				completion(nil)
				return
			}
			self.token = getToken.token
			completion("success")
		}
	}

	func decode<T>(request: URLRequest, model: T.Type,  completion: @escaping (T?, Error?) -> Void) where T : Decodable {

			URLSession.shared.dataTask(with: request) { (data, response, error) in

				DispatchQueue.main.async {
					guard let data = data else {
						completion(nil, error)
						return
					}
//					guard error == nil else { return }

					do {
						let result = try JSONDecoder().decode(T.self, from: data)
						completion(result, nil)
					}
					catch let error {
						completion(nil, error)
					}
				}
			}.resume()
	}

}
