import Foundation

public struct ClientOptions {
    public var apiKey: String
    public var mapsApiBase: String?
    public var tilesBase: String?
    public var ndaviewBase: String?
    public var maxRetries: Int?
    public var baseDelayMs: Int?
    
    public init(apiKey: String) {
        self.apiKey = apiKey
    }
}

public class NDAMapsClient {
    public let apiKey: String
    public let mapsApiBase: String
    public let tilesBase: String
    public let ndaviewBase: String
    public let maxRetries: Int
    public let baseDelayMs: Int
    
    private let urlSession: URLSession
    let sessionManager = SessionManager()
    
    public lazy var places = PlacesModule(client: self)
    public lazy var geocoding = GeocodingModule(client: self)
    public lazy var navigation = NavigationModule(client: self)
    public lazy var maps = MapsModule(client: self)
    public lazy var ndaview = NDAViewModule(client: self)
    public lazy var forcodes = ForcodesModule(client: self)
    
    public init(options: ClientOptions) {
        self.apiKey = options.apiKey
        self.mapsApiBase = options.mapsApiBase ?? "https://mapapis.ndamaps.vn/v1"
        self.tilesBase = options.tilesBase ?? "https://maptiles.ndamaps.vn"
        self.ndaviewBase = options.ndaviewBase ?? "https://api-view.ndamaps.vn/v1"
        self.maxRetries = options.maxRetries ?? 3
        self.baseDelayMs = options.baseDelayMs ?? 500
        self.urlSession = URLSession(configuration: .default)
    }
    
    func doReq(method: String, base: String, path: String, query: [URLQueryItem], body: Data? = nil) async throws -> [String: Any] {
        var allQuery = query
        allQuery.append(URLQueryItem(name: "apikey", value: apiKey))
        
        var urlComps = URLComponents(string: base + path)!
        urlComps.queryItems = allQuery
        
        var req = URLRequest(url: urlComps.url!)
        req.httpMethod = method
        if let b = body {
            req.httpBody = b
            req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        var lastErr: Error = NDAMapsError.unknown("Max retries reached")
        
        for attempt in 0...maxRetries {
            if attempt > 0 {
                let delay = Double(baseDelayMs * (1 << (attempt - 1))) / 1000.0
                try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            }
            
            let (data, response): (Data, URLResponse)
            do {
                (data, response) = try await urlSession.data(for: req)
            } catch {
                lastErr = NDAMapsError.networkError(error.localizedDescription)
                continue
            }
            
            guard let httpResp = response as? HTTPURLResponse else {
                continue
            }
            
            let status = httpResp.statusCode
            if status >= 400 {
                if status == 429 || status >= 500 {
                    let msg = String(data: data, encoding: .utf8) ?? "HTTP \(status)"
                    lastErr = mapHTTPStatus(status, msg: msg)
                    continue
                } else {
                    let msg = String(data: data, encoding: .utf8) ?? "HTTP \(status)"
                    throw mapHTTPStatus(status, msg: msg)
                }
            }
            
            guard let jsonObj = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                let str = String(data: data, encoding: .utf8) ?? ""
                throw NDAMapsError.invalidJSON("Could not parse: \(str)")
            }
            
            if let st = jsonObj["status"] as? String, let mappedErr = mapResponseStatus(st, msg: String(data: data, encoding: .utf8) ?? "") {
                throw mappedErr
            }
            
            return jsonObj
        }
        
        throw lastErr
    }
    
    func get(base: String, path: String, query: [URLQueryItem]) async throws -> [String: Any] {
        try await doReq(method: "GET", base: base, path: path, query: query, body: nil)
    }
    
    func post(base: String, path: String, query: [URLQueryItem], body: Data? = nil) async throws -> [String: Any] {
        try await doReq(method: "POST", base: base, path: path, query: query, body: body)
    }
}
