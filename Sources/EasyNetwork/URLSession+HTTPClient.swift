//
//  URLSession+HTTPClient.swift
//  EasyNetwork
//
//  Created by Dmytro Lehkyi on 05.01.2022.
//

import Foundation

extension URLSession: HTTPClient {
	public func data(for endpoint: Endpoint) async throws -> Data {
		let urlRequest = try URLRequest(endpoint: endpoint)
		let (data, response) = try await self.data(for: urlRequest)

		guard let statusCode = response.responseStatusCode, endpoint.expectedStatusCode(statusCode) else {
			throw URLError(.badServerResponse)
		}
		  
		return data
	}
	
	public func data(for endpoint: Endpoint, completion: @escaping (Result<Data, Error>) -> Void) {
		guard let urlRequest = try? URLRequest(endpoint: endpoint) else {
			completion(.failure(EasyNetworkError.badURL))
			return
		}
		
		self.dataTask(with: urlRequest) { data, response, error in
			guard let data else {
				completion(.failure(EasyNetworkError.noData))
				return
			}
			
			if let error {
				completion(.failure(error))
			} else if let statusCode = response?.responseStatusCode, !endpoint.expectedStatusCode(statusCode) {
				completion(.failure(EasyNetworkError.badStatusCode(statusCode)))
			} else {
				completion(.success(data))
			}
		}.resume()
	}
}

private extension URLResponse {
	var responseStatusCode: Int? {
		(self as? HTTPURLResponse)?.statusCode
	}
}
