////
////  OnboardingContent.swift
////  Melanoma Detector
////
////  Created by Murad Talibov on 30.09.22.
////
//
//import SwiftUI
//
//struct OnboardingContent: View {
//    var page: OnboardingPage
//    
//    var body: some View {
//        VStack {
//            HStack {
//                Text(pageText(page))
//                    .font(.custom("SourceSansPro-Bold" ,size: 36))
//                    .multilineTextAlignment(.leading)
//                .padding(20)
//                Spacer()
//            }
//            Spacer()
//            Image(pageImage(page))
//                .resizable()
//                .frame(width: 300, height: 300)
//            Spacer()
//            
//        }
//    }
//    
//    var pageImage = { (page: OnboardingPage) -> String in
//        switch page {
//        case .welcome:
//            return "OnboardingWelcome"
//        case .photo:
//            return "OnboardingPhoto"
////        case .detection:
////            return "OnboardingDetection"
//        case .finish:
//            return "OnboardingFinish"
//        }
//    }
//    
//    var pageText = { (page: OnboardingPage) -> String in
//        switch page {
//        case .welcome:
//            return "What kind of food do you like?"
//        case .photo:
//            return "Capture or upload a photo of patient's skin"
//        case .detection:
//            return "Get instant results about the probability of melanoma"
//        case .finish:
//            return "Get started right away"
//        }
//    }
//}
//
//struct OnboardingContent_Previews: PreviewProvider {
//    static var previews: some View {
//        OnboardingContent(page: .welcome)
//    }
//}
