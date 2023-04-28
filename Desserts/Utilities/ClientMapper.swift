//
//  ClientMapper.swift
//  Desserts
//
//  Created by Ismail Elmaliki on 4/28/23.
//

import Foundation

class ClientMapper {
	static func decode<T: Codable>(_ data: Data) throws -> T {
		let decoder = JSONDecoder()
		let formattedData = try decoder.decode(T.self, from: data)
		return formattedData
	}
}
