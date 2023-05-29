//
//  HTTPHeader.swift
//  EasyNetwork
//
//  Created by Dmytro Lehkyi on 05.01.2022.
//

import Foundation

public enum ContentType: String {
	case json = "application/json"
	case xml = "application/xml"
}

public struct HTTPHeader {
	let key: String
	let value: String
	
	public init(key: String, value: String) {
		self.key = key
		self.value = value
	}
	
	public static func contentType(_ value: ContentType) -> HTTPHeader {
		HTTPHeader(key: "Content-Type", value: value.rawValue)
	}

	public static func accept(_ value: ContentType) -> HTTPHeader {
		HTTPHeader(key: "Accept", value: value.rawValue)
	}
}
