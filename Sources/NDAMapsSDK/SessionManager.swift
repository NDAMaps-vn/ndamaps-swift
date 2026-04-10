import Foundation

class SessionManager {
    private var token: String?
    private var createdAt: Date?
    private let ttl: TimeInterval = 300 // 5 minutes
    private let lock = NSLock()
    
    func getOrCreate() -> String {
        lock.lock(); defer { lock.unlock() }
        
        if let created = createdAt, Date().timeIntervalSince(created) <= ttl, let t = token {
            return t
        }
        
        let newToken = UUID().uuidString
        self.token = newToken
        self.createdAt = Date()
        return newToken
    }
    
    func getCurrent() -> String? {
        lock.lock(); defer { lock.unlock() }
        
        if let created = createdAt, Date().timeIntervalSince(created) <= ttl {
            return token
        }
        self.token = nil
        return nil
    }
    
    func reset() {
        lock.lock(); defer { lock.unlock() }
        self.token = nil
    }
}
