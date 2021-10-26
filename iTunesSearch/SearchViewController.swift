//
//  ViewController.swift
//  iTunesSearch
//
//  Created by Tolga Sayan on 20.10.2021.
//

import UIKit

class SearchViewController: UIViewController {
  
  struct TableView {
    struct CellIdentifiers {
      static let searchResultCell = "SearchResultCell"
      static let nothingFoundCell = "NothingFoundCell"
    }
  }
  
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var tableView: UITableView!
  
  var searchResults = [SearchResult]()
  var hasSearched = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let celNib = UINib(nibName: TableView.CellIdentifiers.searchResultCell, bundle: nil)
    let celNib2 = UINib(nibName: TableView.CellIdentifiers.nothingFoundCell, bundle: nil)
    
    tableView.register(celNib, forCellReuseIdentifier: TableView.CellIdentifiers.searchResultCell)
    tableView.register(celNib2, forCellReuseIdentifier: TableView.CellIdentifiers.nothingFoundCell)
    
    
  }
  func parse(data: Data) -> [SearchResult] {
    do {
      let decoder = JSONDecoder()
      let result = try decoder.decode(
        ResultArray.self, from: data)
      return result.results
    } catch {
      print("JSON Error: \(error)")
      return []
    }
  }
  
  func iTunesURL(searchText: String) -> URL {
    let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    let urlString = String(format: "http://itunes.apple.com/search?term=%@", encodedText)
    let url = URL(string: urlString)
    return url!
  }
  func performStoreRequest(with url: URL) -> Data? {
    do {
      return try Data(contentsOf: url)
    } catch {
      showNetworkError()
      return nil
    }
  }
  func showNetworkError() {
    let alert = UIAlertController(title: "Whoops!", message: "There was an error accesing the iTunes Store." + " Please try again.", preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
  
  
}

extension SearchViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    if !searchBar.text!.isEmpty {
      searchBar.resignFirstResponder()
      
      hasSearched = true
      searchResults = []
      
      let url = iTunesURL(searchText: searchBar.text!)
      print("URL: '\(url)'")
      if let data = performStoreRequest(with: url){
        let results = parse(data: data)
        print("Got results: \(results)")
      }
      
      tableView.reloadData()
    }
  }
  
  func position(for bar: UIBarPositioning) -> UIBarPosition {
    return .topAttached
  }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if !hasSearched {
      return 0
    } else if searchResults.count == 0 {
      return 1
    } else {
      return searchResults.count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellIdentifier = TableView.CellIdentifiers.searchResultCell
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SearchResultCell
    
    
    if searchResults.count == 0 {
      return tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.nothingFoundCell, for: indexPath)
    } else {
      
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    if searchResults.count == 0 {
      return nil
    } else {
      return indexPath
    }
  }
}
