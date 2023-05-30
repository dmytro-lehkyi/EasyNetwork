//
//  Resource.swift
//  EasyNetwork
//
//  Created by Dmytro Lehkyi on 30.05.2023.
//

import Foundation

public struct Resource<T: Decodable> {
	let endpoint: Endpoint

	init(endpoint: Endpoint) {
		self.endpoint = endpoint
	}
}
