//
//  ResponseType.swift
//  Application
//
//  Created by kant on 04/11/2019.
//

import Foundation
import SwiftKueryORM

enum ResponseType: Int, Codable, Model {
	case single = 1
	case multiple
	case ranged
}
