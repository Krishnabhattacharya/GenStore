//
//  auth_repo_impl.swift
//  10Store
//
//  Created by Krishna Bhattacharya on 05/12/25.
//

class AuthRepoImpl: AuthRepo {
    private let apiClient:Apiclient
    init (apiClient:Apiclient) {
        self.apiClient = apiClient
    }
    func Register(request: RegisterRequestModel) async throws -> RegisterResponseModel {
        let res:RegisterResponseModel=try await apiClient.post(_path: registerEndPoint, _body: request)
        return res
    }
}
