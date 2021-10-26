//
//  SearchResult.swift
//  iTunesSearch
//
//  Created by Tolga Sayan on 20.10.2021.
//


class ResultArray: Codable {
  var resultCount = 0
  var results = [SearchResult]()
}

class SearchResult: Codable, CustomStringConvertible {
  var description: String {
    return "\nResult Kind: \(kind ?? "None"), Name: \(name), Artist Name: \(artistName ?? "None")"
  }
  var kind: String? = ""
  var artistName: String? = ""
  var trackName: String? = ""
  
  var name: String {
    return trackName ?? ""
  }
}
