//
//  WebServiceHandler.swift
//  MyApp
//
//  Created by anmy on 06/08/22.
//

import Foundation
import UIKit
import Alamofire
import CodableAlamofire
import SwiftyJSON

class WebServiceHandler {
    
    static let shared = WebServiceHandler()
    
   var headers: HTTPHeaders = [
        "Accept": "application/json",
        "Content-Type": "application/json"
    ]
    
    
    var isConnectedToInternet: Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    
    func getData<T: Decodable>(method: HTTPMethod, api: String, params: [String : Any] = [:], encoding: ParameterEncoding = URLEncoding.default, completionHandler: @escaping (DataResponse<T>) -> Void){
        if let token = UserDefaults.standard.string(forKey: "token"){
            headers["Authorization"] = "Bearer \(token)"
        }
        let url = api
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        Alamofire.request(url, method: method, parameters: params, encoding: encoding, headers: headers).responseDecodableObject(queue: nil, keyPath: nil, decoder: decoder, completionHandler: completionHandler)
        
    }
    
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
}
