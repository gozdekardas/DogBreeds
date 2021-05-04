//
//  DogApi.swift
//  ImageReturn
//
//  Created by GOZDE KARDAS on 2.05.2021.
//

import Foundation
import UIKit

class DogApi{
    enum Endpoint  {
        case randomDog
        case dogBreedList
        case randomImageForBreed(String)
        
        var url: URL{
            return URL(string: self.stringValue)!
        }
        
        var stringValue : String {
            switch self {
            case .randomDog: return "https://dog.ceo/api/breeds/image/random"
            case .dogBreedList: return "https://dog.ceo/api/breeds/list/all"
            case .randomImageForBreed(let breed) : return "https://dog.ceo/api/breed/\(breed)/images/random"
            }
        }
    }
    
    class func requestRandomImage(breed: String, completionHandler: @escaping (UIImage?,Error?)->Void){
        let endPoint = DogApi.Endpoint.randomImageForBreed(breed).url
        print(endPoint)
      
        let task = URLSession.shared.dataTask(with: endPoint){
            (data, response,error) in
            guard let data = data else {
                print("no data")
                completionHandler(nil,error)
                return
            }
            
            let decoder = JSONDecoder()
            let imageUrl = try! decoder.decode(DogImage.self, from: data)
            
            print(imageUrl.message)
            
            guard let url = URL(string: imageUrl.message)
            else {
                print("location is nil")
                return
                
            }
            
            
            
            requestImageFile(url: url, completionHandler: {(Image, error) in
                
                completionHandler(Image,nil)
                })
            
            }
            task.resume()
        
        
        
        
    }
    
    
    class func requestImageFile(url: URL, completionHandler: @escaping(UIImage?,Error?) -> Void){
        let task = URLSession.shared.dataTask(with: url,completionHandler: { (data, response, error) in
            guard let data = data else {
                completionHandler(nil,error)
                return
            }
            let downloadedImage = UIImage(data :data)
            completionHandler(downloadedImage,nil)
        })
        task.resume()
    }
    
    class func requestBreedList(completionHandler: @escaping([String]?, Error?) -> Void){
        let task = URLSession.shared.dataTask(with: Endpoint.dogBreedList.url,completionHandler: { (data, response, error) in
            guard let data = data else {
                completionHandler(nil,error)
                return
            }
            let decoder = JSONDecoder()
            let breedList = try! decoder.decode(DogBreeds.self, from: data)
            
            let breeds = breedList.message.keys.map({$0})
            
            print(breedList)
            completionHandler(breeds,nil)
        })
        task.resume()
    }
}
