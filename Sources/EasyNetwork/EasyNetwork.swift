 //
//  EasyNetwork.swift
//  EasyNetwork
//
//  Created by Dmytro Lehkyi on 29.05.2023.
//

import Foundation

public struct EasyNetwork {
	static var baseURL: URL!
	
	public static func setBaseURL(_ url: URL) {
		Self.baseURL = url
	}
}
