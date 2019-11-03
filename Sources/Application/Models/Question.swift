//
//  Question.swift
//  Application
//
//  Created by kant on 04/11/2019.
//

import Foundation
import SwiftKueryORM

struct Question: Codable, Model {
	var id: Int?
	var text: String?
	var type: Int?
}
