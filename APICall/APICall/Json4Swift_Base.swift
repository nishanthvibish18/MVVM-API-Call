
import Foundation

struct APIResponseModel : Codable {
	let status : String?
	let copyright : String?
	let response : Response?

	enum CodingKeys: String, CodingKey {

		case status = "status"
		case copyright = "copyright"
		case response = "response"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		status = try values.decodeIfPresent(String.self, forKey: .status)
		copyright = try values.decodeIfPresent(String.self, forKey: .copyright)
		response = try values.decodeIfPresent(Response.self, forKey: .response)
	}

}
