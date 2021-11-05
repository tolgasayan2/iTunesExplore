//
//  SearchResult.swift
//  iTunesSearch
//
//  Created by Tolga Sayan on 20.10.2021.
//
import Foundation

class ResultArray: Codable {
  var resultCount = 0
  var results = [SearchResult]()
}

func < (lhs: SearchResult, rhs: SearchResult) -> Bool {
  return lhs.name.localizedStandardCompare(rhs.name) == .orderedAscending
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
    case "album":
      return NSLocalizedString(
        "Album",
        comment: "Localized kind: Album")
    case "audiobook":
      return NSLocalizedString(
        "Audio Book",
        comment: "Localized kind: Audio Book")
    case "book":
      return NSLocalizedString(
        "Book",
        comment: "Localized kind: Book")
    case "ebook":
      return NSLocalizedString(
        "E-Book",
        comment: "Localized kind: E-Book")
    case "feature-movie":
      return NSLocalizedString(
        "Movie",
        comment: "Localized kind: Feature Movie")
    case "music-video":
      return NSLocalizedString(
        "Music Video",
        comment: "Localized kind: Music Video")
    case "podcast":
      return NSLocalizedString(
        "Podcast",
        comment: "Localized kind: Podcast")
    case "software":
      return NSLocalizedString(
        "App",
        comment: "Localized kind: Software")
    case "song":
      return NSLocalizedString(
        "Song",
        comment: "Localized kind: Song")
    case "tv-episode":
      return NSLocalizedString(
        "TV Episode",
        comment: "Localized kind: TV Episode")
    default:
      return kind
    }
  }



  var artist: String {
    return artistName ?? ""
  }
}
