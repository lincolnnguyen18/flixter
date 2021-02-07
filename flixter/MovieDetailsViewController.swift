//
//  MovieDetailsViewController.swift
//  flixter
//
//  Created by Lincoln Nguyen on 2/5/21.
//

import UIKit
import AlamofireImage

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var backdropView: UIImageView!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var backdropConstraint: NSLayoutConstraint!
    @IBOutlet weak var posterDistance: NSLayoutConstraint!
    @IBOutlet weak var synopLeft: NSLayoutConstraint!
    @IBOutlet weak var synopTop: NSLayoutConstraint!
    
    
    var movie: [String:Any]!
    
    // override func loadView() {
    //     super.loadView()
    //     updateDetailView()
    // }
    //
    // override func viewDidLayoutSubviews() {
    //     updateDetailView()
    //     super.viewDidLayoutSubviews()
    // }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateDetailView(transitionSize: nil)
        // Do any additional setup after loading the view.
        print(movie["title"] ?? "No title available.")
        
        titleLabel.text = movie["title"] as? String
        // titleLabel.sizeToFit()
        
        synopsisLabel.text = movie["overview"] as? String
        synopsisLabel.sizeToFit()
        
        releaseDateLabel.text = movie["release_date"] as? String
        releaseDateLabel.sizeToFit()
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        
        posterView.af.setImage(withURL: posterUrl!)
        
        posterView.layer.masksToBounds = true
        posterView.layer.borderWidth = 1.5
        posterView.layer.borderColor = UIColor.white.cgColor
        // posterView.layer.cornerRadius = posterView.bounds.width / 25
        
        if let backdropPath = movie["backdrop_path"] as? String {
            let backdropUrl = URL(string: "https://image.tmdb.org/t/p/w780" + backdropPath)
            backdropView.af.setImage(withURL: backdropUrl!)
        } else {
            let backdropUrl = URL(string: "https://image.tmdb.org/t/p/w780" + posterPath)
            backdropView.af.setImage(withURL: backdropUrl!)
        }
        // let backdropPath = movie["backdrop_path"] as! String
        // if !backdropPath.isEmpty {
        //     let backdropUrl = URL(string: "https://image.tmdb.org/t/p/w780" + backdropPath)
        //     backdropView.af.setImage(withURL: backdropUrl!)
        // }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        updateDetailView(transitionSize: size)
    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        // find selected movie id
        let movieId = movie["id"] as! Int
        // pass it to movie trailer view controller
        let movieTrailerViewControllerNavController = segue.destination as! UINavigationController
        let movieTrailerViewController = movieTrailerViewControllerNavController.topViewController as! MovieTrailerViewController
        movieTrailerViewController.movieId = movieId
    }
    
    private func updateDetailView(transitionSize: CGSize?) {
        print("updateDetailView called")
        var size = UIScreen.main.bounds.size
        if transitionSize != nil {
            size = transitionSize ?? UIScreen.main.bounds.size
        }
        if size.width < size.height {
            print("Portrait: \(size.width) X \(size.height)")
            // print("Detail \(size.width)")
            let newMultiplier:CGFloat = 0.643857
            backdropConstraint = backdropConstraint.setMultiplier(multiplier: newMultiplier)
            posterDistance.constant = -133
            synopLeft.constant = 16
            synopTop.constant = 54.67
        } else {
            print("Landscape: \(size.width) X \(size.height)")
            // print("Detail \(size.width)")
            // self.backdropConstraint.constant = 0.1
            let newMultiplier:CGFloat = 0.4
            backdropConstraint = backdropConstraint.setMultiplier(multiplier: newMultiplier)
            posterDistance.constant = -50
            synopLeft.constant = 163 + 12
            synopTop.constant = 8
        }
        UIView.animate(withDuration: 0.1) {
            self.backdropView.updateConstraints()
            self.posterView.updateConstraints()
            self.synopsisLabel.updateConstraints()
            self.view.layoutIfNeeded()
        }
    }
}

extension NSLayoutConstraint {
    /**
     Change multiplier constraint
     
     - parameter multiplier: CGFloat
     - returns: NSLayoutConstraint
     */
    func setMultiplier(multiplier:CGFloat) -> NSLayoutConstraint {
        
        NSLayoutConstraint.deactivate([self])
        
        let newConstraint = NSLayoutConstraint(
            item: firstItem!,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)
        
        newConstraint.priority = priority
        newConstraint.shouldBeArchived = self.shouldBeArchived
        newConstraint.identifier = self.identifier
        
        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }
}
