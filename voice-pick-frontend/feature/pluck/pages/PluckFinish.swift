//
//  PluckFinish.swift
//  voice-pick-frontend
//
//  Created by Håkon Sætre on 20/02/2023.
//

import SwiftUI

struct PluckFinish: View {
	
	@EnvironmentObject var pluckService: PluckService
	
	private func completePluck() {
		pluckService.doAction(keyword: "complete", fromVoice: false)
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
					Paragraph(pluckService.pluckList?.user.firstName ?? "N/A")
						.bold()
						.padding(.bottom)
					Paragraph("Leverings lokasjon")
					Paragraph(pluckService.pluckList!.location.code)
						.bold()
						.padding(.bottom)
					if (pluckService.pluckList?.confirmedAt == nil) {
						Divider()
							.padding(.bottom)
						ButtonRandomizer(
							correctAnswer: pluckService.pluckList?.location.controlDigits ?? 0,
							onCorrectAnswerSelected: { number in
								pluckService.doAction(keyword: String(number), fromVoice: false)
						},
							disableButtons: false)
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
				DefaultButton("Fullfør", disabled: pluckService.pluckList?.confirmedAt == nil) {
					completePluck()
				}
			}
		}
		.padding(UIView.defaultPadding)
	}
}

struct PluckFinish_Previews: PreviewProvider {
	static var previews: some View {
		PluckFinish()
		.environmentObject(PluckService())
	}
}
