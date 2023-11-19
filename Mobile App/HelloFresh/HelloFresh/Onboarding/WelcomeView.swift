//
//  WelcomeView.swift
//  HelloFresh
//
//  Created by Murad Talibov on 18.11.23.
//

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var model: Model
    
    var body: some View {
        ZStack {
            Color("OnboardingGreen")
                .ignoresSafeArea()
            VStack {
                HStack {
                    Text("Welcome\n\(model.user?.name ?? "")")
                        .font(.custom("SourceSansPro-Bold", size: 34))
                        .padding(.top, 20)
                        .padding(.leading, 20)
                    Spacer()
                }
                Spacer()
                Image("sustainabite")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 400)
                Spacer()
                Text("Prepare your cookbox customly tailored for you!")
                    .multilineTextAlignment(.center)
                    .font(.custom("SourceSansPro-Light", size: 22))
                    .padding(.horizontal, 30)
                Spacer()
            }
            
        }
    }
}

#Preview {
    WelcomeView()
        .environmentObject(Model())
}
