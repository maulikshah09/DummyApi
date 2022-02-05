//
//  APIManager.swift
//  WebMobi
//
//  Created by Maulik Shah on 7/15/21.
//

import Foundation
import SVProgressHUD



var headerInfo = ["app-id":"61fe250a611ffea87335281b"]

fileprivate extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

struct MediaFileInfo {
    let key: String
    let filename: String
    let data: Data
    let mimeType: String
    
    init(key: String, filename: String, mimeType:String, fileData: Data) {
        self.key = key
        self.filename = filename
        self.mimeType = mimeType
        self.data = fileData
    }
}
 

// MARK:- Common Api
extension URLSession {
    
    enum customError : Error {
        case invalidUrl
        case invalidData
    }
    
    enum Method : String{
        case get = "GET"
        case post = "POST"
        case delete = "DELETE"
        case put    = "PUT"
        case patch = "PATCH"
    }
    
    
    func generateBoundary () -> String{
        return "Boundary-\(NSUUID().uuidString)"
    }
     
 
   
    private func urlRequest<T:Decodable>
                 (request : URLRequest, isShowHUD:Bool = true,decodeClass : T.Type, complition:@escaping(T?,Error?) -> Void) {
        
        self.dataTask(with: request) {data, response,error in
        
                    if isShowHUD {
                        SVProgressHUD.dismiss()
                    }
            
//            var statusCode = 0
//            if let httpResponse = response as? HTTPURLResponse {
//                statusCode = httpResponse.statusCode
//            }
        
            guard let data = data else {
                if let error = error {
                    complition(nil, error)
                }else{
                    complition(nil, customError.invalidUrl)
                }
                return
            }

            
        
            do{
                #if DEBUG
                print(
                    """
                    response is
                    =================
                    \(String(data: data, encoding: .utf8)?.toJsonObject() ?? "NO Response")
                    =================
                    """)
                #endif
               
                
                let result = try JSONDecoder().decode(decodeClass,from:data)
                complition(result,nil)
            }catch{
                #if DEBUG
                print(error)
                #endif
                complition(nil, error)
            }
        }.resume()
    }
    
    
    func request<T: Decodable>(
        url : String?,
        isShowHUD:Bool = true,
        headerInfo : [String: String]?,
        method : Method,
        parmeters : [String: Any]? = nil,
        decodeClass : T.Type,
        complition:@escaping(T?,Error?) -> Void){
     
        
        #if DEBUG
        print(
            """
            URl : \(url ?? "wrong url")
            =============================
            header Info : \(headerInfo ?? [:])
            =============================
            Method : \(method)
            =============================
            Parms :
            \(parmeters ?? [:])
            """)
        #endif
     
        
        if isShowHUD {
            SVProgressHUD.show()
        }
      
        guard let urlString = url  else {
            complition(nil, customError.invalidUrl)
            return
        }
        
        guard let url = URL(string: urlString) else {
            complition(nil, customError.invalidUrl)
            return
        }
        
     
        var urlRequest  = URLRequest(url: url)
        
        if let header = headerInfo {
            for dic in header{
                urlRequest.addValue(dic.value, forHTTPHeaderField: dic.key)
            }
        }

        // remove this different output.
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")

        urlRequest.httpMethod = method.rawValue
     
        if method == .get{
            if let parms = parmeters {
                var urlComponent = URLComponents(string: urlString)
                urlComponent?.queryItems = parms.map { URLQueryItem(name: $0, value: "\($1)")}
                urlRequest.url = urlComponent?.url
            }else{
                urlRequest.url = url
            }
        }else {
         
            if let parmeters = parmeters {
                // post,delete, patch
                let bodyData = try? JSONSerialization.data(withJSONObject: parmeters, options: [])
                urlRequest.httpBody = bodyData
            }
        }
        
        self.urlRequest(request: urlRequest, isShowHUD: isShowHUD, decodeClass: decodeClass) { response, error in
            complition(response,error)
        }
    }

    
    // multipart api
    func multiPartRequest<T:Decodable>(
        url:String?,
        isShowHUD:Bool = true,
        headerInfo : [String: String]?,
        method : Method = .post,
        parmeters : [String: Any]? = nil,
        decodeClass : T.Type,
        media: [MediaFileInfo]? = [MediaFileInfo](),
        complition:@escaping(T?,Error?) -> Void){
        
        
        #if DEBUG
        print(
            """
            URl : \(url ?? "wrong url")
            =============================
            header Info : \(headerInfo ?? [:])
            =============================
            Method : \(method)
            =============================
            Parms :
            \(parmeters ?? [:])
            """)
        #endif
        
        if isShowHUD {
            SVProgressHUD.show()
        }
      
        guard let urlString = url  else {
            complition(nil, customError.invalidUrl)
            return
        }
        
        guard let url = URL(string: urlString) else {
            complition(nil, customError.invalidUrl)
            return
        }
     
        
        var urlRequest  = URLRequest(url: url)
        
        
      
        //boundary create
        let boundary = generateBoundary()
        urlRequest.setValue("multipart/form-data;boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
       
        //header added
        if let header = headerInfo {
            for dic in header{
                 urlRequest.addValue(dic.value, forHTTPHeaderField: dic.key)
            }
        }
        
        
        //create Body 
        let lineBreak = "\r\n"
        var body = Data()
        
        // add parms to Body
        if let parmeters = parmeters {
            for (key, value) in parmeters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\("\(value)" + lineBreak)")
            }
        }
        
        
        // Add media to Multipart
        if let media = media {
            for file in media {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(file.key)\"; filename=\"\(file.filename)\"\(lineBreak)")
                body.append("Content-Type: \(file.mimeType + lineBreak + lineBreak)")
                body.append(file.data)
                body.append(lineBreak)
            }
        }
    
        body.append("--\(boundary)--\(lineBreak)")
     
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = body
        
        self.urlRequest(request: urlRequest, isShowHUD: isShowHUD, decodeClass: decodeClass) { response, error in
 
            complition(response,error)
        }
    }
}
