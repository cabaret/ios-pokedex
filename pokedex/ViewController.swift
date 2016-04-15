//
//  ViewController.swift
//  pokedex
//
//  Created by Joris Ooms on 15/04/16.
//  Copyright © 2016 Cup of Code. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire
import SwiftCSV

class ViewController: UIViewController,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout,
    UISearchBarDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var pokemons = [Pokemon]()
    private var filteredPokemons = [Pokemon]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var musicPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        
        searchBar.delegate = self
        searchBar.returnKeyType = .Done
        
        parsePokemonCSV()
        initAudio()
    }
    
    func initAudio() {
        let path = NSBundle.mainBundle().pathForResource("audio", ofType: "mp3")!
        
        do {
            if let url = NSURL(string: path) {
                musicPlayer = try AVAudioPlayer(contentsOfURL: url)
                musicPlayer.prepareToPlay()
                musicPlayer.numberOfLoops = -1
                musicPlayer.play()
            }
        } catch let err as NSError {
            print("Error playing music.", err.debugDescription)
        }
    }
    
    @IBAction func musicButtonPressed(sender: UIButton!) {
        if musicPlayer.playing {
            musicPlayer.stop()
            sender.alpha = 0.2
            
        } else {
            musicPlayer.play()
            sender.alpha = 1.0
        }
    }
    
    func getDataCollection() -> [Pokemon] {
        return (filteredPokemons.count == 0) ? pokemons : filteredPokemons
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            filteredPokemons = [Pokemon]()
            view.endEditing(true)
        } else {
            let term = searchText.lowercaseString
            filteredPokemons = pokemons.filter({ $0.name.rangeOfString(term) != nil })
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return getDataCollection().count
    }

    func collectionView(collectionView: UICollectionView,
                        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let collection = getDataCollection()
        let pokemon = collection[indexPath.row]
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PokemonCell", forIndexPath: indexPath) as? PokemonCollectionViewCell {
            cell.configureCell(pokemon)
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(collectionView: UICollectionView,
                        didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let pokemon = getDataCollection()[indexPath.row]
        
        performSegueWithIdentifier("DetailViewController", sender: pokemon)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(105, 105)
    }
    
    func parsePokemonCSV() {
        do {
            if let path = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv") {
                let csv = try CSV(name: path,
                                  delimiter: ",",
                                  encoding: NSUTF8StringEncoding,
                                  loadColumns: false)
                
                for pokemonDataRow in csv.rows {
                    let pokedexId = Int(pokemonDataRow["id"]!)!
                    let name = pokemonDataRow["identifier"]!
                    
                    let pokemon = Pokemon(name: name, pokedexId: pokedexId)
                    pokemons.append(pokemon)
                }
            }
        } catch let err as NSError {
            print("Could not parse CSV.", err.debugDescription)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DetailViewController" {
            if let viewController = segue.destinationViewController as? DetailViewController {
                if let pokemon = sender as? Pokemon {
                    
                    viewController.pokemon = pokemon
                }
            }
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

