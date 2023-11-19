//
//  CachedAsyncImage.swift
//  HelloFresh
//
//  Created by Murad Talibov on 18.11.23.
//

import SwiftUI

// MARK: CachedAsyncImage
/// Wrapper view for `AsyncImage` that adds in-memory caching functionality.
struct CachedAsyncImage<Content>: View where Content: View {
    /// The URL of the image to display.
    private let url: URL
    /// The scale to use for the image.
    private let scale: CGFloat
    /// The transaction to use when the phase changes.
    private let transaction: Transaction
    /// A closure that takes the load phase as an input, and
    /// returns the view to display for the specified phase
    private let content: (AsyncImagePhase) -> Content
    
    @State private var hasFailedToLoad: Bool = false
    
    /// - Parameters:
    ///   - url: The URL of the image to display
    ///   - scale: The scale to use for the image. The default is `1`. Set a
    ///     different value when loading images designed for higher resolution
    ///     displays. For example, set a value of `2` for an image that you
    ///     would name with the `@2x` suffix if stored in a file on disk
    ///   - transaction: The transaction to use when the phase changes
    ///   - content: A closure that takes the load phase as an input, and
    ///     returns the view to display for the specified phase
    init(
        url: URL,
        scale: CGFloat = 1.0,
        transaction: Transaction = Transaction(),
        @ViewBuilder content: @escaping (AsyncImagePhase) -> Content
    ) {
        self.url = url
        self.scale = scale
        self.transaction = transaction
        self.content = content
    }
    
    var body: some View {
        if hasFailedToLoad {
                    content(.failure(NSError(domain: "", code: 0, userInfo: nil)))
        } else if let cached = ImageCache[url] {
            content(.success(cached))
        } else {
            AsyncImage(
                url: url,
                scale: scale,
                transaction: transaction
            ) { phase in
                cacheAndRender(phase: phase)
            }
        }
    }
    
    func cacheAndRender(phase: AsyncImagePhase) -> some View {
        if case .success (let image) = phase {
            ImageCache[url] = image
        } else if case .failure(_) = phase {
            Task { await MainActor.run { hasFailedToLoad = true } }
        }
        return content(phase)
    }
}

// MARK: - ImageCache
/// Separate class responsible for caching `Image`s mapped to corresponding `URL`s.
fileprivate class ImageCache {
    /// Dictionary for mappings of `URL`s to `Image`s stored staticly.
    static private var cache: [URL: Image] = [:]
    /// Subscript operation for storing and fetching `Image`s in cache.
    static subscript(url: URL) -> Image? {
        get {
            ImageCache.cache[url]
        }
        set {
            ImageCache.cache[url] = newValue
        }
    }
}
