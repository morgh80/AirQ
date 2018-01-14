import Foundation
 

public class JsonParser {
	public var id : Int?
	public var stationName : String?
	public var dateStart : String?
	public var dateEnd : String?
	public var gegrLat : Double?
	public var gegrLon : Double?
	public var city : City?
	public var addressStreet : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Json4Swift_Base Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [JsonParser]
    {
        var models:[JsonParser] = []
        for item in array
        {
            models.append(JsonParser(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let json4Swift_Base = Json4Swift_Base(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Json4Swift_Base Instance.
*/
	required public init?(dictionary: NSDictionary) {

		id = dictionary["id"] as? Int
		stationName = dictionary["stationName"] as? String
		dateStart = dictionary["dateStart"] as? String
		dateEnd = dictionary["dateEnd"] as? String
		gegrLat = dictionary["gegrLat"] as? Double
		gegrLon = dictionary["gegrLon"] as? Double
		if (dictionary["city"] != nil) { city = City(dictionary: dictionary["city"] as! NSDictionary) }
		addressStreet = dictionary["addressStreet"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.id, forKey: "id")
		dictionary.setValue(self.stationName, forKey: "stationName")
		dictionary.setValue(self.dateStart, forKey: "dateStart")
		dictionary.setValue(self.dateEnd, forKey: "dateEnd")
		dictionary.setValue(self.gegrLat, forKey: "gegrLat")
		dictionary.setValue(self.gegrLon, forKey: "gegrLon")
		dictionary.setValue(self.city?.dictionaryRepresentation(), forKey: "city")
		dictionary.setValue(self.addressStreet, forKey: "addressStreet")

		return dictionary
	}

}
