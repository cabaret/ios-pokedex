//
//  PokemonDetailViewController.swift
//  pokedex
//
//  Created by Joris Ooms on 15/04/16.
//  Copyright © 2016 Cup of Code. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class DetailViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var typeLabel: StatsLabel!
    @IBOutlet weak var pokedexIdLabel: UILabel!
    @IBOutlet weak var weightLabel: StatsLabel!
    @IBOutlet weak var attackLabel: StatsLabel!
    @IBOutlet weak var heightLabel: StatsLabel!
    @IBOutlet weak var defenseLabel: StatsLabel!
    @IBOutlet weak var nextEvolutionImage: UIImageView!
    @IBOutlet weak var evolutionLabel: UILabel!
    
    var loader: NVActivityIndicatorView!
    var pokemon: Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loader = NVActivityIndicatorView(frame: self.view.frame,
                                         type: .BallPulse,
                                         color: UIColor.whiteColor(),
                                         padding: 200.0)
        loader.backgroundColor = UIColor(hex: 0xFF5855)
        loader.hidesWhenStopped = true
        loader.startAnimation()
        
        self.view.addSubview(loader)
    }

    override func viewWillAppear(animated: Bool) {
        nameLabel.text = pokemon.name.capitalizedString
        mainImage.image = UIImage(named: "\(pokemon.pokedexId)")
        pokedexIdLabel.text = "\(pokemon.pokedexId)"
        
        pokemon.fetchPokemonDetails { () -> () in
            self.updateUI()
        }
    }
    
    func updateUI() {
        descriptionLabel.text = pokemon.description
        typeLabel.text = pokemon.type
        weightLabel.text = pokemon.weight
        heightLabel.text = pokemon.height
        attackLabel.text = pokemon.attack
        defenseLabel.text = pokemon.defense
        
        if let nextEvolutionId = pokemon.nextEvolutionId where nextEvolutionId != "" {
            nextEvolutionImage.hidden = false
            nextEvolutionImage.image = UIImage(named: "\(pokemon.nextEvolutionId!)")
            evolutionLabel.text = "Next evolution: \(pokemon.nextEvolutionText!) (Lvl \(pokemon.nextEvolutionLevel!))"
        } else {
            nextEvolutionImage.hidden = true
            evolutionLabel.text = "This Pokémon does not evolve."
        }
        
        loader.stopAnimation()
        
    }
    
    @IBAction func backBtnPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
