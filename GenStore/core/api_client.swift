//
//  api_client.swift
//  10Store
//
//  Created by Krishna Bhattacharya on 03/12/25.
//
import Foundation
import SwiftUI
final class Apiclient{
    static let shared = Apiclient();
    private init(){}

    struct EmptyResponse: Decodable {}

    //get
    func get<T: Decodable>(_ path: String) async throws -> T {
           try await request(path: path, method: "GET")
       }
    //post
    func post <T:Decodable>(_path:String, _body:Encodable)async throws->T{
        try await request(path: _path, method: "POST",body: _body)
    }
    func delete(_ path: String) async throws {
        let _: EmptyResponse = try await request(
            path: path,
            method: "DELETE",
            body: nil
        )
    }


    func request<T: Decodable>(
        path: String,
        method: String,
        body: Encodable? = nil,
        retry: Bool = true
    ) async throws -> T {

        guard let url = URL(string: baseUrl + path) else {
            throw URLError(.badURL)
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let token = StorageServices.shared.accessToken {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        if let body = body {
            urlRequest.httpBody = try JSONEncoder().encode(AnyEncodable(body))
        }

        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        let http = response as! HTTPURLResponse

        print("➡️ \(method) \(url.absoluteString)")
        print("📡 Status:", http.statusCode)

        if http.statusCode == 401, retry {
            print("🔄 Access token expired. Refreshing...")
            _ = try await refreshAccessToken()

            return try await self.request(
                path: path,
                method: method,
                body: body,
                retry: false
            )
        }

        if let raw = String(data: data, encoding: .utf8) {
            print("📩 Response:", raw)
        }

        guard (200...299).contains(http.statusCode) else {
            throw NSError(
                domain: "API_ERROR",
                code: http.statusCode,
                userInfo: [
                    NSLocalizedDescriptionKey:
                        String(data: data, encoding: .utf8) ?? "Server error"
                ]
            )
        }

        return try JSONDecoder().decode(T.self, from: data)
    }

    struct AnyEncodable: Encodable {
        private let encode: (Encoder) throws -> Void

        init(_ encodable: Encodable) {
            encode = encodable.encode
        }

        func encode(to encoder: Encoder) throws {
            try encode(encoder)
        }
    }
    func refreshAccessToken() async throws -> String {
        guard let refreshToken = StorageServices.shared.refreshToken else {
            throw URLError(.userAuthenticationRequired)
        }

        guard let url = URL(string: baseUrl + "/api/user/refresh-token") else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let body: [String: String] = [
            "refreshToken": refreshToken
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        print("🔄 Refresh Token Status:", http.statusCode)
        print("📩 Refresh Response:", String(data: data, encoding: .utf8) ?? "nil")
        guard (200...299).contains(http.statusCode) else {
            throw URLError(.userAuthenticationRequired)
        }
        let decoded = try JSONDecoder().decode(TokenResponseModel.self, from: data)
        StorageServices.shared.saveTokens(
            access: decoded.tokens?.accessToken ?? "",
            refresh: refreshToken
        )

        return decoded.tokens?.accessToken ?? ""
    }


}
