//
//  HTTPMethod.swift
//  EasyNetwork
//
//  Created by Dmytro Lehkyi on 05.01.2022.
//

import Foundation

public struct HTTPMethod {
	public static let get = HTTPMethod(rawValue: "GET")
	public static let post = HTTPMethod(rawValue: "POST")
	public static let put = HTTPMethod(rawValue: "PUT")
	public static let delete = HTTPMethod(rawValue: "DELETE")
	
	let rawValue: String
}
