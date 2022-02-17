//
//  NetworkClass.swift
//  Test Run
//
//  Created by Alex Paul on 2/13/22.
//

import Foundation
class NetworkService{
    
    static let shared = NetworkService()
    
    let urlString = "https://api.notion.com/v1/databases/ec3b17faa2184ed88481a04fa359fbd3/query"
    
    func getJSON(completion: @escaping ([Result]?, Error?) -> Void){
        guard let url = URL(string: urlString ) else{
            return
        }
        var request =  URLRequest(url: url)
        
        let bodyParams = ["sorts": [
            ["property": "Name", "timestamp": "created_time", "direction": "descending"]]]
        
        let headers = ["Accept": "application/json","Notion-Version": "2021-08-16"]
        request.allHTTPHeaderFields = headers
        request.httpMethod = "POST"
        request.setValue ("secret_CcGlkzLbDGHbW3LqUH1HqDBIjIDGxhwo2QhpcdVNiFC", forHTTPHeaderField: "Authorization")
        request.setValue ("application/json", forHTTPHeaderField: "Content-Type")
      
        do{
            request.httpBody = try JSONEncoder().encode(bodyParams)
        } catch let error{
            print(String(describing: error))
        }

        URLSession.shared.dataTask(with: request) { data, response, err in
            
            if let error = err {
                print("Failed to query database", error)
                return
            }
            
            guard let data = data else {
                print("Data not received\(String(describing: err))")
                return
            }
            print(String(describing: data.description.utf8))
            let decoder = JSONDecoder()
           
            do{
                let decodedJson = try decoder.decode(DatabaseResponse.self, from: data)
                    print(decodedJson)
                DispatchQueue.main.async {
                    completion(decodedJson.results, nil)
                }
            }catch let error{
                print("Json failed to decode",error)
                return
            }
            
        }.resume()
    }
    
    
    func addData(name: String, completion: @escaping (Error?) -> Void){
        let urlString = "https://api.notion.com/v1/pages"
        guard let url = URL(string: urlString ) else{
            return
        }
        var request =  URLRequest(url: url)
        
        let bodyParams = [
            "parent" : ["database_id": "ec3b17fa-a218-4ed8-8481-a04fa359fbd3"],
            "properties": [
                "Name": ["id" : "title",
                         "title": [[
                        "text" : ["content": name],
                        "type" : "text"
                         ]],
                         "type" : "title"
                    ]
        ]]
        
        let headers = ["Accept": "application/json","Notion-Version": "2021-08-16"]
        request.allHTTPHeaderFields = headers
        request.httpMethod = "POST"
        request.setValue ("secret_CcGlkzLbDGHbW3LqUH1HqDBIjIDGxhwo2QhpcdVNiFC", forHTTPHeaderField: "Authorization")
        request.setValue ("application/json", forHTTPHeaderField: "Content-Type")
      
        let jsonData = try? JSONSerialization.data(withJSONObject: bodyParams)
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, err in

            if let error = err {
                print("Failed to query database", error)
                return
            }

            guard let data = data else {
                print("Data not received\(String(describing: err))")
                return
            }
            print(String(describing: data.description.utf8))

            do{

                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print(json)
                    }

                DispatchQueue.main.async {
                    completion(nil)
                }
            }catch let error{
                print(error)
                return
            }

        }.resume()
    }
    
}
