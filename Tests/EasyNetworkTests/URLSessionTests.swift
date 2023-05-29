//
//  File.swift
//  
//
//  Created by Dmytro Lehkyi on 29.05.2023.
//

import Foundation
import XCTest
@testable import EasyNetwork

private let kPath = "example"
private let kBaseURL = URL(string: "http://example.com/")!
private let kMockedURL = URL(string: "http://example.com/\(kPath)")!

class URLSessionTests: XCTestCase {
	override func setUp() {
		super.setUp()
		URLProtocol.registerClass(MockedURLProtocol.self)
	}

	override func tearDown() {
		super.tearDown()
		URLProtocol.unregisterClass(MockedURLProtocol.self)
	}

	func testLoadWithSuccessfulResult() {
		let sut = makeSUT()
		MockedURLProtocol.mockResponse(data: Books.json.data(using: .utf8)!, statusCode: 200, for: kMockedURL)
		let endpoint = Endpoint(baseURL: kBaseURL, path: kPath)
		
		let expectation = self.expectation(description: "Stubbed network call")

		sut.load(endpoint, responseType: [Book].self) { result in
			switch result {
			case .success(let books):
				XCTAssertEqual(books, Books.expected)
			case .failure(let error):
				XCTFail("Unexpected error: \(error)")
			}
			expectation.fulfill()
		}
		
		wait(for: [expectation], timeout: 1)
	}

	func testLoadWith500StatusCode() {
		let sut = makeSUT()
		MockedURLProtocol.mockResponse(data: Books.json.data(using: .utf8)!, statusCode: 500, for: kMockedURL)
		let endpoint = Endpoint(baseURL: kBaseURL, path: kPath)
		
		let expectation = self.expectation(description: "Stubbed network call")

		sut.load(endpoint, responseType: [Book].self) { result in
			switch result {
			case .success:
				XCTFail("Expected to return error. Returned success")
			case .failure(let error):
				do {
					let networkError = try XCTUnwrap(error as? EasyNetworkError)
					XCTAssertEqual(networkError.statusCode, 500)
				} catch {
					XCTFail(error.localizedDescription)
				}
			}
			expectation.fulfill()
		}
		
		wait(for: [expectation], timeout: 1)
	}
	
	private func makeSUT() -> URLSession {
		let configuration = URLSessionConfiguration.default
		configuration.protocolClasses?.insert(MockedURLProtocol.self, at: 0)
		return URLSession(configuration: configuration)
	}
}

private extension EasyNetworkError {
	var statusCode: Int? {
		switch self {
			case .badStatusCode(let code):
				return code
			default:
				return nil
		}
	}
}
