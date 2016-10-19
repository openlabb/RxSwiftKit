import RxSwift
import Argo
import Moya


enum ORMError : ErrorType {
    case ORMNoRepresentor
    case ORMNotSuccessfulHTTP
    case ORMNoData
    case ORMCouldNotMakeObjectError
    case ORMNotValidData(message:String,code:Int)
}

extension Observable {
    private func resultFromJSON<T: Decodable>(object:[String: AnyObject], classType: T.Type) -> T? {
        let decoded = classType.decode(JSON.init(object))
        switch decoded {
        case .Success(let result):
            return result as? T
        case .Failure(let error):
            NSLog("\(error)")
            return nil
        }
    }
    
    func mapSuccessfulHTTPToObject<T: Decodable>(type: T.Type) -> Observable<T> {
        return map { representor in
            guard let response = representor as? Response else {
                throw ORMError.ORMNoRepresentor
            }
            guard ((200...209) ~= response.statusCode) else {
                if let json = try? NSJSONSerialization.JSONObjectWithData(response.data, options: .AllowFragments) as? [String: AnyObject] {
                    NSLog("Got error message: \(json)")
                }
                throw ORMError.ORMNotSuccessfulHTTP
            }
            
            //do {
            guard let json = try NSJSONSerialization.JSONObjectWithData(response.data, options: .AllowFragments) as? [String: AnyObject] else {
                throw ORMError.ORMCouldNotMakeObjectError
            }
            let code:Int = json["code"] as! Int
            guard  code == 0 else{
                KKKToast.showToast(json["message"] as? String)
                throw ORMError.ORMNotValidData(message: json["message"] as! String,code: code)
            }
            
            if let jsonData =  json["data"] as? [String:AnyObject]  {
                if (jsonData.count > 0){
                    return self.resultFromJSON(jsonData, classType:type)!
                }
                else{
                    throw ORMError.ORMNoData
                }
            }else {
                throw ORMError.ORMNoData
            }

            
            //} catch{
            //   throw ORMError.ORMCouldNotMakeObjectError
            //}
        }
        
        func mapSuccessfulHTTPToObjectArray<T: Decodable>(type: T.Type) -> Observable<[T]> {
            return map { response in
                guard let response = response as? Response else {
                    throw ORMError.ORMNoRepresentor
                }
                
                // Allow successful HTTP codes
                guard ((200...209) ~= response.statusCode) else {
                    if let json = try? NSJSONSerialization.JSONObjectWithData(response.data, options: .AllowFragments) as? [String: AnyObject] {
                        NSLog("Got error message: \(json)")
                    }
                    throw ORMError.ORMNotSuccessfulHTTP
                }
                
                
                do {
                    guard let json = try NSJSONSerialization.JSONObjectWithData(response.data, options: .AllowFragments) as? [[String : AnyObject]] else {
                        throw ORMError.ORMCouldNotMakeObjectError
                    }
                    
                    // Objects are not guaranteed, thus cannot directly map.
                    var objects = [T]()
                    for dict in json {
                        
                        if let obj = self.resultFromJSON(dict, classType:type) {
                            objects.append(obj)
                        }
                    }
                    return objects
                } catch {
                    throw ORMError.ORMCouldNotMakeObjectError
                }
            }
        }
    }
}