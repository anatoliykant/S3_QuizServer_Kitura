//
//  Answer.swift
//  Application
//
//  Created by kant on 04/11/2019.
//

import Foundation
import SwiftKueryORM

struct Answer: Codable, Model {
	var id: Int?
	var text: String?
	var type: Int?
	var questionId: Int?
}
