
public struct InfoEntity: Codable {
    let status: String
    let data: [String: String]
    
    private enum CodingKeys: String, CodingKey {
        case status
        case data
    }
}
