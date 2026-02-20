//
//  endpoints.swift
//  10Store
//
//  Created by Krishna Bhattacharya on 02/12/25.
//

let  loginEndPoint : String = "api/user/login"
let registerEndPoint : String = "api/user/register"
let productsEndPoint : String = "api/product/getProductByCategory?category="
let cartEndPoint : String = "api/cart/addCart"
let getCartEndPoint :String = "api/cart/getUserCart"
let placeOrderEndPoint : String = "api/order/addOrder"
let getOrdersEndPoint:String = "api/order/getUserOrders?page=1&limit=20&status=pending"
enum ViewState {
    case idle
    case loading
    case success
    case empty
    case error(String)
}
