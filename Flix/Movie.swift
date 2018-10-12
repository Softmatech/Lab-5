//
//  Movie.swift
//  Flix
//
//  Created by Joseph Andy Feidje on 10/11/18.
//  Copyright © 2018 Softmatech. All rights reserved.
//

import Foundation

class Movie {
    
    var title: String
    var posterUrl: String?
    var backDrop: String?
    var overview: String?
    var id: NSNumber?
    
    
    init(dictionary: [String: Any]) {
        title = dictionary["title"] as? String ?? "No title"
        
        // Set the rest of the properties
        posterUrl = dictionary["poster_path"] as? String
        backDrop = dictionary["backdrop_path"] as? String
        overview = (dictionary["overview"] as? String)!
        id = dictionary["id"] as? NSNumber
    }
    
class func movies(dictionaries: [[String: Any]]) -> [Movie] {
    var movies: [Movie] = []
    for dictionary in dictionaries {
        let movie = Movie(dictionary: dictionary)
        movies.append(movie)
    }
    
    return movies
}
    
}

