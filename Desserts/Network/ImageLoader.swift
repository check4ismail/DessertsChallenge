//
//  ImageLoader.swift
//  Desserts
//
//  Created by Ismail Elmaliki on 4/16/23.
//

import Foundation
import UIKit

/// Abstract Image Loader.
///
/// Downloads and caches Dessert images.
protocol ImageLoader {
	/// Dessert in-memory image cache.
	///
	/// Using a key-store pair approach with NSCache, it uses the Dessert's `id` to cache its `UIImage`.
	var imageCache: NSCache<NSString, UIImage> { get }
	
	/// Download dessert image using Dessert`id` then add to image cache.
	///
	/// If image is in cache, then it returns image to prevent redundant network call.
	func downloadImage(_ dessert: Dessert, completion: @escaping (UIImage) -> ())
}

/// Prod implementation of `ImageLoader`.
final class ImageProdLoader: ImageLoader {
	static let shared: ImageLoader = ImageProdLoader()
	let imageCache: NSCache<NSString, UIImage>
	
	private let urlSession: URLSession
	
	private init() {
		urlSession = URLSession.shared
		imageCache = NSCache()
		
		/// Maximum image cache limit is 100 MB.
		imageCache.totalCostLimit = 100 * 1024 * 1024
	}
	
	/// In order to conserve memory within cache, after fetching image
	/// from network call image data is compressed with lower JPEG quality.
	func downloadImage(_ dessert: Dessert, completion: @escaping (UIImage) -> ()) {
		let storedImage = imageCache.object(forKey: NSString(string: dessert.id))
		guard storedImage == nil else {
			completion(storedImage!)
			return
		}
		
		let imageURL = URL(string: dessert.imageURL)!
		
		DispatchQueue.global().async { [weak self] in
			if let self,
			   let data = try? Data(contentsOf: imageURL),
			   let image = UIImage(data: data),
			   let compressedData = image.jpegData(compressionQuality: 0.2),
			   let compressedImage = UIImage(data: compressedData) {
				self.imageCache.setObject(compressedImage, forKey: NSString(string: dessert.id))
				completion(compressedImage)
			}
		}
	}
}
