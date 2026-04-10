import Foundation

public struct LatLng: Codable {
    public let lat: Double
    public let lng: Double
    
    public init(lat: Double, lng: Double) {
        self.lat = lat
        self.lng = lng
    }
}

public enum VehicleType: String, Codable {
    case car, bike, motor, taxi, truck, walking
}

// Params structures mapped to OpenAPI

public struct AutocompleteGoogleParams {
    public var input: String
    public var location: String?
    public var origin: String?
    public var radius: Double?
    public var size: Int?
    public var sessiontoken: String?
    public var admin_v2: Bool?
    public init(input: String) { self.input = input }
}

public struct AutocompleteOsmParams {
    public var text: String
    public var boundaryCircleLat: Double?
    public var boundaryCircleLon: Double?
    public var boundaryCircleRadius: Double?
    public var size: Int?
    public var sessiontoken: String?
    public var admin_v2: Bool?
    public init(text: String) { self.text = text }
}

public struct PlaceDetailParams {
    public var ids: String
    public var format: String?
    public var sessiontoken: String?
    public var admin_v2: Bool?
    public init(ids: String) { self.ids = ids }
}

public struct PlaceChildrenParams {
    public var parentId: String
    public var admin_v2: Bool?
    public init(parentId: String) { self.parentId = parentId }
}

public struct NearbyParams {
    public var categories: String
    public var pointLat: Double?
    public var pointLon: Double?
    public var size: Int?
    public var boundaryCircleRadius: Double?
    public var admin_v2: Bool?
    public init(categories: String) { self.categories = categories }
}

public struct ForwardGeocodeGoogleParams {
    public var address: String
    public var admin_v2: Bool?
    public init(address: String) { self.address = address }
}

public struct ForwardGeocodeOsmParams {
    public var text: String
    public var size: Int?
    public var admin_v2: Bool?
    public init(text: String) { self.text = text }
}

public struct ReverseGeocodeGoogleParams {
    public var latlng: String
    public var admin_v2: Bool?
    public init(latlng: String) { self.latlng = latlng }
}

public struct ReverseGeocodeOsmParams {
    public var pointLat: Double
    public var pointLon: Double
    public var boundaryCircleRadius: Double?
    public var size: Int?
    public var admin_v2: Bool?
    public init(pointLat: Double, pointLon: Double) {
        self.pointLat = pointLat
        self.pointLon = pointLon
    }
}

public struct DirectionsParams {
    public var origin: String
    public var destination: String
    public var vehicle: VehicleType?
    public var alternatives: Bool?
    public var language: String?
    public var admin_v2: Bool?
    public init(origin: String, destination: String) {
        self.origin = origin
        self.destination = destination
    }
}

public struct DistanceMatrixLocation: Codable {
    public var lat: String
    public var lon: String
    public init(lat: Double, lon: Double) {
        self.lat = String(lat)
        self.lon = String(lon)
    }
    public init(lat: String, lon: String) {
        self.lat = lat
        self.lon = lon
    }
}

public struct DistanceMatrixParams {
    public var sources: [DistanceMatrixLocation]
    public var targets: [DistanceMatrixLocation]
    public var id: String?
    public var verbose: Bool?
    public var shapeFormat: String?
    public init(sources: [DistanceMatrixLocation], targets: [DistanceMatrixLocation]) {
        self.sources = sources
        self.targets = targets
    }
}

public struct OptimizedRouteLocation: Codable {
    public var lat: Double
    public var lon: Double
    public init(lat: Double, lon: Double) {
        self.lat = lat
        self.lon = lon
    }
}

public struct OptimizedRouteParams {
    public var locations: [OptimizedRouteLocation]
    public var costing: String?
    public var directionsOptions: [String: String]?
    public var admin_v2: Bool?
    public init(locations: [OptimizedRouteLocation]) {
        self.locations = locations
    }
}

public enum StaticMapMode {
    case center(center: LatLng, zoom: Int, bearing: Double?, pitch: Double?)
    case area(minLon: Double, minLat: Double, maxLon: Double, maxLat: Double)
    case auto
}

public struct StaticMapParams {
    public var mode: StaticMapMode = .auto
    public var width: Int
    public var height: Int
    public var styleId: String?
    public var format: String?
    public var retina: Bool = false
    public var marker: String?
    public var path: String?
    public var padding: Double?
    
    public init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }
}

public struct NdaViewStaticParams {
    public var id: String?
    public var placePosition: LatLng?
    public var yaw: Double?
    public var pitch: Double?
    public init() {}
}

public struct NdaViewSearchParams {
    public var placePosition: LatLng?
    public var placeDistance: String?
    public var placeFovTolerance: Double?
    public var bbox: String?
    public var datetime: String?
    public var limit: Int?
    public var ids: String?
    public var collections: String?
    public init() {}
}

public struct ForcodeEncodeParams {
    public var lat: Double
    public var lng: Double
    public var resolution: Int?
    public init(lat: Double, lng: Double) {
        self.lat = lat
        self.lng = lng
    }
}

public struct ForcodeDecodeParams {
    public var forcodes: String
    public init(forcodes: String) { self.forcodes = forcodes }
}
