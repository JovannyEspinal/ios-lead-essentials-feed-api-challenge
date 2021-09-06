import Foundation

internal struct FeedImageMapper {
	private struct Root: Decodable {
		private let items: [Item]

		var feedImages: [FeedImage] {
			items.map { $0.feedImage }
		}
	}

	private struct Item: Decodable {
		enum CodingKeys: String, CodingKey {
			case id = "image_id"
			case description = "image_desc"
			case location = "image_loc"
			case url = "image_url"
		}

		let id: UUID
		let description: String?
		let location: String?
		let url: URL

		var feedImage: FeedImage {
			FeedImage(id: id,
			          description: description,
			          location: location,
			          url: url)
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
