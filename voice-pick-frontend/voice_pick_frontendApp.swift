//
//  voice_pick_frontendApp.swift
//  voice-pick-frontend
//
//  Created by Petter Molnes on 10/02/2023.
//

import SwiftUI

@main
struct voice_pick_frontendApp: App {
    
    @StateObject private var authService = AuthenticationService()
    @StateObject private var voiceService = VoiceService()
    @StateObject private var pluckService = PluckService()
    
	var body: some Scene {
		WindowGroup {
			ContentView()
                .environmentObject(authService)
                .environmentObject(voiceService)
                .environmentObject(pluckService)
		}
	}
}
