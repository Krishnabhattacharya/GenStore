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
    
    //get
    func get<T: Decodable>(_ path: String) async throws -> T {
           try await request(path: path, method: "GET")
       }
    //post
    func post <T:Decodable>(_path:String, _body:Encodable)async throws->T{
        try await request(path: _path, method: "POST",body: _body)
    }
    //generic function for request
    func request<T:Decodable>(path:String,method:String,body:Encodable?=nil)async throws->T{
        guard let url=URL(string: path)else{
            throw URLError(.badURL)
        }
        //request url make
        var request=URLRequest(url: url)
        request.httpMethod=method
            //body make
        if let body=body{
            request.httpBody = try JSONEncoder().encode(AnyEncodable(body))
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        //api call
        let (data,response)=try await URLSession.shared.data(for: request)
        //check for valid response
        guard let http = response as? HTTPURLResponse,200..<300~=http.statusCode else{
            throw URLError(.badServerResponse)
        }
        //return data
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

}
