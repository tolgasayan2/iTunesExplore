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
      static let loadingCell = "LoadingCell"
    }
  }
  
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var tableView: UITableView!
  
  var searchResults = [SearchResult]()
  var hasSearched = false
  var isLoading = false
  var task: URLSessionDataTask?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    var celNib = UINib(nibName: TableView.CellIdentifiers.searchResultCell, bundle: nil)
    tableView.register(celNib, forCellReuseIdentifier: TableView.CellIdentifiers.searchResultCell)
    celNib = UINib(nibName: TableView.CellIdentifiers.nothingFoundCell, bundle: nil)
    tableView.register(celNib, forCellReuseIdentifier: TableView.CellIdentifiers.nothingFoundCell)
    celNib = UINib(nibName: TableView.CellIdentifiers.loadingCell, bundle: nil)
    tableView.register(celNib, forCellReuseIdentifier: TableView.CellIdentifiers.loadingCell)
  }
  
  @IBAction func segmentChanged(_ sender: UISegmentedControl) {
    performSearch()
  }
  
  //MARK: - iTunes Networking
  
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
  
  func iTunesURL(searchText: String, category: Int) -> URL {
    let kind: String
    switch category {
    case 1: kind = "musicTrack"
    case 2: kind = "software"
    case 3: kind = "ebook"
    default: kind = ""
    }
    let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    let urlString = "https://itunes.apple.com/search?" +
    "term=\(encodedText)&limit=200&entity=\(kind)"
    let url = URL(string: urlString)
    return url!
  }
  
  func showNetworkError() {
    let alert = UIAlertController(
      title: "Failure!", message: "There was an error accesing the iTunes Store." + " Please try again.", preferredStyle: .alert)
    let action = UIAlertAction(
      title: "OK", style: .default, handler: nil)
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
}
//MARK: - SearchViewController Delegate

extension SearchViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    performSearch()
  }
  
  func performSearch() {
    if !searchBar.text!.isEmpty {
      searchBar.resignFirstResponder()
      task?.cancel()
      isLoading = true
      tableView.reloadData()
      
      hasSearched = true
      searchResults = []
      
      let url = iTunesURL(searchText: searchBar.text!, category: segmentedControl.selectedSegmentIndex)
      let session = URLSession.shared
      task = session.dataTask(with: url) { data, response, error in
        if let error = error {
          print("Failure \(error.localizedDescription)")
        } else {
          if let data = data {
            self.searchResults = self.parse(data: data)
            self.searchResults.sort { $0.name.localizedStandardCompare($1.name) ==
              .orderedAscending }
            DispatchQueue.main.async {
              
              self.isLoading = false
              self.tableView.reloadData()
            }
          }
          return
        }
        DispatchQueue.main.async {
          self.isLoading = false
          self.hasSearched = false
          self.showNetworkError()
          self.tableView.reloadData()
        }
      }
      task?.resume()
    }
  }
  
  func position(for bar: UIBarPositioning) -> UIBarPosition {
    return .topAttached
  }
}
//MARK: - TableView Delegate and DataSource

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(
    _ tableView: UITableView, numberOfRowsInSection section: Int
  ) -> Int {
    if isLoading {
      return 1
    } else if !hasSearched {
      return 0
    } else if searchResults.count == 0 {
      return 1
    } else {
      return searchResults.count
    }
  }
  
  func tableView(
    _ tableView: UITableView, cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    if isLoading {
      let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.loadingCell, for: indexPath)
      let spinner = cell.viewWithTag(50) as! UIActivityIndicatorView
      spinner.startAnimating()
      return cell
    } else if searchResults.count == 0 {
      return tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.nothingFoundCell, for: indexPath)
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.searchResultCell, for: indexPath) as! SearchResultCell
      let searchResult = searchResults[indexPath.row]
      cell.nameLabel.text = searchResult.name
      if searchResult.artist.isEmpty {
        cell.artistNameLabel.text = "Unknown"
      } else {
        cell.artistNameLabel.text = String(format: "%@ (%@)", searchResult.artist, searchResult.type)
      }
      return cell
    }
  }
  
  func tableView(
    _ tableView: UITableView, didSelectRowAt indexPath: IndexPath
  ) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(
    _ tableView: UITableView, willSelectRowAt indexPath: IndexPath
  ) -> IndexPath? {
    if searchResults.count == 0 || isLoading {
      return nil
    } else {
      return indexPath
    }
  }
}
