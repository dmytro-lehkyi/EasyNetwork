//
//  File.swift
//  
//
//  Created by Dmytro Lehkyi on 29.05.2023.
//

import Foundation

struct Book: Codable, Equatable {
	let author: String
	let title: String
}

enum Books {
	static var json: String {
		"""
		[
		  {
			  "author": "Stephen King",
			  "title": "It",
		  },
		  {
			  "author": "Isaac Asimov",
			  "title": "I, Robot",
		  }
		]
		"""
	}
	
	static var expected: [Book] {
		[.init(author: "Stephen King", title: "It"), .init(author: "Isaac Asimov", title: "I, Robot")]
	}
}
