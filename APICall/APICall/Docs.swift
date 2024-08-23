
import Foundation
struct Docs : Codable {
	let abstract : String?
	let multimedia : [Multimedia]?
	let headline : Headline?
	let pub_date : String?
	

	enum CodingKeys: String, CodingKey {

		case abstract = "abstract"
		case multimedia = "multimedia"
		case headline = "headline"
		case pub_date = "pub_date"
		
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		abstract = try values.decodeIfPresent(String.self, forKey: .abstract)
		
		multimedia = try values.decodeIfPresent([Multimedia].self, forKey: .multimedia)
		headline = try values.decodeIfPresent(Headline.self, forKey: .headline)
		pub_date = try values.decodeIfPresent(String.self, forKey: .pub_date)
		
	}

}
