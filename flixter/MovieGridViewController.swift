//
//  MovieGridViewController.swift
//  flixter
//
//  Created by Lincoln Nguyen on 2/5/21.
//

import UIKit
import AlamofireImage

class MovieGridViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    var movies = [[String:Any]]()
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        
        // let size = UIScreen.main.bounds.size
        // let width = (size. - layout.minimumInteritemSpacing * 2) / 3
        // layout.itemSize = CGSize(width: width, height: width * 1.5)
        
        let size = UIScreen.main.bounds.size
        if size.width < size.height {
            print("Portrait: \(size.width) X \(size.height)")
            let width = (size.width - layout.minimumInteritemSpacing * 2) / 3
            layout.itemSize = CGSize(width: width, height: width * 1.5)
        } else {
            print("Landscape: \(size.width) X \(size.height)")
            let width = (size.height - layout.minimumInteritemSpacing * 3) / 4
            layout.itemSize = CGSize(width: width, height: width * 1.5)
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/297762/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                // TODO: Get the array of movies
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                // TODO: Store the movies in a property to use elsewhere
                self.movies = dataDictionary["results"] as! [[String:Any]]
                self.collectionView.reloadData()
                // print(self.movies)
            }
        }
        task.resume()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    
        let selectedIndex = tabBarController!.selectedIndex
        // print(selectedIndex)
        
        if selectedIndex != 1 {
            return
        }
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
    
        layout.invalidateLayout()
    
        if UIDevice.current.orientation.isLandscape {
            print("Landscape: \(size.width) X \(size.height)")
            // print("\(size.width)")
            let width = (size.height - layout.minimumInteritemSpacing * 3) / 4
            layout.itemSize = CGSize(width: width, height: width * 1.5)
        } else {
            print("Portrait: \(size.width) X \(size.height)")
            // print("\(size.width)")
            let width = (size.width - layout.minimumInteritemSpacing * 2) / 3
            layout.itemSize = CGSize(width: width, height: width * 1.5)
        }
    
        let url = URL(string: "https://api.themoviedb.org/3/movie/297762/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                // TODO: Get the array of movies
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                // TODO: Store the movies in a property to use elsewhere
                self.movies = dataDictionary["results"] as! [[String:Any]]
                self.collectionView.reloadData()
                // print(self.movies)
            }
        }
        task.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as! MovieGridCell
        
        let movie = movies[indexPath.item]
        
        let baseUrl = "https://image.tmdb.org/t/p/w300"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        
        cell.posterView.af.setImage(withURL: posterUrl!)
        
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        // find selected movie
        let cell = sender as! UICollectionViewCell
        let indexPath = collectionView.indexPath(for: cell)!
        let movie = movies[indexPath.row]
        // pass it to details view controller
        let detailsViewController = segue.destination as! MovieDetailsViewController
        detailsViewController.movie = movie
        collectionView.deselectItem(at: indexPath, animated: true)
    }

}
