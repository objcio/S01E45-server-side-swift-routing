enum Route {
    case home
    case test
    case users(id: Int)
}

import Foundation

struct PathScanner {
    var components: [String]
    init?(path: String) {
        guard let url = URL(string: path) else {
            return nil
        }
        components = url.pathComponents
        guard components.first == "/" else {
            return nil
        }
        components.removeFirst()
    }
    
    mutating func constant(_ component: String) -> Bool {
        guard components.first == component else { return false }
        components.removeFirst()
        return true
    }
    
    mutating func scan() -> Int? {
        guard let component = components.first, let int = Int(component) else {
            return nil
        }
        components.removeFirst()
        return int
    }
    
    var isEmpty: Bool {
        return components.isEmpty
    }
}

PathScanner(path: "/users/42")?.components

extension Route {
    init?(path: String) {
        guard var scanner = PathScanner(path: path) else { return nil }
        if scanner.isEmpty {
            self = .home
        } else if scanner.constant("test") {
            self = .test
        } else if scanner.constant("users"), let id = scanner.scan() {
            self = .users(id: id)
        } else {
            return nil
        }
    }
}

Route(path: "/")
Route(path: "/users/23")

typealias Response = String

extension Route {
    func interpret() -> Response {
        switch self {
        case .home: return "Homepage"
        case .test: return "Test page"
        case .users(let id): return "User profile: \(id)"
        }
    }
}

Route.users(id: 42).interpret()