//
//  EasyNetworkError.swift
//  MacOSLab
//
//  Created by Dmytro Lehkyi on 29.05.2023.
//

import Foundation

public enum EasyNetworkError: Error {
	case noData
	case badStatusCode(Int)
	case badURL
}
