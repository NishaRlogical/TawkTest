

enum GithubAPI {
    case users(since: Int)
    case details(login: String)
}

extension GithubAPI: Networking {
    var host: String {
        return "https://api.github.com/"
    }

    var path: String {
        return ""
    }

    var endpoint: String {
        switch self {
        case let .users(since):
            return "users?since=\(since)"
        case let .details(login: login):
            return "users/\(login)"
        }
    }

    var method: HTTPMethod {
        return .get
    }

    var parameters: [String: Any]? {
        return nil
    }

    var headers: [String: String]? {
        return nil
    }
}
