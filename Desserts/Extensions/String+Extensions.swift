//
//  String+Extensions.swift
//  DessertsChallenge
//
//  Created by Ismail Elmaliki on 4/13/23.
//

import Foundation

extension String {
	
	/// Format instructions into a user-readable format.
	///
	/// The backend returns instructions text with "\r\n" to separate steps. On the mobile side, instructions will need to be separated into an array without including the "\r\n" characters.
	func formatInstructions() -> [String] {
		self
			.replacingOccurrences(of: "\r", with: "")
			.components(separatedBy: "\n")
			.compactMap { instruction in
				if instruction.isEmpty {
					return nil
				}
				
				return instruction
			}
	}
}
