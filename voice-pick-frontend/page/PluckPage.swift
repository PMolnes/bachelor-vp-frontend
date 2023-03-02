//  A wrapper page responsible for maintaining controller
//  over which pluck page to display
//
//  PluckPage.swift
//  voice-pick-frontend
//
//  Created by Joakim Edvardsen on 16/02/2023.
//

import SwiftUI

struct PluckPage: View {
    
    enum PluckPages {
        case LOBBY
        case INFO
        case LIST_VIEW
        case SINGLE_VIEW
        case COMPLETE
        case DELIVERY
    }
    
    @State var activePage: PluckPages = .LOBBY
    @State var pluckList: PluckList?
    
    /// Initialized the pluck list
    ///
    /// - Parameters:
    ///     - pluckList: A pluckList object containing information about the pluck list
    func initializePluckList(pluckList: PluckList) {
        self.pluckList = pluckList
    }
    
    /// Updates the active page
    ///
    /// - Parameters:
    ///     - page: The page to update to
    func updateActivePage(page: PluckPages) {
        withAnimation {
            self.activePage = page
        }
    }
    
    var body: some View {
        switch activePage {
        case .LOBBY:
            PluckLobby(next: {
                updateActivePage(page: .INFO)
            }, initPluckList:
                initializePluckList
            )
            .transition(.backslide)
        case .INFO:
            PluckInfo(pluckList: pluckList ?? .init(id: 0, route: "N/A", destination: "N/A", plucks: []), next: {
                updateActivePage(page: .LIST_VIEW)
            })
            .transition(.backslide)
        case .LIST_VIEW:
            PluckListDisplay(pluckList?.plucks ?? [], next: {
                updateActivePage(page: .COMPLETE)
            })
            .transition(.backslide)
        case .SINGLE_VIEW:
            Text("Single view")
            .transition(.backslide)
        case .COMPLETE:
            PluckComplete(next: {
                updateActivePage(page: .DELIVERY)
            })
            .transition(.backslide)
        case .DELIVERY:
            PluckFinish(next: {
                updateActivePage(page: .LOBBY)
            })
            .transition(.backslide)
        }
    }
}

struct PluckPage_Previews: PreviewProvider {
    static var previews: some View {
        PluckPage()
    }
}
