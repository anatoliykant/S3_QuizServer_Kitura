//
//  Persistence.swift
//  Application
//
//  Created by kant on 04/11/2019.
//

import SwiftKueryORM
import SwiftKueryPostgreSQL

class Persistence {
	static func setUp() {
		let pool = PostgreSQLConnection.createPool(
			host: "localhost",
			port: 5432,
			options: [.databaseName("quizdb")],
			poolOptions: ConnectionPoolOptions(initialCapacity: 10, maxCapacity: 50)
		)
		Database.default = Database(pool)
	}
}
