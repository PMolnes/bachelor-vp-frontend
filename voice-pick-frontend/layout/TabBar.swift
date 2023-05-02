//
//  TabBar.swift
//  voice-pick-frontend
//
//  Created by Håkon Sætre on 16/02/2023.
//

import SwiftUI

struct TabBar: View {
        
	var body: some View {
		TabView {
			PluckPage()
				.tabItem {
					Label("Meny", systemImage: "house")
				}
            VoiceChatPage()
                .tabItem {
                    Label("Logg", systemImage: "clock.fill")
                }
			WarehouseConfigurationPage()
				.tabItem {
					Label("Konfigurer varehus", systemImage: "slider.horizontal.3")
					Label("Legg til produkt", systemImage: "plus.app.fill")
				}
			AccountPage()
				.tabItem {
					Label("Profil", systemImage: "person")
				}
		}
	}
}

struct TabBar_Previews: PreviewProvider {
	static var previews: some View {
		TabBar()
	}
}
