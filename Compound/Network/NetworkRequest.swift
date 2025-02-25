//
//  NetworkRequest.swift
//  Compound
//
//  Created by Vikranth Kumar on 2/23/25.
//

import Foundation

enum NetworkRequest {
    case getAdvisors
    case getAccounts(advisorId: String)
    case getHoldings(accountId: String)
}

extension NetworkRequest {
    var baseUrl: String {
        NetworkEnvironment.active.baseUrl
    }
    
    var path: String {
        switch self {
            case .getAdvisors:
                return "/advisors"
            case .getAccounts:
                return "/accounts"
            case .getHoldings:
                return "/holdings"
        }
    }
    
    var method: HTTPMethod {
        switch self {
            case .getAdvisors, .getAccounts, .getHoldings:
                return .get
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
//            case let .getAccounts(advisorId):
//                return [URLQueryItem(name: "advisor_id", value: advisorId)]
//            case let .getHoldings(accountId):
//                return [URLQueryItem(name: "account_id", value: accountId)]
            default:
                return nil
        }
    }
    
    var body: Encodable? {
        switch self {
            default:
                return nil
        }
    }
    
    var multipartData: Data? {
        switch self {
            default:
                return nil
        }
    }
    
    func createMultipartBody(dataArray: [Data]) -> Data {
        var body = Data()
        let boundary = "Boundary-\(UUID().uuidString)"
        let boundaryPrefix = "--\(boundary)\r\n"
        for (index, data) in dataArray.enumerated() {
            body.append(Data(boundaryPrefix.utf8))
            body.append(Data("Content-Disposition: form-data; name=\"file\(index)\"; filename=\"file\(index).jpg\"\r\n".utf8))
            body.append(Data("Content-Type: image/jpeg\r\n\r\n".utf8))
            body.append(data)
            body.append(Data("\r\n".utf8))
        }
        body.append(Data("--\(boundary)--\r\n".utf8))
        return body
    }
    
    func buildURL() -> URL? {
        guard var urlComponents = URLComponents(string: baseUrl.appending(path)) else {
            return nil
        }
        urlComponents.scheme = "https"
        urlComponents.queryItems = queryItems
        return urlComponents.url
    }
    
    func buildURLRequest() -> URLRequest? {
        guard let url = buildURL() else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        if let multipart = multipartData {
            let boundary = "Boundary-\(UUID().uuidString)"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.httpBody = multipart
        } else {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            if let body = try? body?.toJSONData() {
                request.httpBody = body
            }
        }
        return request
    }
    
    enum HTTPMethod: String {
        case connect = "CONNECT"
        case delete = "DELETE"
        case get = "GET"
        case head = "HEAD"
        case options = "OPTIONS"
        case patch = "PATCH"
        case post = "POST"
        case put = "PUT"
        case trace = "TRACE"
    }
}
