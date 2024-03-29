//
//  HealthRoutes.swift
//  Application
//
//  Created by kant on 04/11/2019.
//

import Health
import KituraContracts

func initializeHealthRoutes(app: App) {
	
	// MARK: - Dependencies
	
	let health = Health()
	
	// MARK: - Public methods
	
	// MARK: GET handler
	
	app.router.get("/health") { (respondWith: (Status?, RequestError?) -> Void) -> Void in
		if health.status.state == .UP {
			respondWith(health.status, nil)
		} else {
			respondWith(nil, RequestError(.serviceUnavailable, body: health.status))
		}
	}
}
