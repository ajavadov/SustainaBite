//
//  ImageView.swift
//  HelloFresh
//
//  Created by Murad Talibov on 18.11.23.
//

import SwiftUI

// MARK: ImageView
/// View for displaying `Book` thumbnails.
struct ImageView: View {
    /// URL of the image to be displayed
    @State var imageURL: URL?
    
    var body: some View {
        if let imageURL = imageURL {
            CachedAsyncImage(url: imageURL) { phase in
                if case .success(let image) = phase {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 250, height: 250)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                } else if case .failure(_) = phase {
                    Image("food_placeholder")
                        .resizable()
                        .cornerRadius(10)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 250, height: 200)
                } else {
                    ProgressView()
                        .onAppear {
                            self.imageURL = nil
                            self.imageURL = imageURL
                        }
                }
            }
        } else {
            Image("food_placeholder")
                .resizable()
                .cornerRadius(10)
                .aspectRatio(contentMode: .fill)
                .frame(width: 250, height: 200)
        }
    }
}

#Preview {
    ImageView(imageURL: .init(string: "https://www.cookedandloved.com/wp-content/uploads/2020/05/harissa-chicken-quinoa-salad-1.jpg"))
}
