//
//  File.swift
//  
//
//  Created by Dmytro Lehkyi on 29.05.2023.
//

import Foundation
import XCTest

struct MockedResponse {
	let response: HTTPURLResponse
	let data: Data
}

final class MockedURLProtocol: URLProtocol {
	private static var responses: [URL: MockedResponse] = [:]
	
	override class func canInit(with request: URLRequest) -> Bool {
		return true
	}
	
	override class func canonicalRequest(for request: URLRequest) -> URLRequest {
		return request
	}
	
	override func startLoading() {
		guard let client, let url = request.url, let mockedResponse = Self.responses[url] else {
			return
		}
		
		client.urlProtocol(self, didReceive: mockedResponse.response, cacheStoragePolicy: .notAllowed)
		client.urlProtocol(self, didLoad: mockedResponse.data)
		client.urlProtocolDidFinishLoading(self)
	}
	
	override func stopLoading() {
	}
	
	static func mockResponse(data: Data, statusCode: Int, for url: URL) {
		let response = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
		self.responses[url] = MockedResponse(response: response, data: data)
	}
}
