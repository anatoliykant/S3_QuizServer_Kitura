//
//  RouteTests.swift
//  Application
//
//  Created by kant on 04/11/2019.
//

import Foundation
import Kitura
import KituraNet
import XCTest
import HeliumLogger

@testable import Application

class RouteTests: XCTestCase {
	static var port: Int!
	static var allTests : [(String, (RouteTests) -> () throws -> Void)] {
		return [
			("testGetStatic", testGetStatic)
		]
	}
	
	override func setUp() {
		super.setUp()
		
		HeliumLogger.use()
		do {
			print("------------------------------")
			print("------------New Test----------")
			print("------------------------------")
			
			let app = try App()
			RouteTests.port = app.cloudEnv.port
			try app.postInit()
			Kitura.addHTTPServer(onPort: RouteTests.port, with: app.router)
			Kitura.start()
		} catch {
			XCTFail("Couldn't start Application test server: \(error)")
		}
	}
	
	override func tearDown() {
		Kitura.stop()
		super.tearDown()
	}
	
	func testGetStatic() {
		
		let printExpectation = expectation(description: "The /route will serve static HTML content.")
		
		URLRequest(forTestWithMethod: "GET")?
			.sendForTestingWithKitura { data, statusCode in
				if let getResult = String(data: data, encoding: String.Encoding.utf8){
					XCTAssertEqual(statusCode, 200)
					XCTAssertTrue(getResult.contains("<html"))
					XCTAssertTrue(getResult.contains("</html>"))
				} else {
					XCTFail("Return value from / was nil!")
				}
				
				printExpectation.fulfill()
		}
		
		waitForExpectations(timeout: 10.0, handler: nil)
	}
	
	func testHealthRoute() {
		let printExpectation = expectation(description: "The /health route will print UP, followed by a timestamp.")
		
		URLRequest(forTestWithMethod: "GET", route: "health")?
			.sendForTestingWithKitura { data, statusCode in
				if let getResult = String(data: data, encoding: String.Encoding.utf8) {
					XCTAssertEqual(statusCode, 200)
					XCTAssertTrue(getResult.contains("UP"), "UP not found in the result.")
					let date = Date()
					let calendar = Calendar.current
					let yearString = String(describing: calendar.component(.year, from: date))
					XCTAssertTrue(getResult.contains(yearString), "Failed to create String from date. Date is either missing or incorrect.")
				} else {
					XCTFail("Unable to convert request Data to String.")
				}
				printExpectation.fulfill()
		}
		waitForExpectations(timeout: 10.0, handler: nil)
	}
}
