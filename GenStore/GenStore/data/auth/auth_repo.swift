//
//  auth_repo.swift
//  10Store
//
//  Created by Krishna Bhattacharya on 05/12/25.
//

protocol AuthRepo{
    func Register(request :RegisterRequestModel)async throws -> RegisterResponseModel
}
