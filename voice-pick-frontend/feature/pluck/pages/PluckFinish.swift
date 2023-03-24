//
//  PluckFinish.swift
//  voice-pick-frontend
//
//  Created by Håkon Sætre on 20/02/2023.
//

import SwiftUI

struct PluckFinish: View {
	
	
	@State private var selectedNumber: Int?
	
    let next: () -> Void
	
	@EnvironmentObject var pluckService: PluckPageService
	
	@State private var isAnswerSelected = false
    
    private func completePluck() {
        // Send API request to complete pluck
        next()
    }
	
	var body: some View {
		VStack {
			Card(){
				VStack (alignment: .leading){
					HStack {
						Title("Fullfør plukk")
						Spacer()
					}
					.padding(.bottom)
					Paragraph("Plukker")
					
					Paragraph(pluckService.pluckList?.user.firstName ?? "Username")
						.bold()
						.padding(.bottom)
					Paragraph("Leverings lokasjon")
					Paragraph(pluckService.pluckList!.location.name)
						.bold()
						.padding(.bottom)
					if(!isAnswerSelected){
						Divider()
							.padding(.bottom)
						ButtonRandomizer(correctAnswer: correctAnswer!, onCorrectAnswerSelected: { number in print(number)})
					}
				}
			}
			
			VStack (spacing: 5) {
				Spacer()
				Paragraph("Før avlevering:")
					.bold()
				Paragraph("Pakk pallen inn i plast")
				Paragraph("Sett på lapper på alle sider")
				Spacer()
				DefaultButton("Fullfør", disabled: selectedNumber != pluckService.pluckList?.location.controlDigit){
					completePluck()
				}
			}
		}
		.padding(10)
	}
}

struct PluckFinish_Previews: PreviewProvider {
	static var previews: some View {
        PluckFinish(next: {
            print("next")
        })
				.environmentObject(PluckPageService())
	}
}
