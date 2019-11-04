//
//  InitializationError.swift
//  Application
//
//  Created by kant on 04/11/2019.
//

import Foundation

public struct InitializationError: LocalizedError {
	
	// MARK: - Private properties
	
    private let message: String
	
	// MARK: - Lifecycle
	
    init(_ msg: String) {
        message = msg
    }
	
	// MARK: - LocalizedError implementation
	
	public var errorDescription: String? {
        return message
    }
}
