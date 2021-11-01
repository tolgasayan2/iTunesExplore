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
  var trakPrice: Double? = 0.0
  var currency = ""
  var artworkUrl60: String? = ""
  var artworkUrl100: String? = ""
  var trackViewUrl: String? = ""
  var primaryGenreName: String? = ""
  var kind: String? = ""
  var artistName: String? = ""
  var trackName: String? = ""
  var collectionName: String?
  var collectionViewUrl: String?
  var collectionPrice: Double?
  var itemPrice: Double?
  var itemGenre: String?
  var bookGenre: [String]?
  
  var storeUrl: String {
    return trackViewUrl ?? collectionViewUrl ?? ""
  }
  var price: Double {
    return trakPrice ?? collectionPrice ?? itemPrice ?? 0.0
  }
  var name: String {
    return trackName ?? collectionName ?? ""
  }
  var genre: String {
    let primaryGenreName = self.primaryGenreName ?? ""
    if let genre = itemGenre {
      return genre
    }
    return primaryGenreName
  }
  var type: String {
    let kind = self.kind ?? "audiobook"
    switch kind {
    case "album": return "Album"
    case "audiobook": return "Audio Book"
    case "book": return "Book"
    case "ebook": return "E-Book"
    case "feature-movie": return "Movie"
    case "music-video": return "Music Video"
    case "podcast": return "Podcast"
    case "software": return "App"
    case "song": return "Song"
    case "tv-episode": return "TV Episode"
    default: break
    }
    return "Unknown"
  }


  var artist: String {
    return artistName ?? ""
  }
}
