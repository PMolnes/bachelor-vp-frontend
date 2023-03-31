//
//  VerificaitonPage.swift
//  voice-pick-frontend
//
//  Created by Håkon Sætre on 15/02/2023.
//

import SwiftUI

struct VerificaitonPage: View {
	var buttonText = "Resend Email"
	
	@EnvironmentObject var authenticationService: AuthenticationService
	
	let requestService = RequestService()
	
	
	
	var body: some View {
		VStack{
			ZStack{
				Image("Tracefavicon")
					.resizable()
					.frame(width: 120, height: 120)
					.opacity(0.05)
				VStack (spacing: -20){
					Text("TRACE").font(.guidelineHeading).foregroundColor(.traceLightYellow)
					Text("Voice pick").font(.header1).foregroundColor(.foregroundColor)
				}
			}
			Spacer()
			Group {
				Text("An email verification code has been sent to your email")
					.font(.header2)
					.foregroundColor(.foregroundColor)
					.multilineTextAlignment(.center)
				DefaultInput(inputLabel: "Verify Email", isPassword: false, text: .constant(""), valid: true)
			}
			.padding(40)
			Spacer()
			Footer()
		}
		.padding(20)
		.background(Color.backgroundColor)
		.onAppear{
			requestService.post(path: "/auth/verify-email", body: authenticationService.userEmail, responseType: String.self, completion: { result in
					print(result)
			})
		}
	}
	
}

struct VerificaitonPage_Previews: PreviewProvider {
	static var previews: some View {
		VerificaitonPage()
	}
}
