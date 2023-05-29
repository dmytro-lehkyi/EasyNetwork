//
//  HTTPClient.swift
//  EasyNetwork
//
//  Created by Dmytro Lehkyi on 05.01.2022.
//

import Foundation

public protocol HTTPClient {
	func data(for endpoint: Endpoint) async throws -> Data
	func data(for endpoint: Endpoint, completion: @escaping (Result<Data, Error>) -> Void)
}

extension HTTPClient {
	func load<T: Decodable>(_ endpoint: Endpoint, responseType: T.Type = T.self) async throws -> T {
		let data = try await self.data(for: endpoint)
		return try JSONDecoder().decode(responseType, from: data)
	}
	
	func load<T: Decodable>(_ endpoint: Endpoint,
							responseType: T.Type = T.self,
							completion: @escaping (Result<T, Error>) -> Void) {
		self.data(for: endpoint) { result in
			switch result {
			case .success(let data):
				do {
					completion(.success(try JSONDecoder().decode(responseType, from: data)))
				} catch {
					completion(.failure(error))
				}
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
}
