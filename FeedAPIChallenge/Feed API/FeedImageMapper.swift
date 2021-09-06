import Foundation

internal struct FeedImageMapper {
	private struct Root: Decodable {
		private let items: [Item]

		var feedImages: [FeedImage] {
			items.map { $0.feedImage }
		}
	}

	private struct Item: Decodable {
		let image_id: UUID
		let image_desc: String?
		let image_loc: String?
		let image_url: URL

		var feedImage: FeedImage {
			FeedImage(id: image_id,
			          description: image_desc,
			          location: image_loc,
			          url: image_url)
		}
	}

	private static let STATUS_CODE_200 = 200

	internal static func map(_ data: Data, from response: HTTPURLResponse) -> FeedLoader.Result {
		guard response.statusCode == STATUS_CODE_200, let root = try? JSONDecoder().decode(Root.self, from: data) else {
			return .failure(RemoteFeedLoader.Error.invalidData)
		}

		return .success(root.feedImages)
	}
}
