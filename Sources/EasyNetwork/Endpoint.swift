//
//  Endpoint.swift
//  EasyNetwork
//
//  Created by Dmytro Lehkyi on 05.01.2022.
//

import Foundation

public struct Endpoint {
	let baseURL: URL
	let path: String
	let method: HTTPMethod
	let body: Data?
	let queryItems: [URLQueryItem]
	let headers: [HTTPHeader]
	let expectedStatusCode: (Int) -> Bool
	
	public static func expected200to300(_ code: Int) -> Bool {
		return code >= 200 && code < 300
	}

	public init(
		baseURL: URL,
		path: String,
		method: HTTPMethod = .get,
		body: Data? = nil,
		queryItems: [URLQueryItem] = [],
		headers: [HTTPHeader] = [],
		expectedStatusCode: @escaping (Int) -> Bool = Self.expected200to300
	) {
		self.baseURL = baseURL
		self.path = path
		self.method = method
		self.body = body
		self.queryItems = queryItems
		self.headers = headers
		self.expectedStatusCode = expectedStatusCode
	}
	
	public init(
		path: String,
		method: HTTPMethod = .get,
		body: Data? = nil,
		queryItems: [URLQueryItem] = [],
		headers: [HTTPHeader] = [],
		expectedStatusCode: @escaping (Int) -> Bool = Self.expected200to300
	) {
		self.init(baseURL: EasyNetwork.baseURL, path: path, method: method, body: body,
				  queryItems: queryItems, headers: headers, expectedStatusCode: expectedStatusCode)
	}
}

extension URLRequest {
	init(endpoint: Endpoint) throws {
		var components = URLComponents(url: endpoint.baseURL.appendingPathComponent(endpoint.path),
									   resolvingAgainstBaseURL: false)
		components?.queryItems = endpoint.queryItems.isEmpty ? nil : endpoint.queryItems

		guard let url = components?.url else {
			throw URLError(.badURL)
		}
		
		self.init(url: url)
		self.httpMethod = endpoint.method.rawValue
		self.httpBody = endpoint.body
		
		for header in endpoint.headers {
			self.setValue(header.key, forHTTPHeaderField: header.value)
		}
	}
}
