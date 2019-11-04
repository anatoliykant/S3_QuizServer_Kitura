//
//  URLRequest + Test request methods.swift
//  Application
//
//  Created by kant on 04/11/2019.
//

import XCTest
import KituraNet

extension URLRequest {

	init?(forTestWithMethod method: String, route: String = "", body: Data? = nil) {
		let port = RouteTests.port ?? 8080
		if let url = URL(string: "http://127.0.0.1:\(port)/" + route){
			self.init(url: url)
			addValue("application/json", forHTTPHeaderField: "Content-Type")
			httpMethod = method
			cachePolicy = .reloadIgnoringCacheData
			if let body = body {
				httpBody = body
			}
		} else {
			XCTFail("URL is nil...")
			return nil
		}
	}

	func sendForTestingWithKitura(fn: @escaping (Data, Int) -> Void) {

		guard let method = httpMethod, var path = url?.path, let headers = allHTTPHeaderFields else {
			XCTFail("Invalid request params")
			return
		}

		if let query = url?.query {
			path += "?" + query
		}

		let requestOptions: [ClientRequest.Options] = [.method(method), .hostname("localhost"), .port(8080), .path(path), .headers(headers)]

		let req = HTTP.request(requestOptions) { resp in

			if let resp = resp, resp.statusCode == HTTPStatusCode.OK || resp.statusCode == HTTPStatusCode.accepted {
				do {
					var body = Data()
					try resp.readAllData(into: &body)
					fn(body, resp.statusCode.rawValue)
				} catch {
					print("Bad JSON document received from Kitura-Starter.")
				}
			} else {
				if let resp = resp {
					print("Status code: \(resp.statusCode)")
					var rawUserData = Data()
					do {
						let _ = try resp.read(into: &rawUserData)
						let str = String(data: rawUserData, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
						print("Error response from Kitura-Starter: \(String(describing: str))")
					} catch {
						print("Failed to read response data.")
					}
				}
			}
		}
		if let dataBody = httpBody {
			req.end(dataBody)
		} else {
			req.end()
		}
	}
}
