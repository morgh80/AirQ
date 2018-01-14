import Foundation

struct StationModel : Codable {
    
    var stationId : Int?
    var stationName : String?
    var dateStart : String?
    var dateEnd : String?
    var gegrLat : String?
    var gegrLon : String?
    var addressStreet : String?
    var cityName: String?
    var cityId: Int?
    var communeName: String?
    var districtName: String?
    var provinceName: String?
    
    enum StationCodingKeys: String, CodingKey {
        case id
        case stationName
        case dateStart
        case dateEnd
        case gegrLat
        case gegrLon
        case city
        case addressStreet
    }
    
    enum CityCodingKeys: String, CodingKey {
        case id
        case name
        case commune
    }
    
    enum CommuneCodingKeys: String, CodingKey {
        case communeName
        case districtName
        case provinceName
    }
    
    public init(from decoder: Decoder) throws {
        do {
            let values = try decoder.container(keyedBy: StationCodingKeys.self)
            stationId = try values.decodeIfPresent(Int.self, forKey: .id)
            stationName = try values.decodeIfPresent(String.self, forKey: .stationName)
            dateStart = try values.decodeIfPresent(String.self, forKey: .dateStart)
            dateEnd = try values.decodeIfPresent(String.self, forKey: .dateEnd)
            gegrLat = try values.decodeIfPresent(String.self, forKey: .gegrLat)
            gegrLon = try values.decodeIfPresent(String.self, forKey: .gegrLon)
            addressStreet = try values.decodeIfPresent(String.self, forKey: .addressStreet)
            let cityValues  = try values.nestedContainer(keyedBy: CityCodingKeys.self, forKey: .city)
            cityName = try cityValues.decodeIfPresent(String.self, forKey: .name)
            cityId = try cityValues.decodeIfPresent(Int.self, forKey: .id)
            let communeValues = try cityValues.nestedContainer(keyedBy: CommuneCodingKeys.self, forKey: .commune)
            communeName = try communeValues.decodeIfPresent(String.self, forKey: .communeName)
            districtName = try communeValues.decodeIfPresent(String.self, forKey: .districtName)
            provinceName = try communeValues.decodeIfPresent(String.self, forKey: .provinceName)
        } catch {
            print("Error decoding city values for: \(stationName ?? "Station name not found"): \(error.localizedDescription)")
        }
    }
}

