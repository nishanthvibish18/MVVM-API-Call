
import Foundation
struct Response : Codable {
	let docs : [Docs]?

	enum CodingKeys: String, CodingKey {

		case docs = "docs"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		docs = try values.decodeIfPresent([Docs].self, forKey: .docs)
	}

}
