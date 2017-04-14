//
//  RVSearchResults.swift
//  RevlImageSearch
//
//  Created by Michael Dautermann on 4/10/17.
//  Copyright © 2017 Michael Dautermann. All rights reserved.
//

import Foundation

struct ImageObject {

    var contentURL : URL?
    var thumbnailURL : URL?
    
    init(thumbnail thumbnailURLString : String, content contentURLString : String)
    {
        contentURL = URL(string: contentURLString)
        thumbnailURL = URL(string: thumbnailURLString)
    }
    
}

// using class instead of "struct" here because resultLinks mutates for each updated search results
class RVSearchResults
{    
    var resultLinks = [ImageObject]()
    private var searchInProgress : Bool = false
    var searchString : String = ""
    {
        didSet {
            // reset startIndex to zero since this is a new searchString
            self.resultLinks.removeAll()
        }
    }
    
    let UpdatedSearchResults = Notification.Name("updatedSearchResults")
        
    func getResultsFrom(startIndex : Int, closure: @escaping () -> Void)
    {
        if searchString.isEmpty
        {
            return
        }

        // no need to repeat a search if one is already in progress....
        if searchInProgress == true
        {
            return
        }
        
        if let escapedString = searchString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        {
            searchInProgress = true

            var request = URLRequest(url: URL(string: "https://api.cognitive.microsoft.com/bing/v5.0/images/search?q=\(escapedString)&count=50&offset=\(startIndex)&mkt=en-us&safeSearch=Moderate")!)
            request.addValue("a6738e4c135542229c8e5c5d8a697c69", forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
            let session = URLSession.shared
            session.dataTask(with: request) {data, response, err in

                if let data = data {
//                    if let html = String(data: data, encoding: String.Encoding.utf8) {
//                        print(html)
//                    }
                    do {
                        if let searchResultsDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        {
                            
                            // we likely will only get a statusCode if there is some error
                            //
                            // like too many job seekers & candidates using this BING API key at one time :-)
                            if let statusCode = searchResultsDictionary["statusCode"] as? Int
                            {
                                print("status code is \(statusCode)")
                                guard statusCode == 200 else
                                {
                                    print("status code isn't okay")
                                    self.searchInProgress = false
                                    return
                                }
                            }
                            if let items = searchResultsDictionary["value"] as? [[String:AnyObject]]
                            {
                                // it's a fresh search, remove all previous results...
                                if(startIndex <= 0)
                                {
                                    self.resultLinks.removeAll()
                                }
                                for eachDictionary in items
                                {
                                    guard let thumbnailURLString = eachDictionary["thumbnailUrl"] as? String, let contentURLString = eachDictionary["contentUrl"] as? String else {
                                        // here's a great place to throw an error alert pointing
                                        // out there was a Micro$oft error :-)
                                        print("something isn't right about this particular value")
                                        break
                                    }

                                    let newImageObject = ImageObject(thumbnail: thumbnailURLString, content: contentURLString)
                                    
                                    self.resultLinks.append(newImageObject)
                                }
                                DispatchQueue.main.async
                                {
                                    print("number of results is \(self.resultLinks.count)")
                                    closure()
                                }
                            }
                        }
                        self.searchInProgress = false
                    }
                    catch
                    {
                        print(error.localizedDescription)
                        self.searchInProgress = false
                    }
                }
            }.resume()
        }
    }
}
