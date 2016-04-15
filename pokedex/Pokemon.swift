//
//  Pokemon.swift
//  pokedex
//
//  Created by Joris Ooms on 15/04/16.
//  Copyright © 2016 Cup of Code. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Pokemon {
    private var _name: String!
    private var _resourceUrl: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _weight: String!
    private var _height: String!
    private var _defense: String!
    private var _attack: String!
    private var _nextEvolutionId: String?
    private var _nextEvolutionText: String?
    private var _nextEvolutionLevel: String?
    
    
    var name: String {
        return _name
    }
    
    var resourceUrl: String {
        return _resourceUrl
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    var description: String {
        get {
            if _description == nil {
                _description = ""
            }
            return _description
        }
    }
    
    var type: String {
        get {
            if _type == nil {
                _type = ""
            }
            return _type
        }
    }
    
    var weight: String {
        get {
            if _weight == nil {
                _weight = ""
            }
            return _weight
        }
    }
    
    var height: String {
        get {
            if _height == nil {
                _height = ""
            }
            return _height
        }
    }
    
    var defense: String {
        get {
            if _defense == nil {
                _defense = ""
            }
            return _defense
        }
    }
    
    var attack: String {
        get {
            if _attack == nil {
                _attack = ""
            }
            return _attack
        }
    }
    
    var nextEvolutionText: String? {
        get {
            if _nextEvolutionText == nil {
                _nextEvolutionText = ""
            }
            return _nextEvolutionText
        }
    }
    
    var nextEvolutionId: String? {
        get {
            if _nextEvolutionId == nil {
                _nextEvolutionId = ""
            }
            return _nextEvolutionId
        }
    }
    
    var nextEvolutionLevel: String? {
        get {
            if _nextEvolutionLevel == nil {
                _nextEvolutionLevel = ""
            }
            return _nextEvolutionLevel
        }
    }
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        self._resourceUrl = "\(URL_BASE)\(URL_API)\(self.pokedexId)/"
    }
    
    func fetchPokemonDetails(completed: DownloadComplete) {
        let url = NSURL(string: self.resourceUrl)!
        Alamofire.request(.GET, url).responseJSON { (response) in
            guard response.result.error == nil else {
                print("Error fetching Pokemon from API.")
                print(response.result.error!)
                return
            }
            
            if let value = response.result.value {
                let pokemon = JSON(value)
                
                if let descriptions = pokemon["descriptions"].array where descriptions.count > 0 {
                    if let descriptionUri = descriptions[0]["resource_uri"].string {
                        if let url = NSURL(string: "\(URL_BASE)\(descriptionUri)") {
                            Alamofire.request(.GET, url).responseJSON(completionHandler: { (response) in
                                if let value = response.result.value {
                                    let descriptionData = JSON(value)
                                    if let description = descriptionData["description"].string {
                                        self._description = description
                                        completed()
                                    }
                                }
                            })
                        }
                        
                    }
                } else {
                    self._description = ""
                }
                
                if let evolutions = pokemon["evolutions"].array where evolutions.count > 0 {
                    if let to = evolutions[0]["to"].string {
                        if to.rangeOfString("mega") == nil {
                            if let resourceUri = evolutions[0]["resource_uri"].string {
                                let stripped = resourceUri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                let id = stripped.stringByReplacingOccurrencesOfString("/", withString: "")
                                
                                self._nextEvolutionId = id
                                self._nextEvolutionText = to
                                
                                if let level = evolutions[0]["level"].int {
                                    self._nextEvolutionLevel = "\(level)"
                                }
                            }
                        }
                    }
                }
                
                if let types = pokemon["types"].array where types.count > 0 {
                    let types = types.map({ (type) -> String in
                        type["name"].string!.capitalizedString
                    })
                    self._type = types.joinWithSeparator("/")
                } else {
                    self._type = ""
                }
                
                if let weight = pokemon["weight"].string {
                    self._weight = weight
                }
                
                if let height = pokemon["height"].string {
                    self._height = height
                }
                
                if let attack = pokemon["attack"].int {
                    self._attack = "\(attack)"
                }
                
                if let defense = pokemon["defense"].int {
                    self._defense = "\(defense)"
                }
            }
        }
    }
}