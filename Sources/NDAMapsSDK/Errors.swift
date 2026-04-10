import Foundation

public enum NDAMapsError: Error, CustomStringConvertible {
    case invalidAPIKey(String)
    case invalidForcode(String)
    case placeNotFound(String)
    case zeroResults(String)
    case invalidParams(String)
    case rateLimitExceeded(String)
    case networkError(String)
    case unknown(String)
    case invalidJSON(String)
    
    public var description: String {
        switch self {
        case .invalidAPIKey(let msg): return "Invalid API Key: \(msg)"
        case .invalidForcode(let msg): return "Invalid Forcode: \(msg)"
        case .placeNotFound(let msg): return "Place Not Found: \(msg)"
        case .zeroResults(let msg): return "Zero Results: \(msg)"
        case .invalidParams(let msg): return "Invalid Params: \(msg)"
        case .rateLimitExceeded(let msg): return "Rate Limit Exceeded: \(msg)"
        case .networkError(let msg): return "Network/HTTP Error: \(msg)"
        case .unknown(let msg): return "Unknown Error: \(msg)"
        case .invalidJSON(let msg): return "JSON Parse Error: \(msg)"
        }
    }
}

func mapHTTPStatus(_ status: Int, msg: String) -> NDAMapsError {
    switch status {
    case 400: return .invalidParams(msg)
    case 401, 403: return .invalidAPIKey(msg)
    case 404: return .placeNotFound(msg)
    case 429: return .rateLimitExceeded(msg)
    default:
        if status >= 500 { return .networkError(msg) }
        return .unknown(msg)
    }
}

func mapResponseStatus(_ status: String, msg: String) -> NDAMapsError? {
    switch status {
    case "OK": return nil
    case "INVALID_FORCODES": return .invalidForcode(msg)
    case "NOT_FOUND": return .placeNotFound(msg)
    case "ZERO_RESULTS": return .zeroResults(msg)
    case "INVALID_REQUEST": return .invalidParams(msg)
    case "REQUEST_DENIED": return .invalidAPIKey(msg)
    case "OVER_QUERY_LIMIT": return .rateLimitExceeded(msg)
    default: return nil
    }
}
